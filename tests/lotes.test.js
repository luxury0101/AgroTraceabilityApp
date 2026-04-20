// tests/lotes.test.js
// Pruebas de integración para el módulo de lotes

const request = require('supertest');
const app = require('../src/app');
const db = require('../src/config/database');

// Datos reutilizables
const testUser = {
  nombre: 'Lote',
  apellido: 'Tester',
  email: 'lote.tester@agro.com',
  username: 'lotetester',
  password: 'password123',
  documento: '5544332211',
  municipio: 'Barbosa',
};

const testLote = {
  nombre: 'Lote Test Automatizado',
  codigo: 'LT-TEST-01',
  ubicacion: 'Vereda de prueba',
  area_hectareas: 3.5,
  tipo_cultivo: 'Cacao',
  variedad: 'CCN-51',
};

let token;
let loteId;

// Setup: registrar usuario y hacer login
beforeAll(async () => {
  // Limpiar datos anteriores
  await db.query('DELETE FROM lotes WHERE codigo = ?', [testLote.codigo]);
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ?', [testUser.email]);

  // Registrar usuario de prueba
  await request(app).post('/api/auth/register').send(testUser);

  // Login para obtener token
  const loginRes = await request(app)
    .post('/api/auth/login')
    .send({ email: testUser.email, password: testUser.password });
  token = loginRes.body.token;
});

afterAll(async () => {
  await db.query('DELETE FROM lotes WHERE codigo = ?', [testLote.codigo]);
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ?', [testUser.email]);
  await db.end();
});

// ─────────────────────────────────────────────
// SUITE: POST /api/lotes
// ─────────────────────────────────────────────
describe('POST /api/lotes', () => {

  test('✅ Crea un lote con datos válidos', async () => {
    const res = await request(app)
      .post('/api/lotes')
      .set('Authorization', `Bearer ${token}`)
      .send(testLote);

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('lote');
    expect(res.body.lote.nombre).toBe(testLote.nombre);
    expect(res.body.lote.codigo).toBe(testLote.codigo);
    expect(res.body.lote.estado).toBe('activo');

    // Guardar id para tests siguientes
    loteId = res.body.lote.id;
  });

  test('❌ Falla sin nombre (400)', async () => {
    const res = await request(app)
      .post('/api/lotes')
      .set('Authorization', `Bearer ${token}`)
      .send({ codigo: 'LT-SIN-NOMBRE' });

    expect(res.statusCode).toBe(400);
  });

  test('❌ Falla sin token (401)', async () => {
    const res = await request(app)
      .post('/api/lotes')
      .send(testLote);

    expect(res.statusCode).toBe(401);
  });

  test('❌ Falla con código duplicado (409)', async () => {
    const res = await request(app)
      .post('/api/lotes')
      .set('Authorization', `Bearer ${token}`)
      .send(testLote); // mismo código

    expect(res.statusCode).toBe(409);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/lotes
// ─────────────────────────────────────────────
describe('GET /api/lotes', () => {

  test('✅ Lista lotes del productor autenticado', async () => {
    const res = await request(app)
      .get('/api/lotes')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('lotes');
    expect(Array.isArray(res.body.lotes)).toBe(true);
    expect(res.body.lotes.length).toBeGreaterThan(0);
  });

  test('❌ Falla sin autenticación (401)', async () => {
    const res = await request(app).get('/api/lotes');
    expect(res.statusCode).toBe(401);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/lotes/:id
// ─────────────────────────────────────────────
describe('GET /api/lotes/:id', () => {

  test('✅ Obtiene detalle del lote', async () => {
    const res = await request(app)
      .get(`/api/lotes/${loteId}`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.lote.id).toBe(loteId);
    expect(res.body.lote.nombre).toBe(testLote.nombre);
  });

  test('❌ Retorna 404 si el lote no existe', async () => {
    const res = await request(app)
      .get('/api/lotes/99999')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });

});

// ─────────────────────────────────────────────
// SUITE: PUT /api/lotes/:id
// ─────────────────────────────────────────────
describe('PUT /api/lotes/:id', () => {

  test('✅ Actualiza el nombre del lote', async () => {
    const res = await request(app)
      .put(`/api/lotes/${loteId}`)
      .set('Authorization', `Bearer ${token}`)
      .send({ nombre: 'Lote Test Actualizado', estado: 'en_produccion' });

    expect(res.statusCode).toBe(200);
    expect(res.body.lote.nombre).toBe('Lote Test Actualizado');
    expect(res.body.lote.estado).toBe('en_produccion');
  });

  test('❌ Retorna 404 al editar lote inexistente', async () => {
    const res = await request(app)
      .put('/api/lotes/99999')
      .set('Authorization', `Bearer ${token}`)
      .send({ nombre: 'Fantasma' });

    expect(res.statusCode).toBe(404);
  });

});