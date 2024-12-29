import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatProvider with ChangeNotifier {
  final List<Map<String, String>> _messages = [];
  late WebSocketChannel _channel;

  List<Map<String, String>> get messages => _messages;

  void connect(String token) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:3000'),
    );

    _channel.stream.listen(
      (message) {
        final data = jsonDecode(message);
        _messages.add({'user': data['user'], 'message': data['message']});
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
    if (message.trim().isNotEmpty) {
      _channel.sink.add(jsonEncode({'user': user, 'message': message}));
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
