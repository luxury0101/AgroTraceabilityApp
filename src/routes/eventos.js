const express = require('express');
const router = express.Router();
const { createEvento, getEventosByLote, getEventoById, updateEvento } = require('../controllers/eventosController');
const { addInsumoToEvento, getInsumosByEvento } = require('../controllers/insumosController');
const auth = require('../middleware/auth');

router.use(auth);

// Eventos de un lote
router.post('/lotes/:loteId/eventos', createEvento);
router.get('/lotes/:loteId/eventos', getEventosByLote);

// Evento individual
router.get('/eventos/:id', getEventoById);
router.put('/eventos/:id', updateEvento);

// Insumos de un evento
router.post('/eventos/:eventoId/insumos', addInsumoToEvento);
router.get('/eventos/:eventoId/insumos', getInsumosByEvento);

module.exports = router;