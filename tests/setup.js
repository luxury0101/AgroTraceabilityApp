// tests/setup.js
process.env.NODE_ENV = 'test';
process.env.PORT = '3001';
process.env.JWT_SECRET = 'test_secret_agrotraceability_ci';
process.env.JWT_EXPIRES_IN = '1h';

// Configuración para que conecte a tu DB de TEST
process.env.DB_HOST = 'localhost';
process.env.DB_PORT = '3306';
process.env.DB_USER = 'root';
process.env.DB_PASSWORD = 'Camilo12345_'; // Pon tu contraseña aquí
process.env.DB_NAME = 'agrotraceability_test'; // Usa la base de datos nueva