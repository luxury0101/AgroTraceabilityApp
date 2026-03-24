const { comparePassword } = require('../../utils/password');
const { signToken } = require('../../utils/jwt');
const authRepository = require('./auth.repository');

async function login({ email, password }) {
  const user = await authRepository.findUserByEmail(email);

  if (!user) {
    const error = new Error('Credenciales inválidas');
    error.statusCode = 401;
    throw error;
  }

  const isPasswordValid = await comparePassword(password, user.password_hash);

  if (!isPasswordValid) {
    const error = new Error('Credenciales inválidas');
    error.statusCode = 401;
    throw error;
  }

  const token = signToken({
    sub: user.id,
    email: user.email,
    role: user.role,
  });

  return {
    token,
    user: {
      id: user.id,
      fullName: `${user.first_name} ${user.last_name}`,
      email: user.email,
      role: user.role,
    },
  };
}

module.exports = {
  login,
};