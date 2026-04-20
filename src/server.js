require('dotenv').config();
const app = require('./app');
require('./config/database'); // Inicializar conexión

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🌱 AgroTraceability Backend corriendo en puerto ${PORT}`);
  console.log(`📡 Health check: http://localhost:${PORT}/api/health`);
});