import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String authTokenKey = 'auth_token';
  static const String authUserKey = 'auth_user';

  Future<void> saveToken(String token) async {
    await _storage.write(key: authTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: authTokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _storage.write(key: authUserKey, value: jsonEncode(userJson));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: authUserKey);
    if (raw == null || raw.isEmpty) return null;

    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: authTokenKey);
    await _storage.delete(key: authUserKey);
  }
}
