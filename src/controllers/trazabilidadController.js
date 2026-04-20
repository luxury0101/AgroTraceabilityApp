const db = require('../config/database');

// GET /api/trazabilidad/lote/:id
const getTrazabilidadLote = async (req, res) => {
  const { id } = req.params;
  const productorId = req.user.productor_id;

  try {
    // Obtener datos del lote con productor
    const [lotes] = await db.query(
      `SELECT l.*, 
              p.documento as productor_documento,
              u.nombre as productor_nombre, u.apellido as productor_apellido,
              p.telefono as productor_telefono, p.municipio, p.departamento
       FROM lotes l
       JOIN productores p ON l.productor_id = p.id
       JOIN users u ON p.user_id = u.id
       WHERE l.id = ? AND l.productor_id = ?`,
      [id, productorId]
    );

    if (lotes.length === 0) {
      return res.status(404).json({ error: 'Lote no encontrado' });
    }

    const lote = lotes[0];

    // Obtener todos los eventos del lote con insumos
    const [eventos] = await db.query(
      `SELECT ep.id, ep.fecha_evento, ep.descripcion, ep.observaciones, ep.created_at,
              te.nombre as tipo_evento, te.icono,
              u.nombre as registrado_por_nombre, u.apellido as registrado_por_apellido
       FROM eventos_productivos ep
       JOIN tipos_evento te ON ep.tipo_evento_id = te.id
       JOIN users u ON ep.usuario_id = u.id
       WHERE ep.lote_id = ? AND ep.activo = TRUE
       ORDER BY ep.fecha_evento ASC, ep.created_at ASC`,
      [id]
    );

    // Para cada evento, obtener sus insumos
    const eventosConInsumos = await Promise.all(
      eventos.map(async (evento) => {
        const [insumos] = await db.query(
          `SELECT ei.cantidad, ei.observaciones,
                  i.nombre as insumo, i.tipo as tipo_insumo, i.unidad_medida
           FROM evento_insumos ei
           JOIN insumos i ON ei.insumo_id = i.id
           WHERE ei.evento_id = ?`,
          [evento.id]
        );
        return { ...evento, insumos };
      })
    );

    const trazabilidad = {
      lote: {
        id: lote.id,
        codigo: lote.codigo,
        nombre: lote.nombre,
        ubicacion: lote.ubicacion,
        area_hectareas: lote.area_hectareas,
        tipo_cultivo: lote.tipo_cultivo,
        variedad: lote.variedad,
        estado: lote.estado,
        fecha_siembra_estimada: lote.fecha_siembra_estimada,
        fecha_cosecha_estimada: lote.fecha_cosecha_estimada,
      },
      productor: {
        nombre: `${lote.productor_nombre} ${lote.productor_apellido}`,
        documento: lote.productor_documento,
        municipio: lote.municipio,
        departamento: lote.departamento,
      },
      total_eventos: eventosConInsumos.length,
      eventos: eventosConInsumos,
      generado_en: new Date().toISOString(),
    };

    res.json({ trazabilidad });
  } catch (err) {
    console.error('Error en trazabilidad:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/tipos-evento
const getTiposEvento = async (req, res) => {
  try {
    const [tipos] = await db.query('SELECT * FROM tipos_evento ORDER BY nombre');
    res.json({ tipos });
  } catch (err) {
    console.error('Error listando tipos de evento:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

module.exports = { getTrazabilidadLote, getTiposEvento };