const { verifyToken } = require('../utils/jwt');
const apiResponse = require('../utils/apiResponse');

function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return apiResponse.error(res, 'No autorizado. Token requerido.', 401);
    }

    const token = authHeader.split(' ')[1];
    const payload = verifyToken(token);

    req.user = payload;
    next();
  } catch (error) {
    return apiResponse.error(res, 'Token inválido o expirado.', 401);
  }
}

module.exports = authMiddleware;