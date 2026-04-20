const db = require('../config/database');

// Validar que el lote pertenece al productor
const validateLoteOwnership = async (loteId, productorId) => {
  const [rows] = await db.query(
    'SELECT id FROM lotes WHERE id = ? AND productor_id = ?',
    [loteId, productorId]
  );
  return rows.length > 0;
};

// POST /api/lotes/:loteId/eventos
const createEvento = async (req, res) => {
  const { loteId } = req.params;
  const { tipo_evento_id, fecha_evento, descripcion, observaciones } = req.body;
  const productorId = req.user.productor_id;
  const usuarioId = req.user.id;

  if (!tipo_evento_id || !fecha_evento) {
    return res.status(400).json({ error: 'tipo_evento_id y fecha_evento son obligatorios' });
  }

  try {
    // Verificar propiedad del lote
    const isOwner = await validateLoteOwnership(loteId, productorId);
    if (!isOwner) {
      return res.status(403).json({ error: 'No tienes permiso sobre este lote' });
    }

    // Verificar que el tipo de evento existe
    const [tipos] = await db.query('SELECT id FROM tipos_evento WHERE id = ?', [tipo_evento_id]);
    if (tipos.length === 0) {
      return res.status(400).json({ error: 'Tipo de evento no válido' });
    }

    const [result] = await db.query(
      `INSERT INTO eventos_productivos (lote_id, tipo_evento_id, usuario_id, fecha_evento, descripcion, observaciones)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [loteId, tipo_evento_id, usuarioId, fecha_evento, descripcion || null, observaciones || null]
    );

    const [evento] = await db.query(
      `SELECT ep.*, te.nombre as tipo_evento_nombre
       FROM eventos_productivos ep
       JOIN tipos_evento te ON ep.tipo_evento_id = te.id
       WHERE ep.id = ?`,
      [result.insertId]
    );

    res.status(201).json({ message: 'Evento registrado exitosamente', evento: evento[0] });
  } catch (err) {
    console.error('Error creando evento:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/lotes/:loteId/eventos
const getEventosByLote = async (req, res) => {
  const { loteId } = req.params;
  const productorId = req.user.productor_id;

  try {
    const isOwner = await validateLoteOwnership(loteId, productorId);
    if (!isOwner) {
      return res.status(403).json({ error: 'No tienes permiso sobre este lote' });
    }

    const [eventos] = await db.query(
      `SELECT ep.*, te.nombre as tipo_evento_nombre, te.icono as tipo_evento_icono,
              u.nombre as registrado_por_nombre, u.apellido as registrado_por_apellido
       FROM eventos_productivos ep
       JOIN tipos_evento te ON ep.tipo_evento_id = te.id
       JOIN users u ON ep.usuario_id = u.id
       WHERE ep.lote_id = ? AND ep.activo = TRUE
       ORDER BY ep.fecha_evento DESC, ep.created_at DESC`,
      [loteId]
    );

    res.json({ eventos });
  } catch (err) {
    console.error('Error listando eventos:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/eventos/:id
const getEventoById = async (req, res) => {
  const { id } = req.params;
  const productorId = req.user.productor_id;

  try {
    const [eventos] = await db.query(
      `SELECT ep.*, te.nombre as tipo_evento_nombre, te.icono as tipo_evento_icono,
              u.nombre as registrado_por_nombre, u.apellido as registrado_por_apellido,
              l.nombre as lote_nombre, l.codigo as lote_codigo
       FROM eventos_productivos ep
       JOIN tipos_evento te ON ep.tipo_evento_id = te.id
       JOIN users u ON ep.usuario_id = u.id
       JOIN lotes l ON ep.lote_id = l.id
       WHERE ep.id = ? AND l.productor_id = ?`,
      [id, productorId]
    );

    if (eventos.length === 0) {
      return res.status(404).json({ error: 'Evento no encontrado' });
    }

    // Obtener insumos del evento
    const [insumos] = await db.query(
      `SELECT ei.*, i.nombre as insumo_nombre, i.tipo as insumo_tipo, i.unidad_medida
       FROM evento_insumos ei
       JOIN insumos i ON ei.insumo_id = i.id
       WHERE ei.evento_id = ?`,
      [id]
    );

    res.json({ evento: { ...eventos[0], insumos } });
  } catch (err) {
    console.error('Error obteniendo evento:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// PUT /api/eventos/:id
const updateEvento = async (req, res) => {
  const { id } = req.params;
  const productorId = req.user.productor_id;
  const { tipo_evento_id, fecha_evento, descripcion, observaciones } = req.body;

  try {
    // Verificar propiedad
    const [eventos] = await db.query(
      `SELECT ep.id FROM eventos_productivos ep
       JOIN lotes l ON ep.lote_id = l.id
       WHERE ep.id = ? AND l.productor_id = ?`,
      [id, productorId]
    );

    if (eventos.length === 0) {
      return res.status(404).json({ error: 'Evento no encontrado' });
    }

    await db.query(
      `UPDATE eventos_productivos SET
        tipo_evento_id = COALESCE(?, tipo_evento_id),
        fecha_evento = COALESCE(?, fecha_evento),
        descripcion = COALESCE(?, descripcion),
        observaciones = COALESCE(?, observaciones)
       WHERE id = ?`,
      [tipo_evento_id, fecha_evento, descripcion, observaciones, id]
    );

    const [updated] = await db.query(
      `SELECT ep.*, te.nombre as tipo_evento_nombre
       FROM eventos_productivos ep
       JOIN tipos_evento te ON ep.tipo_evento_id = te.id
       WHERE ep.id = ?`,
      [id]
    );

    res.json({ message: 'Evento actualizado', evento: updated[0] });
  } catch (err) {
    console.error('Error actualizando evento:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

module.exports = { createEvento, getEventosByLote, getEventoById, updateEvento };