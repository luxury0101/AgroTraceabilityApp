const app = require('./app');
const env = require('./config/env');
const pool = require('./config/db');

async function startServer() {
  try {
    await pool.query('SELECT 1');
    console.log('PostgreSQL connected successfully');

    app.listen(env.port, () => {
      console.log(`Server running on http://localhost:${env.port}`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();