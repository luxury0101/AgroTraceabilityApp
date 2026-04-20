// tests/eventos.test.js
// Pruebas de integración para eventos productivos y trazabilidad

const request = require('supertest');
const app = require('../src/app');
const db = require('../src/config/database');

const testUser = {
  nombre: 'Evento',
  apellido: 'Tester',
  email: 'evento.tester@agro.com',
  username: 'eventotester',
  password: 'password123',
  documento: '1122334455',
  municipio: 'Barbosa',
};

const testLote = {
  nombre: 'Lote Para Eventos',
  codigo: 'LT-EV-001',
  tipo_cultivo: 'Café',
  variedad: 'Castillo',
};

let token;
let loteId;
let eventoId;

beforeAll(async () => {
  // Limpiar
  await db.query(`
    DELETE ei FROM evento_insumos ei
    JOIN eventos_productivos ep ON ei.evento_id = ep.id
    JOIN lotes l ON ep.lote_id = l.id
    WHERE l.codigo = ?`, [testLote.codigo]);
  await db.query(`
    DELETE FROM eventos_productivos WHERE lote_id IN (SELECT id FROM lotes WHERE codigo = ?)`, [testLote.codigo]);
  await db.query('DELETE FROM lotes WHERE codigo = ?', [testLote.codigo]);
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ?', [testUser.email]);

  // Registrar y login
  await request(app).post('/api/auth/register').send(testUser);
  const loginRes = await request(app)
    .post('/api/auth/login')
    .send({ email: testUser.email, password: testUser.password });
  token = loginRes.body.token;

  // Crear lote de prueba
  const loteRes = await request(app)
    .post('/api/lotes')
    .set('Authorization', `Bearer ${token}`)
    .send(testLote);
  loteId = loteRes.body.lote.id;
});

afterAll(async () => {
  await db.query(`
    DELETE ei FROM evento_insumos ei
    JOIN eventos_productivos ep ON ei.evento_id = ep.id
    JOIN lotes l ON ep.lote_id = l.id
    WHERE l.codigo = ?`, [testLote.codigo]);
  await db.query(`
    DELETE FROM eventos_productivos WHERE lote_id IN (SELECT id FROM lotes WHERE codigo = ?)`, [testLote.codigo]);
  await db.query('DELETE FROM lotes WHERE codigo = ?', [testLote.codigo]);
  await db.query('DELETE FROM productores WHERE documento = ?', [testUser.documento]);
  await db.query('DELETE FROM users WHERE email = ?', [testUser.email]);
  await db.end();
});

// ─────────────────────────────────────────────
// SUITE: GET /api/tipos-evento
// ─────────────────────────────────────────────
describe('GET /api/tipos-evento', () => {

  test('✅ Retorna catálogo de tipos de evento', async () => {
    const res = await request(app)
      .get('/api/tipos-evento')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('tipos');
    expect(Array.isArray(res.body.tipos)).toBe(true);
    // ⚠️ Depende de los datos semilla del script database.sql
    // Si los tipos cambian, este número cambia también
    expect(res.body.tipos.length).toBeGreaterThanOrEqual(1);

    // Verificar estructura de un tipo
    const tipo = res.body.tipos[0];
    expect(tipo).toHaveProperty('id');
    expect(tipo).toHaveProperty('nombre');
  });

});

// ─────────────────────────────────────────────
// SUITE: POST /api/lotes/:loteId/eventos
// ─────────────────────────────────────────────
describe('POST /api/lotes/:loteId/eventos', () => {

  test('✅ Registra evento con tipo_evento_id = 1 (Siembra)', async () => {
    const res = await request(app)
      .post(`/api/lotes/${loteId}/eventos`)
      .set('Authorization', `Bearer ${token}`)
      .send({
        tipo_evento_id: 1,
        fecha_evento: '2025-03-01',
        descripcion: 'Siembra de café variedad Castillo',
        observaciones: 'Suelo húmedo, buen clima',
      });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('evento');
    expect(res.body.evento.tipo_evento_id).toBe(1);
    expect(res.body.evento.lote_id).toBe(loteId);

    eventoId = res.body.evento.id;
  });

  test('❌ Falla sin fecha_evento (400)', async () => {
    const res = await request(app)
      .post(`/api/lotes/${loteId}/eventos`)
      .set('Authorization', `Bearer ${token}`)
      .send({ tipo_evento_id: 1, descripcion: 'Sin fecha' });

    expect(res.statusCode).toBe(400);
  });

  test('❌ Falla con tipo_evento_id inexistente (400)', async () => {
    const res = await request(app)
      .post(`/api/lotes/${loteId}/eventos`)
      .set('Authorization', `Bearer ${token}`)
      .send({ tipo_evento_id: 99999, fecha_evento: '2025-03-01' });

    expect(res.statusCode).toBe(400);
  });

  test('❌ Falla si el lote no pertenece al usuario (403)', async () => {
    const res = await request(app)
      .post('/api/lotes/99999/eventos')
      .set('Authorization', `Bearer ${token}`)
      .send({ tipo_evento_id: 1, fecha_evento: '2025-03-01' });

    expect(res.statusCode).toBe(403);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/lotes/:loteId/eventos
// ─────────────────────────────────────────────
describe('GET /api/lotes/:loteId/eventos', () => {

  test('✅ Lista eventos del lote en orden cronológico', async () => {
    const res = await request(app)
      .get(`/api/lotes/${loteId}/eventos`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('eventos');
    expect(Array.isArray(res.body.eventos)).toBe(true);
    expect(res.body.eventos.length).toBeGreaterThan(0);

    // Verificar que viene el nombre del tipo de evento
    expect(res.body.eventos[0]).toHaveProperty('tipo_evento_nombre');
  });

});

// ─────────────────────────────────────────────
// SUITE: POST /api/eventos/:eventoId/insumos
// ─────────────────────────────────────────────
describe('POST /api/eventos/:eventoId/insumos', () => {

  test('✅ Agrega insumo a un evento', async () => {
    const res = await request(app)
      .post(`/api/eventos/${eventoId}/insumos`)
      .set('Authorization', `Bearer ${token}`)
      .send({
        nombre: 'Fertilizante NPK',
        tipo: 'fertilizante',
        unidad_medida: 'kg',
        cantidad: 25.5,
        observaciones: 'Aplicado en banda',
      });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('evento_insumo');
    expect(res.body.evento_insumo.insumo_nombre).toBe('Fertilizante NPK');
  });

  test('❌ Falla sin cantidad (400)', async () => {
    const res = await request(app)
      .post(`/api/eventos/${eventoId}/insumos`)
      .set('Authorization', `Bearer ${token}`)
      .send({ nombre: 'Sin cantidad' });

    expect(res.statusCode).toBe(400);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/trazabilidad/lote/:id
// ─────────────────────────────────────────────
describe('GET /api/trazabilidad/lote/:id', () => {

  test('✅ Retorna trazabilidad completa del lote con eventos e insumos', async () => {
    const res = await request(app)
      .get(`/api/trazabilidad/lote/${loteId}`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('trazabilidad');

    const t = res.body.trazabilidad;
    expect(t).toHaveProperty('lote');
    expect(t).toHaveProperty('productor');
    expect(t).toHaveProperty('eventos');
    expect(t).toHaveProperty('total_eventos');
    expect(t).toHaveProperty('generado_en');

    // El lote debe tener datos correctos
    expect(t.lote.id).toBe(loteId);

    // Debe haber al menos el evento que creamos
    expect(t.total_eventos).toBeGreaterThan(0);
    expect(t.eventos.length).toBeGreaterThan(0);

    // El evento debe tener sus insumos
    const primerEvento = t.eventos[0];
    expect(primerEvento).toHaveProperty('insumos');
    expect(Array.isArray(primerEvento.insumos)).toBe(true);
    expect(primerEvento.insumos.length).toBeGreaterThan(0);
  });

  test('❌ Retorna 404 si el lote no existe', async () => {
    const res = await request(app)
      .get('/api/trazabilidad/lote/99999')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });

  test('❌ Falla sin autenticación (401)', async () => {
    const res = await request(app)
      .get(`/api/trazabilidad/lote/${loteId}`);

    expect(res.statusCode).toBe(401);
  });

});

// ─────────────────────────────────────────────
// SUITE: GET /api/eventos/:id
// ─────────────────────────────────────────────
describe('GET /api/eventos/:id', () => {

  test('✅ Retorna detalle del evento con insumos', async () => {
    const res = await request(app)
      .get(`/api/eventos/${eventoId}`)
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.evento.id).toBe(eventoId);
    expect(res.body.evento).toHaveProperty('insumos');
  });

  test('❌ Retorna 404 si el evento no existe', async () => {
    const res = await request(app)
      .get('/api/eventos/99999')
      .set('Authorization', `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });

});