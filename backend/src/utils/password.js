const bcrypt = require('bcryptjs');

const hashPassword = async (plainPassword) => {
  return bcrypt.hash(plainPassword, 10);
};

const comparePassword = async (plainPassword, passwordHash) => {
  return bcrypt.compare(plainPassword, passwordHash);
};

module.exports = {
  hashPassword,
  comparePassword,
};