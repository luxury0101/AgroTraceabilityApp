const findUserByEmailQuery = `
  SELECT
    u.id,
    u.first_name,
    u.last_name,
    u.email,
    u.password_hash,
    r.code AS role
  FROM users u
  INNER JOIN roles r ON r.id = u.role_id
  WHERE u.email = $1
    AND u.is_active = TRUE
    AND u.deleted_at IS NULL
  LIMIT 1;
`;

module.exports = {
  findUserByEmailQuery,
};