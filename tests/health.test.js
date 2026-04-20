// tests/health.test.js
// Pruebas del health check y del middleware JWT

const request = require('supertest');
const app = require('../src/app'); // <--- 1. Faltaba importar la app
const db = require('../src/config/database'); // <--- 2. Corregida la ruta (sin la / inicial)

afterAll(async () => {
  await db.end();
});

// ─────────────────────────────────────────────
// SUITE: Health Check
// ─────────────────────────────────────────────
describe('GET /api/health', () => {

  test('✅ Retorna status ok', async () => {
    const res = await request(app).get('/api/health');

    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('ok');
    expect(res.body).toHaveProperty('timestamp');
  });

});

// ─────────────────────────────────────────────
// SUITE: Middleware JWT (auth.js)
// ─────────────────────────────────────────────
describe('Middleware JWT', () => {

  test('❌ Ruta protegida sin token retorna 401', async () => {
    const res = await request(app).get('/api/lotes');
    expect(res.statusCode).toBe(401);
    expect(res.body).toHaveProperty('error');
  });

  test('❌ Token con formato incorrecto retorna 401', async () => {
    const res = await request(app)
      .get('/api/lotes')
      .set('Authorization', 'NotBearer token123');
    expect(res.statusCode).toBe(401);
  });

  test('❌ Token manipulado retorna 401', async () => {
    const res = await request(app)
      .get('/api/lotes')
      .set('Authorization', 'Bearer eyJhbGciOiJIUzI1NiJ9.manipulado.firma_falsa');
    expect(res.statusCode).toBe(401);
  });

  test('❌ Ruta inexistente retorna 401 o 404', async () => {
  const res = await request(app).get('/api/ruta-que-no-existe');
  // Cambiamos 404 por 401 porque el middleware de auth responde primero
  expect(res.statusCode).toBe(401); 
});

});