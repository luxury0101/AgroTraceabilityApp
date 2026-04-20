import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get userName => _user != null ? '${_user!['nombre']} ${_user!['apellido']}' : '';

  Future<void> checkAuth() async {
    final token = await ApiService.getToken();
    if (token != null) {
      try {
        final response = await ApiService.get('/auth/profile');
        _user = response['user'];
        _isAuthenticated = true;
      } catch (e) {
        await ApiService.deleteToken();
        _isAuthenticated = false;
        _user = null;
      }
    }
    notifyListeners();
  }

  Future<String?> register({
    required String nombre,
    required String apellido,
    required String email,
    required String username,
    required String password,
    required String documento,
    String? telefono,
    String? municipio,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ApiService.post('/auth/register', {
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'username': username,
        'password': password,
        'documento': documento,
        'telefono': telefono ?? '',
        'municipio': municipio ?? 'Barbosa',
      }, auth: false);
      _isLoading = false;
      notifyListeners();
      return null; // sin error
    } on ApiException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error de conexión. Verifica que el servidor esté corriendo.';
    }
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      }, auth: false);
      await ApiService.saveToken(response['token']);
      _user = response['user'];
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error de conexión. Verifica que el servidor esté corriendo.';
    }
  }

  Future<void> logout() async {
    await ApiService.deleteToken();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}