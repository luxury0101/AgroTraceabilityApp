const express = require('express');
const router = express.Router();
const { createLote, getLotes, getLoteById, updateLote } = require('../controllers/lotesController');
const auth = require('../middleware/auth');

router.use(auth); // Todas las rutas de lotes requieren autenticación

router.post('/', createLote);
router.get('/', getLotes);
router.get('/:id', getLoteById);
router.put('/:id', updateLote);

module.exports = router;