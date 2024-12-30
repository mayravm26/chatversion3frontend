import 'dart:convert';
import 'package:web_socket_channel/io.dart'; // Importa para WebSockets con encabezados.
//import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  IOWebSocketChannel? _channel;
  final List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  // Conectar al WebSocket
  void connect(String token) {
    _channel = IOWebSocketChannel.connect(
      Uri.parse('ws://localhost:3001'), // Cambia si es necesario.
      headers: {'x-token': token},
    );

    _channel?.stream.listen(
      (message) {
        final data = jsonDecode(message);
        _messages.add({'user': data['de'], 'message': data['mensaje']});
      },
      onError: (error) {
        print('Error en WebSocket: $error');
      },
      onDone: () {
        print('Conexión WebSocket cerrada');
      },
    );
  }

  // Enviar un mensaje
  void sendMessage(String to, String message) {
    if (_channel != null && message.trim().isNotEmpty) {
      _channel!.sink.add(
        jsonEncode({'para': to, 'mensaje': message}),
      );
    } else {
      print('No hay conexión WebSocket activa o mensaje vacío');
    }
  }

  // Cerrar conexión WebSocket
  void closeConnection() {
    _channel?.sink.close();
  }
}
