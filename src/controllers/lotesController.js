const db = require('../config/database');

// POST /api/lotes
const createLote = async (req, res) => {
  const { nombre, codigo, ubicacion, area_hectareas, tipo_cultivo, variedad,
          fecha_siembra_estimada, fecha_cosecha_estimada, observaciones } = req.body;

  if (!nombre || !codigo) {
    return res.status(400).json({ error: 'Nombre y código del lote son obligatorios' });
  }

  const productorId = req.user.productor_id;
  if (!productorId) {
    return res.status(403).json({ error: 'Solo productores pueden crear lotes' });
  }

  try {
    const [result] = await db.query(
      `INSERT INTO lotes (productor_id, codigo, nombre, ubicacion, area_hectareas,
        tipo_cultivo, variedad, fecha_siembra_estimada, fecha_cosecha_estimada, observaciones)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [productorId, codigo, nombre, ubicacion || null, area_hectareas || null,
       tipo_cultivo || null, variedad || null, fecha_siembra_estimada || null,
       fecha_cosecha_estimada || null, observaciones || null]
    );

    const [lote] = await db.query('SELECT * FROM lotes WHERE id = ?', [result.insertId]);

    res.status(201).json({ message: 'Lote creado exitosamente', lote: lote[0] });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Ya existe un lote con ese código para este productor' });
    }
    console.error('Error creando lote:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/lotes
const getLotes = async (req, res) => {
  const productorId = req.user.productor_id;

  try {
    const [lotes] = await db.query(
      `SELECT l.*, 
        (SELECT COUNT(*) FROM eventos_productivos ep WHERE ep.lote_id = l.id AND ep.activo = TRUE) as total_eventos
       FROM lotes l
       WHERE l.productor_id = ?
       ORDER BY l.created_at DESC`,
      [productorId]
    );

    res.json({ lotes });
  } catch (err) {
    console.error('Error listando lotes:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/lotes/:id
const getLoteById = async (req, res) => {
  const { id } = req.params;
  const productorId = req.user.productor_id;

  try {
    const [lotes] = await db.query(
      `SELECT l.*, p.documento as productor_documento,
              u.nombre as productor_nombre, u.apellido as productor_apellido
       FROM lotes l
       JOIN productores p ON l.productor_id = p.id
       JOIN users u ON p.user_id = u.id
       WHERE l.id = ? AND l.productor_id = ?`,
      [id, productorId]
    );

    if (lotes.length === 0) {
      return res.status(404).json({ error: 'Lote no encontrado' });
    }

    res.json({ lote: lotes[0] });
  } catch (err) {
    console.error('Error obteniendo lote:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// PUT /api/lotes/:id
const updateLote = async (req, res) => {
  const { id } = req.params;
  const productorId = req.user.productor_id;
  const { nombre, ubicacion, area_hectareas, tipo_cultivo, variedad,
          fecha_siembra_estimada, fecha_cosecha_estimada, estado, observaciones } = req.body;

  try {
    // Verificar propiedad
    const [existing] = await db.query(
      'SELECT id FROM lotes WHERE id = ? AND productor_id = ?',
      [id, productorId]
    );

    if (existing.length === 0) {
      return res.status(404).json({ error: 'Lote no encontrado' });
    }

    await db.query(
      `UPDATE lotes SET nombre = COALESCE(?, nombre), ubicacion = COALESCE(?, ubicacion),
        area_hectareas = COALESCE(?, area_hectareas), tipo_cultivo = COALESCE(?, tipo_cultivo),
        variedad = COALESCE(?, variedad), fecha_siembra_estimada = COALESCE(?, fecha_siembra_estimada),
        fecha_cosecha_estimada = COALESCE(?, fecha_cosecha_estimada), estado = COALESCE(?, estado),
        observaciones = COALESCE(?, observaciones)
       WHERE id = ?`,
      [nombre, ubicacion, area_hectareas, tipo_cultivo, variedad,
       fecha_siembra_estimada, fecha_cosecha_estimada, estado, observaciones, id]
    );

    const [updated] = await db.query('SELECT * FROM lotes WHERE id = ?', [id]);

    res.json({ message: 'Lote actualizado', lote: updated[0] });
  } catch (err) {
    console.error('Error actualizando lote:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

module.exports = { createLote, getLotes, getLoteById, updateLote };