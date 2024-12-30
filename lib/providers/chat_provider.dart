import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart'; // Cambiar a IOWebSocketChannel para WebSockets con encabezados.
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  WebSocketChannel? _channel; // Cambiado a nullable para manejar errores.

  List<Map<String, String>> get messages => _messages;

  void connect(String token) {
    // Conexión con encabezados
    _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://localhost:3000'), // URL del backend.
      headers: {'x-token': token}, // Agregamos el token al encabezado.
    );

    _channel?.stream.listen(
      (message) {
        // Manejo de mensajes recibidos
        final data = jsonDecode(message);
        _messages.add({'user': data['de'], 'message': data['mensaje']});
        notifyListeners();
      },
      onError: (error) {
        print('Error en WebSocket: $error');
      },
      onDone: () {
        print('Conexión WebSocket cerrada');
      },
    );
  }

  void sendMessage(String user, String message) {
    if (message.trim().isNotEmpty && _channel != null) {
      _channel!.sink.add(jsonEncode({'de': user, 'mensaje': message}));
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
