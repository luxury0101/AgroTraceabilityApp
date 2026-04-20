const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const lotesRoutes = require('./routes/lotes');
const eventosRoutes = require('./routes/eventos');
const trazabilidadRoutes = require('./routes/trazabilidad');

const app = express();

// Middlewares globales
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/lotes', lotesRoutes);
app.use('/api', eventosRoutes);
app.use('/api', trazabilidadRoutes);
    
// Manejo de rutas no encontradas
app.use((req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

// Manejo global de errores
app.use((err, req, res, next) => {
  console.error('Error no controlado:', err);
  res.status(500).json({ error: 'Error interno del servidor' });
});

module.exports = app;