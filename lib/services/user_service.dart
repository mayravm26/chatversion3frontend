import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  // Obtener la lista de usuarios
  Future<List<User>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/usuarios'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['usuarios'];
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Error al obtener la lista de usuarios');
    }
  }

  // Registrar un nuevo usuario
  Future<User> registerUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body)['usuario']);
    } else {
      throw Exception('Error al registrar el usuario');
    }
  }
}
