const express = require('express');
const router = express.Router();
const { getTrazabilidadLote, getTiposEvento } = require('../controllers/trazabilidadController');
const { getInsumosCatalog } = require('../controllers/insumosController');
const auth = require('../middleware/auth');

router.use(auth);

router.get('/trazabilidad/lote/:id', getTrazabilidadLote);
router.get('/tipos-evento', getTiposEvento);
router.get('/insumos', getInsumosCatalog);

module.exports = router;