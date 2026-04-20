// tests/auth.test.js
// Pruebas de integración para el módulo de autenticación
// Usa supertest para hacer requests HTTP reales contra la app Express

const request = require('supertest');
const app = require('../src/app');
const db = require('../src/config/database');

// Usuario base para pruebas (se limpia antes de cada test)
const testUser = {
  nombre: 'Test',
  apellido: 'Productor',
  email: 'test.productor@agro.com',
  username: 'testproductor',
  password: 'password123',
  documento: '9988776655',
  telefono: '3001234567',
  municipio: 'Barbosa',
};

// Antes de todos los tests: limpiar datos de prueba
beforeAll(async () => {
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ? OR username = ?', [testUser.email, testUser.username]);
});

// Después de todos los tests: limpiar y cerrar conexión
afterAll(async () => {
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ? OR username = ?', [testUser.email, testUser.username]);
  await db.end();
});

// ─────────────────────────────────────────────
// SUITE: POST /api/auth/register
// ─────────────────────────────────────────────
describe('POST /api/auth/register', () => {

  test('✅ Registra un nuevo productor con datos válidos', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send(testUser);

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('message');
    expect(res.body).toHaveProperty('user');
    expect(res.body.user).toHaveProperty('id');
    expect(res.body.user.email).toBe(testUser.email);
    expect(res.body.user.rol).toBe('productor');
    // ⚠️ La password NUNCA debe aparecer en la respuesta
    expect(res.body.user).not.toHaveProperty('password');
  });

  test('❌ Falla con campos obligatorios faltantes', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ nombre: 'Incompleto', email: 'incompleto@test.com' });

    expect(res.statusCode).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  test('❌ Falla si el email ya está registrado (409)', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ ...testUser, username: 'otrousuario', documento: '1112223334' });

    expect(res.statusCode).toBe(409);
    expect(res.body.error).toMatch(/email|username|registrado/i);
  });

  test('❌ Falla si el documento ya está registrado (409)', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ ...testUser, email: 'nuevo@test.com', username: 'nuevousuario' });

    expect(res.statusCode).toBe(409);
  });

});

// ─────────────────────────────────────────────
// SUITE: POST /api/auth/login
// ─────────────────────────────────────────────
describe('POST /api/auth/login', () => {

  test('✅ Login exitoso con credenciales válidas', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: testUser.password });

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('token');
    expect(res.body).toHaveProperty('user');
    expect(typeof res.body.token).toBe('string');
    expect(res.body.token.length).toBeGreaterThan(10);
    expect(res.body.user).not.toHaveProperty('password');
  });

  test('❌ Falla con contraseña incorrecta (401)', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: 'wrong_password' });

    expect(res.statusCode).toBe(401);
    expect(res.body).toHaveProperty('error');
  });

  test('❌ Falla con email inexistente (401)', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'noexiste@test.com', password: '123456' });

    expect(res.statusCode).toBe(401);
  });

  test('❌ Falla sin body (400)', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({});

    expect(res.statusCode).toBe(400);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/auth/profile
// ─────────────────────────────────────────────
describe('GET /api/auth/profile', () => {
  let token;

  beforeAll(async () => {
    // Login para obtener token
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: testUser.email, password: testUser.password });
    token = res.body.token;
  });

  test('✅ Retorna perfil del usuario autenticado', async () => {
    const res = await request(app)
      .get('/api/auth/profile')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.user.email).toBe(testUser.email);
    expect(res.body.user).not.toHaveProperty('password');
  });

  test('❌ Falla sin token (401)', async () => {
    const res = await request(app).get('/api/auth/profile');
    expect(res.statusCode).toBe(401);
  });

  test('❌ Falla con token inválido (401)', async () => {
    const res = await request(app)
      .get('/api/auth/profile')
      .set('Authorization', 'Bearer token_completamente_invalido');
    expect(res.statusCode).toBe(401);
  });

});