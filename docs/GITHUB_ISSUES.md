# 📋 AgroTraceability — GitHub Issues (Backlog)

> Metodología: Kanban con enfoque iterativo.  
> Convención de ramas: `feature/ISSUE-XX-descripcion-corta`  
> Cada PR se linkea a su issue hija con `Closes #XX`

---

## 🏷️ Labels sugeridos

| Label | Color | Uso |
|-------|-------|-----|
| `epic` | `#6A0DAD` | Issue padre (agrupa funcionalidad) |
| `backend` | `#0075CA` | Tareas de servidor Node.js |
| `database` | `#E4E669` | Tareas de modelo/script BD |
| `frontend` | `#1D76DB` | Tareas de Flutter |
| `must-have` | `#D73A4A` | Prioridad alta (MVP) |
| `should-have` | `#FBCA04` | Prioridad media |
| `docs` | `#0E8A16` | Documentación |

---

## EPIC 1 — Configuración inicial del proyecto

**Issue #1 (Epic):** `[EPIC] Configuración inicial del proyecto backend`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
Configurar el repositorio, estructura de carpetas, dependencias y scripts base para el servidor Node.js + MySQL.

### Issues hijas:

---

**Issue #2:** `Inicializar proyecto Node.js con Express y dependencias base`  
**Labels:** `backend`, `must-have`  
**Parent:** #1  
**Descripción:**  
Crear el `package.json`, instalar Express, dotenv, cors, mysql2, bcryptjs, jsonwebtoken.  
Configurar estructura de carpetas: `src/config`, `src/routes`, `src/controllers`, `src/models`, `src/middleware`.  
Crear archivo `src/app.js` y `src/server.js`.

**Criterios de aceptación:**  
- [ ] `npm install` funciona sin errores  
- [ ] `npm run dev` levanta el servidor en puerto configurable  
- [ ] Endpoint `GET /api/health` responde `{ status: "ok" }`  

**Rama:** `feature/002-init-node-project`  
**PR:** `Closes #2`

---

**Issue #3:** `Crear script de base de datos MySQL (DDL)`  
**Labels:** `database`, `must-have`  
**Parent:** #1  
**Descripción:**  
Crear script SQL que genere la base de datos `agrotraceability_db` con todas las tablas del modelo:  
- `roles`  
- `users`  
- `productores`  
- `lotes`  
- `tipos_evento`  
- `eventos_productivos`  
- `insumos`  
- `evento_insumos`  
- `evidencias`  
- `auditoria`  

Incluir datos semilla para `roles` y `tipos_evento`.

**Criterios de aceptación:**  
- [ ] Script ejecuta sin errores en MySQL 8+  
- [ ] Tablas creadas con relaciones FK correctas  
- [ ] Datos semilla insertados (roles: admin, productor, operario | tipos_evento: siembra, riego, fertilización, cosecha, incidencia)  

**Rama:** `feature/003-database-schema`  
**PR:** `Closes #3`

---

**Issue #4:** `Configurar conexión a MySQL desde Node.js`  
**Labels:** `backend`, `database`, `must-have`  
**Parent:** #1  
**Descripción:**  
Crear pool de conexiones MySQL usando `mysql2/promise`.  
Variables de entorno en `.env`: `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_PORT`.  
Crear archivo `src/config/database.js`.

**Criterios de aceptación:**  
- [ ] Pool de conexiones funcional  
- [ ] Manejo de errores de conexión  
- [ ] `.env.example` con variables documentadas  

**Rama:** `feature/004-db-connection`  
**PR:** `Closes #4`

---

## EPIC 2 — Módulo de Autenticación

**Issue #5 (Epic):** `[EPIC] Módulo de autenticación de usuarios`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
Implementar registro, login y middleware JWT para el productor agrícola.

### Issues hijas:

---

**Issue #6:** `Implementar endpoint de registro de usuario (POST /api/auth/register)`  
**Labels:** `backend`, `must-have`  
**Parent:** #5  
**Descripción:**  
El productor puede auto-registrarse. Se crea registro en `users` con rol `productor` y registro asociado en tabla `productores`.  
Hashear contraseña con bcrypt. Validar campos obligatorios: nombre, apellido, email, username, password, documento.

**Criterios de aceptación:**  
- [ ] Registro exitoso retorna `201` con datos del usuario (sin password)  
- [ ] Password hasheada en BD  
- [ ] Email y username únicos (retorna `409` si duplicado)  
- [ ] Validación de campos obligatorios (retorna `400`)  

**Rama:** `feature/006-auth-register`  
**PR:** `Closes #6`

---

**Issue #7:** `Implementar endpoint de login (POST /api/auth/login)`  
**Labels:** `backend`, `must-have`  
**Parent:** #5  
**Descripción:**  
El usuario se autentica con email/username + password.  
Si credenciales válidas, generar JWT con `user_id`, `role_id`, `username`.  
Token expira en 24h.

**Criterios de aceptación:**  
- [ ] Login exitoso retorna `200` con `{ token, user }` 
- [ ] Credenciales inválidas retorna `401`  
- [ ] Token JWT válido y decodificable  

**Rama:** `feature/007-auth-login`  
**PR:** `Closes #7`

---

**Issue #8:** `Implementar middleware de autenticación JWT`  
**Labels:** `backend`, `must-have`  
**Parent:** #5  
**Descripción:**  
Crear middleware que valide el token JWT en el header `Authorization: Bearer <token>`.  
Si token válido, inyectar `req.user` con datos del usuario.  
Si token inválido/expirado, retornar `401`.

**Criterios de aceptación:**  
- [ ] Rutas protegidas rechazan peticiones sin token  
- [ ] Rutas protegidas rechazan token expirado  
- [ ] `req.user` disponible en controladores protegidos  

**Rama:** `feature/008-jwt-middleware`  
**PR:** `Closes #8`

---

## EPIC 3 — Módulo de Lotes Agrícolas

**Issue #9 (Epic):** `[EPIC] CRUD de lotes agrícolas`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
El productor autenticado puede crear, listar, ver detalle y editar sus lotes agrícolas.

### Issues hijas:

---

**Issue #10:** `Implementar crear lote (POST /api/lotes)`  
**Labels:** `backend`, `must-have`  
**Parent:** #9  
**Descripción:**  
El productor autenticado crea un lote vinculado a su `productor_id`.  
Campos: nombre, ubicación, área, tipo_cultivo, variedad, fecha_siembra_estimada, fecha_cosecha_estimada, estado.

**Criterios de aceptación:**  
- [ ] Lote creado con `201` y vinculado al productor autenticado  
- [ ] Validación de campos obligatorios  
- [ ] Estado inicial: `activo`  

**Rama:** `feature/010-create-lote`  
**PR:** `Closes #10`

---

**Issue #11:** `Implementar listar lotes del productor (GET /api/lotes)`  
**Labels:** `backend`, `must-have`  
**Parent:** #9  
**Descripción:**  
Retorna únicamente los lotes del productor autenticado.

**Criterios de aceptación:**  
- [ ] Retorna array de lotes del productor  
- [ ] No muestra lotes de otros productores  
- [ ] Respuesta `200` con array vacío si no tiene lotes  

**Rama:** `feature/011-list-lotes`  
**PR:** `Closes #11`

---

**Issue #12:** `Implementar detalle y edición de lote (GET/PUT /api/lotes/:id)`  
**Labels:** `backend`, `must-have`  
**Parent:** #9  
**Descripción:**  
GET retorna detalle del lote (solo si pertenece al productor).  
PUT permite editar campos del lote.

**Criterios de aceptación:**  
- [ ] GET retorna `200` con detalle o `404` si no existe/no es suyo  
- [ ] PUT actualiza campos y retorna `200`  
- [ ] No permite editar lotes de otro productor (`403`)  

**Rama:** `feature/012-detail-edit-lote`  
**PR:** `Closes #12`

---

## EPIC 4 — Módulo de Eventos Productivos

**Issue #13 (Epic):** `[EPIC] CRUD de eventos productivos`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
El productor registra eventos (siembra, riego, fertilización, cosecha, incidencia) dentro de sus lotes. Cada evento es trazable.

### Issues hijas:

---

**Issue #14:** `Implementar registrar evento (POST /api/lotes/:loteId/eventos)`  
**Labels:** `backend`, `must-have`  
**Parent:** #13  
**Descripción:**  
Crear evento productivo asociado a un lote del productor.  
Campos: tipo_evento_id, fecha_evento, descripcion, observaciones.  
Registrar `usuario_id` automáticamente.

**Criterios de aceptación:**  
- [ ] Evento creado con `201` vinculado al lote  
- [ ] Validación: lote debe pertenecer al productor  
- [ ] tipo_evento_id debe existir en `tipos_evento`  
- [ ] Fecha y usuario registrados automáticamente  

**Rama:** `feature/014-create-evento`  
**PR:** `Closes #14`

---

**Issue #15:** `Implementar listar eventos de un lote (GET /api/lotes/:loteId/eventos)`  
**Labels:** `backend`, `must-have`  
**Parent:** #13  
**Descripción:**  
Retorna eventos del lote ordenados cronológicamente (más reciente primero).  
Incluir nombre del tipo de evento en la respuesta.

**Criterios de aceptación:**  
- [ ] Lista cronológica de eventos  
- [ ] Incluye nombre de tipo_evento  
- [ ] Solo lotes del productor autenticado  

**Rama:** `feature/015-list-eventos`  
**PR:** `Closes #15`

---

**Issue #16:** `Implementar detalle y edición de evento (GET/PUT /api/eventos/:id)`  
**Labels:** `backend`, `should-have`  
**Parent:** #13  
**Descripción:**  
GET retorna detalle de un evento con insumos asociados.  
PUT permite editar la info del evento.

**Criterios de aceptación:**  
- [ ] GET retorna evento con insumos  
- [ ] PUT actualiza y retorna `200`  
- [ ] Validar propiedad del lote  

**Rama:** `feature/016-detail-edit-evento`  
**PR:** `Closes #16`

---

## EPIC 5 — Módulo de Insumos

**Issue #17 (Epic):** `[EPIC] Gestión de insumos en eventos`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
Registrar y consultar insumos aplicados dentro de un evento productivo.

### Issues hijas:

---

**Issue #18:** `Implementar registrar insumo en evento (POST /api/eventos/:eventoId/insumos)`  
**Labels:** `backend`, `must-have`  
**Parent:** #17  
**Descripción:**  
Asociar un insumo con cantidad a un evento productivo.  
Si el insumo no existe en catálogo, crearlo.

**Criterios de aceptación:**  
- [ ] Insumo asociado al evento con cantidad  
- [ ] Validar que el evento pertenezca al productor  

**Rama:** `feature/018-add-insumo-evento`  
**PR:** `Closes #18`

---

**Issue #19:** `Implementar consultar insumos de evento (GET /api/eventos/:eventoId/insumos)`  
**Labels:** `backend`, `should-have`  
**Parent:** #17  

**Rama:** `feature/019-list-insumos-evento`  
**PR:** `Closes #19`

---

## EPIC 6 — Trazabilidad

**Issue #20 (Epic):** `[EPIC] Consulta de trazabilidad del lote`  
**Labels:** `epic`, `backend`, `must-have`  
**Descripción:**  
Endpoint que devuelve historial completo de un lote con todos sus eventos e insumos, ordenados cronológicamente. Base para generar QR.

### Issues hijas:

---

**Issue #21:** `Implementar endpoint de trazabilidad (GET /api/trazabilidad/lote/:id)`  
**Labels:** `backend`, `must-have`  
**Parent:** #20  
**Descripción:**  
Retorna: datos del lote + productor + lista cronológica de eventos con sus insumos.  
Este JSON es lo que se codificará en el QR desde Flutter.

**Criterios de aceptación:**  
- [ ] Respuesta estructurada con lote, productor, eventos e insumos  
- [ ] Orden cronológico  
- [ ] Solo accesible por el productor dueño del lote  

**Rama:** `feature/021-trazabilidad-lote`  
**PR:** `Closes #21`

---

## EPIC 7 — Catálogos y utilidades

**Issue #22:** `Implementar endpoint de tipos de evento (GET /api/tipos-evento)`  
**Labels:** `backend`, `must-have`  
**Descripción:**  
Retorna catálogo de tipos de evento para poblar dropdowns en Flutter.

**Rama:** `feature/022-tipos-evento`  
**PR:** `Closes #22`

---

## 📌 Orden sugerido de desarrollo (PRs)

| Orden | Issue | Rama |
|-------|-------|------|
| 1 | #2 | `feature/002-init-node-project` |
| 2 | #3 | `feature/003-database-schema` |
| 3 | #4 | `feature/004-db-connection` |
| 4 | #6 | `feature/006-auth-register` |
| 5 | #7 | `feature/007-auth-login` |
| 6 | #8 | `feature/008-jwt-middleware` |
| 7 | #10 | `feature/010-create-lote` |
| 8 | #11 | `feature/011-list-lotes` |
| 9 | #12 | `feature/012-detail-edit-lote` |
| 10 | #14 | `feature/014-create-evento` |
| 11 | #15 | `feature/015-list-eventos` |
| 12 | #16 | `feature/016-detail-edit-evento` |
| 13 | #18 | `feature/018-add-insumo-evento` |
| 14 | #19 | `feature/019-list-insumos-evento` |
| 15 | #22 | `feature/022-tipos-evento` |
| 16 | #21 | `feature/021-trazabilidad-lote` |