const pool = require('../../config/db');
const { findUserByEmailQuery } = require('./auth.sql');

async function findUserByEmail(email) {
  const result = await pool.query(findUserByEmailQuery, [email]);
  return result.rows[0] || null;
}

module.exports = {
  findUserByEmail,
};