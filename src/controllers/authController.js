const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

// POST /api/auth/register
const register = async (req, res) => {
  const { nombre, apellido, email, username, password, documento, telefono, direccion, municipio } = req.body;

  // Validar campos obligatorios
  if (!nombre || !apellido || !email || !username || !password || !documento) {
    return res.status(400).json({
      error: 'Campos obligatorios: nombre, apellido, email, username, password, documento',
    });
  }

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    // Verificar que email y username no existan
    const [existing] = await conn.query(
      'SELECT id FROM users WHERE email = ? OR username = ?',
      [email, username]
    );
    if (existing.length > 0) {
      await conn.rollback();
      return res.status(409).json({ error: 'El email o username ya está registrado' });
    }

    // Verificar documento único
    const [existingDoc] = await conn.query(
      'SELECT id FROM productores WHERE documento = ?',
      [documento]
    );
    if (existingDoc.length > 0) {
      await conn.rollback();
      return res.status(409).json({ error: 'El documento ya está registrado' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Crear usuario con rol productor (id=2)
    const [userResult] = await conn.query(
      `INSERT INTO users (nombre, apellido, email, username, password, role_id)
       VALUES (?, ?, ?, ?, ?, 2)`,
      [nombre, apellido, email, username, hashedPassword]
    );

    const userId = userResult.insertId;

    // Crear registro de productor
    await conn.query(
      `INSERT INTO productores (user_id, documento, telefono, direccion, municipio)
       VALUES (?, ?, ?, ?, ?)`,
      [userId, documento, telefono || null, direccion || null, municipio || 'Barbosa']
    );

    await conn.commit();

    // Obtener datos completos del usuario creado
    const [newUser] = await conn.query(
      `SELECT u.id, u.nombre, u.apellido, u.email, u.username, r.nombre as rol,
              p.id as productor_id, p.documento
       FROM users u
       JOIN roles r ON u.role_id = r.id
       JOIN productores p ON p.user_id = u.id
       WHERE u.id = ?`,
      [userId]
    );

    res.status(201).json({
      message: 'Usuario registrado exitosamente',
      user: newUser[0],
    });
  } catch (err) {
    await conn.rollback();
    console.error('Error en registro:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  } finally {
    conn.release();
  }
};

// POST /api/auth/login
const login = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email/username y contraseña son obligatorios' });
  }

  try {
    // Buscar usuario por email o username
    const [users] = await db.query(
      `SELECT u.id, u.nombre, u.apellido, u.email, u.username, u.password,
              u.role_id, r.nombre as rol, u.activo,
              p.id as productor_id, p.documento
       FROM users u
       JOIN roles r ON u.role_id = r.id
       LEFT JOIN productores p ON p.user_id = u.id
       WHERE (u.email = ? OR u.username = ?) AND u.activo = TRUE`,
      [email, email]
    );

    if (users.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const user = users[0];

    // Verificar password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    // Generar JWT
    const token = jwt.sign(
      {
        id: user.id,
        username: user.username,
        role_id: user.role_id,
        rol: user.rol,
        productor_id: user.productor_id,
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
    );

    // No enviar password en la respuesta
    const { password: _, ...userData } = user;

    res.json({
      message: 'Inicio de sesión exitoso',
      token,
      user: userData,
    });
  } catch (err) {
    console.error('Error en login:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

// GET /api/auth/profile
const getProfile = async (req, res) => {
  try {
    const [users] = await db.query(
      `SELECT u.id, u.nombre, u.apellido, u.email, u.username,
              r.nombre as rol, p.id as productor_id, p.documento,
              p.telefono, p.direccion, p.municipio, p.departamento
       FROM users u
       JOIN roles r ON u.role_id = r.id
       LEFT JOIN productores p ON p.user_id = u.id
       WHERE u.id = ?`,
      [req.user.id]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.json({ user: users[0] });
  } catch (err) {
    console.error('Error en getProfile:', err);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

module.exports = { register, login, getProfile };