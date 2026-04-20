const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'agrotraceability_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Test de conexión al arrancar
pool.getConnection()
  .then((conn) => {
    console.log('✅ MySQL conectado exitosamente');
    conn.release();
  })
  .catch((err) => {
    console.error('❌ Error de conexión MySQL:', err.message);
  });

module.exports = pool;