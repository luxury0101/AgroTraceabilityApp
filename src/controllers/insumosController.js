const db = require('../config/database');

// POST /api/eventos/:eventoId/insumos
const addInsumoToEvento = async (req, res) => {
  const { eventoId } = req.params;
  const { insumo_id, nombre, tipo, unidad_medida, cantidad, observaciones } = req.body;
  const productorId = req.user.productor_id;

  if (!cantidad) {
    return res.status(400).json({ error: 'La cantidad es obligatoria' });
  }

  try {
    // Verificar propiedad del evento
    const [eventos] = await db.query(
      `SELECT ep.id FROM eventos_productivos ep
       JOIN lotes l ON ep.lote_id = l.id
       WHERE ep.id = ? AND l.productor_id = ?`,
      [eventoId, productorId]
    );

    if (eventos.length === 0) {
      return res.status(403).json({ error: 'No tienes permiso sobre este evento' });
    }

    let finalInsumoId = insumo_id;

    // Si no viene insumo_id, crear uno nuevo
    if (!finalInsumoId) {
      if (!nombre) {
        return res.status(400).json({ error: 'Se requiere insumo_id o nombre del insumo' });
      }
      const [result] = await db.query(
        'INSERT INTO insumos (nombre, tipo, unidad_medida) VALUES (?, ?, ?)',
        [nombre, tipo || null, unidad_medida || null]
      );
      finalInsumoId = result.insertId;
    }

    const [result] = await db.query(
      'INSERT INTO evento_insumos (evento_id, insumo_id, cantidad, observaciones) VALUES (?, ?, ?, ?)',
      [eventoId, finalInsumoId, cantidad, observaciones || null]
    );

    const [inserted] = await db.query(
      `SELECT ei.*, i.nombre as insumo_nombre, i.tipo as insumo_tipo, i.unidad_medida
       FROM evento_insumos ei
       JOIN insumos i ON ei.insumo_id = i.id
       WHERE ei.id = ?`,
      [result.insertId]
    );

    res.status(201).json({ message: 'Insumo asociado al evento', evento_insumo: inserted[0] });
  } catch (err) {
    console.error('Error asociando insumo:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/eventos/:eventoId/insumos
const getInsumosByEvento = async (req, res) => {
  const { eventoId } = req.params;
  const productorId = req.user.productor_id;

  try {
    // Verificar propiedad
    const [eventos] = await db.query(
      `SELECT ep.id FROM eventos_productivos ep
       JOIN lotes l ON ep.lote_id = l.id
       WHERE ep.id = ? AND l.productor_id = ?`,
      [eventoId, productorId]
    );

    if (eventos.length === 0) {
      return res.status(403).json({ error: 'No tienes permiso sobre este evento' });
    }

    const [insumos] = await db.query(
      `SELECT ei.*, i.nombre as insumo_nombre, i.tipo as insumo_tipo, i.unidad_medida
       FROM evento_insumos ei
       JOIN insumos i ON ei.insumo_id = i.id
       WHERE ei.evento_id = ?`,
      [eventoId]
    );

    res.json({ insumos });
  } catch (err) {
    console.error('Error listando insumos:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/insumos (catálogo)
const getInsumosCatalog = async (req, res) => {
  try {
    const [insumos] = await db.query(
      'SELECT * FROM insumos WHERE activo = TRUE ORDER BY nombre'
    );
    res.json({ insumos });
  } catch (err) {
    console.error('Error en catálogo de insumos:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

module.exports = { addInsumoToEvento, getInsumosByEvento, getInsumosCatalog };