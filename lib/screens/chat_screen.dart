import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Conexión inicial con el WebSocket
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      if (userProvider.token != null && userProvider.token!.isNotEmpty) {
        chatProvider.connect(userProvider.token!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se encontró un token válido'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Liberar recursos del controlador
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: chatProvider.messages.isEmpty
                ? const Center(
                    child: Text(
                      'No hay mensajes todavía',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return ListTile(
                        title: Text(
                          message['user'] ?? 'Anónimo',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          message['message'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
          ),
          // Campo de entrada para enviar mensajes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);

                    if (_messageController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El mensaje no puede estar vacío'),
                        ),
                      );
                      return;
                    }

                    // Enviar el mensaje
                    chatProvider.sendMessage(
                      userProvider.nombre ?? 'Anónimo',
                      _messageController.text.trim(),
                    );

                    // Limpiar el campo de entrada
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
