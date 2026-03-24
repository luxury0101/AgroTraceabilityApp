const apiResponse = require('../utils/apiResponse');

function errorMiddleware(err, req, res, next) {
  console.error(err);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Error interno del servidor';

  return apiResponse.error(res, message, statusCode);
}

module.exports = errorMiddleware;