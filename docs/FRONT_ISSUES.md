# 📋 AgroTraceability Flutter — GitHub Issues (Backlog)

> Convención de ramas: `feature/ISSUE-XX-descripcion-corta`  
> Cada PR se linkea a su issue hija con `Closes #XX`

---

## 🏷️ Labels adicionales para frontend

| Label | Color | Uso |
|-------|-------|-----|
| `flutter` | `#02569B` | Tareas de la app móvil |
| `ui` | `#E91E63` | Diseño de interfaz |
| `integration` | `#FF9800` | Conexión con backend |

---

## EPIC 8 — Configuración inicial Flutter

**Issue #30 (Epic):** `[EPIC] Configuración inicial app Flutter`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #31:** `Crear proyecto Flutter con estructura de carpetas y dependencias`  
**Labels:** `flutter`, `must-have`  
**Parent:** #30  
**Descripción:**  
Crear proyecto con `flutter create`. Instalar dependencias: http, provider, shared_preferences,
flutter_secure_storage, qr_flutter, qr_code_scanner. Estructura: lib/models, services, providers, screens, widgets.  
Configurar permisos en AndroidManifest (Internet, Cámara).

**Criterios de aceptación:**  
- [ ] `flutter run` funciona sin errores  
- [ ] Estructura de carpetas creada  
- [ ] Dependencias instaladas  
- [ ] Permisos configurados en AndroidManifest  

**Rama:** `feature/031-init-flutter`  
**PR:** `Closes #31`

---

**Issue #32:** `Configurar servicio HTTP base y constantes de conexión`  
**Labels:** `flutter`, `integration`, `must-have`  
**Parent:** #30  
**Descripción:**  
Crear clase `ApiService` con baseUrl configurable, métodos GET/POST/PUT con headers JWT.  
Crear constantes de API.

**Rama:** `feature/032-api-service`  
**PR:** `Closes #32`

---

## EPIC 9 — Módulo de autenticación Flutter

**Issue #33 (Epic):** `[EPIC] Pantallas de autenticación`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #34:** `Implementar pantalla de registro de productor`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #33  
**Descripción:**  
Formulario: nombre, apellido, email, username, password, documento, teléfono, municipio.  
Validación de campos. Conectar con POST /api/auth/register.  
Al registrar exitosamente, redirigir a login.

**Rama:** `feature/034-register-screen`  
**PR:** `Closes #34`

---

**Issue #35:** `Implementar pantalla de login`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #33  
**Descripción:**  
Formulario: email + password. Conectar con POST /api/auth/login.  
Guardar token JWT en almacenamiento seguro. Redirigir a Home.

**Rama:** `feature/035-login-screen`  
**PR:** `Closes #35`

---

**Issue #36:** `Implementar AuthProvider con manejo de sesión`  
**Labels:** `flutter`, `must-have`  
**Parent:** #33  
**Descripción:**  
Provider que maneja: login, logout, verificar sesión activa, guardar/leer token.  
Auto-redirect a login si token expirado.

**Rama:** `feature/036-auth-provider`  
**PR:** `Closes #36`

---

## EPIC 10 — Pantalla principal (Home)

**Issue #37 (Epic):** `[EPIC] Pantalla principal del productor`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #38:** `Implementar Home con resumen de lotes y acceso rápido`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #37  
**Descripción:**  
Mostrar: saludo con nombre, total de lotes, tarjetas de lotes recientes,
botones de acceso a crear lote y ver todos los lotes. AppBar con logout.

**Rama:** `feature/038-home-screen`  
**PR:** `Closes #38`

---

## EPIC 11 — Módulo de lotes Flutter

**Issue #39 (Epic):** `[EPIC] Gestión de lotes agrícolas en Flutter`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #40:** `Implementar pantalla de lista de lotes`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #39  
**Descripción:**  
Lista con tarjetas mostrando: nombre, código, cultivo, estado, total eventos.  
Pull-to-refresh. Tap para ir a detalle.

**Rama:** `feature/040-lotes-list`  
**PR:** `Closes #40`

---

**Issue #41:** `Implementar pantalla de crear/editar lote`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #39  
**Descripción:**  
Formulario: nombre, código, ubicación, área, tipo cultivo, variedad, fechas, observaciones.  
Conectar con POST /api/lotes y PUT /api/lotes/:id.

**Rama:** `feature/041-create-edit-lote`  
**PR:** `Closes #41`

---

**Issue #42:** `Implementar pantalla de detalle de lote`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #39  
**Descripción:**  
Mostrar info completa del lote + lista de eventos recientes + botón generar QR +
botón agregar evento + botón ver trazabilidad.

**Rama:** `feature/042-lote-detail`  
**PR:** `Closes #42`

---

## EPIC 12 — Módulo de eventos Flutter

**Issue #43 (Epic):** `[EPIC] Gestión de eventos productivos en Flutter`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #44:** `Implementar pantalla de registrar evento`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #43  
**Descripción:**  
Formulario: tipo evento (dropdown desde API), fecha, descripción, observaciones.  
Sección para agregar insumos (nombre, cantidad, unidad).  
Conectar con POST /api/lotes/:id/eventos y POST /api/eventos/:id/insumos.

**Rama:** `feature/044-create-evento`  
**PR:** `Closes #44`

---

**Issue #45:** `Implementar pantalla de lista de eventos del lote`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #43  
**Descripción:**  
Timeline vertical cronológico. Cada evento con icono, tipo, fecha, descripción.  
Tap para ver detalle.

**Rama:** `feature/045-eventos-list`  
**PR:** `Closes #45`

---

**Issue #46:** `Implementar pantalla de detalle de evento`  
**Labels:** `flutter`, `ui`, `should-have`  
**Parent:** #43  
**Descripción:**  
Mostrar tipo, fecha, descripción, observaciones, insumos aplicados, quién lo registró.

**Rama:** `feature/046-evento-detail`  
**PR:** `Closes #46`

---

## EPIC 13 — Trazabilidad y QR

**Issue #47 (Epic):** `[EPIC] Trazabilidad y generación de QR`  
**Labels:** `epic`, `flutter`, `must-have`

### Issues hijas:

**Issue #48:** `Implementar pantalla de trazabilidad del lote`  
**Labels:** `flutter`, `ui`, `must-have`  
**Parent:** #47  
**Descripción:**  
Consultar GET /api/trazabilidad/lote/:id. Mostrar timeline completo con
datos del lote, productor, y todos los eventos con insumos.  
Botón para generar QR.

**Rama:** `feature/048-trazabilidad-screen`  
**PR:** `Closes #48`

---

**Issue #49:** `Implementar generación de QR con datos de trazabilidad`  
**Labels:** `flutter`, `must-have`  
**Parent:** #47  
**Descripción:**  
Generar QR que contenga un JSON compacto con: lote_id, código, productor,
resumen de eventos. Guardar en SQLite local para lectura offline.  
Pantalla para mostrar el QR generado.

**Rama:** `feature/049-qr-generation`  
**PR:** `Closes #49`

---

**Issue #50:** `Implementar escáner de QR para ver reporte`  
**Labels:** `flutter`, `should-have`  
**Parent:** #47  
**Descripción:**  
Usar cámara para escanear QR de otro productor.  
Mostrar el reporte de trazabilidad desde los datos del QR.  
Requiere permiso de cámara.

**Rama:** `feature/050-qr-scanner`  
**PR:** `Closes #50`

---

## 📌 Orden de desarrollo (PRs Flutter)

| Orden | Issue | Rama |
|-------|-------|------|
| 1 | #31 | `feature/031-init-flutter` |
| 2 | #32 | `feature/032-api-service` |
| 3 | #36 | `feature/036-auth-provider` |
| 4 | #35 | `feature/035-login-screen` |
| 5 | #34 | `feature/034-register-screen` |
| 6 | #38 | `feature/038-home-screen` |
| 7 | #40 | `feature/040-lotes-list` |
| 8 | #41 | `feature/041-create-edit-lote` |
| 9 | #42 | `feature/042-lote-detail` |
| 10 | #44 | `feature/044-create-evento` |
| 11 | #45 | `feature/045-eventos-list` |
| 12 | #46 | `feature/046-evento-detail` |
| 13 | #48 | `feature/048-trazabilidad-screen` |
| 14 | #49 | `feature/049-qr-generation` |
| 15 | #50 | `feature/050-qr-scanner` |