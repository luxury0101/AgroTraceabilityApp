const apiResponse = require('../utils/apiResponse');

function roleMiddleware(...allowedRoles) {
  return (req, res, next) => {
    const userRole = req.user?.role;

    if (!userRole || !allowedRoles.includes(userRole)) {
      return apiResponse.error(res, 'No tienes permisos para esta acción.', 403);
    }

    next();
  };
}

module.exports = roleMiddleware;