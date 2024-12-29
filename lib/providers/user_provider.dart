import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String? _nombre;

  String? get token => _token;
  String? get nombre => _nombre;

  final ApiService _apiService = ApiService();

  Future<void> register(String nombre, String email, String password) async {
    final response = await _apiService.registerUser(nombre, email, password);
    _token = response['token'];
    _nombre = response['usuario']['nombre'];
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final response = await _apiService.loginUser(email, password);
    _token = response['token'];
    _nombre = response['usuario']['nombre'];
    notifyListeners();
  }
}
