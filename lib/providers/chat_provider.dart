/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart'; // Compatible con navegadores.

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  WebSocketChannel? _channel;

  List<Map<String, String>> get messages => _messages;

  void connect(String token) {
    // Verificar que el token no esté vacío
    if (token.isEmpty) {
      print('Error: Token no válido');
      return;
    }

    try {
      // Usa HtmlWebSocketChannel para navegadores
      _channel = HtmlWebSocketChannel.connect(
        'ws://localhost:3001', // Cambia al puerto del backend si es diferente.
      );

      _channel!.stream.listen(
        (message) {
          try {
            // Manejo de mensajes recibidos
            final data = jsonDecode(message);
            if (data != null &&
                data.containsKey('de') &&
                data.containsKey('mensaje')) {
              _messages.add({'user': data['de'], 'message': data['mensaje']});
              notifyListeners();
            } else {
              print('Error: Formato de mensaje no válido');
            }
          } catch (e) {
            print('Error al procesar el mensaje: $e');
          }
        },
        onError: (error) {
          print('Error en WebSocket: $error');
        },
        onDone: () {
          print('Conexión WebSocket cerrada');
        },
      );
    } catch (e) {
      print('Error al conectar al WebSocket: $e');
    }
  }

  void sendMessage(String user, String message) {
    if (message.trim().isEmpty) {
      print('Error: El mensaje no puede estar vacío');
      return;
    }

    if (_channel == null) {
      print('Error: No hay conexión WebSocket activa');
      return;
    }

    try {
      _channel!.sink.add(jsonEncode({'de': user, 'mensaje': message}));
    } catch (e) {
      print('Error al enviar el mensaje: $e');
    }
  }

  @override
  void dispose() {
    try {
      _channel?.sink.close();
    } catch (e) {s
      print('Error al cerrar el WebSocket: $e');
    }
    super.dispose();
  }
}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart'; // Compatible con navegadores.

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  HtmlWebSocketChannel? _channel;

  List<Map<String, String>> get messages => _messages;

  void connect(String token) {
    if (token.isEmpty) {
      print('Error: Token no válido');
      return;
    }

    try {
      _channel = HtmlWebSocketChannel.connect(
        'ws://localhost:3001?token=$token',
      );

      _channel!.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            if (data != null &&
                data.containsKey('de') &&
                data.containsKey('mensaje')) {
              _messages.add({'user': data['de'], 'message': data['mensaje']});
              notifyListeners();
            } else {
              print('Error: Formato de mensaje no válido');
            }
          } catch (e) {
            print('Error al procesar el mensaje: $e');
          }
        },
        onError: (error) {
          print('Error en WebSocket: $error');
        },
        onDone: () {
          print('Conexión WebSocket cerrada');
        },
      );
    } catch (e) {
      print('Error al conectar al WebSocket: $e');
    }
  }

  void sendMessage(String user, String message) {
    if (message.trim().isEmpty) {
      print('Error: El mensaje no puede estar vacío');
      return;
    }

    if (_channel == null) {
      print('Error: No hay conexión WebSocket activa');
      return;
    }

    try {
      _channel!.sink.add(jsonEncode({'de': user, 'mensaje': message}));
    } catch (e) {
      print('Error al enviar el mensaje: $e');
    }
  }

  @override
  void dispose() {
    try {
      _channel?.sink.close();
    } catch (e) {
      print('Error al cerrar el WebSocket: $e');
    }
    super.dispose();
  }
}
