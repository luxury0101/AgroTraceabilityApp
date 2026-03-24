const apiResponse = {
  success(res, data = null, message = 'Operación exitosa', statusCode = 200) {
    return res.status(statusCode).json({
      success: true,
      message,
      data,
    });
  },

  error(res, message = 'Error interno del servidor', statusCode = 500, details = null) {
    return res.status(statusCode).json({
      success: false,
      message,
      details,
    });
  },
};

module.exports = apiResponse;