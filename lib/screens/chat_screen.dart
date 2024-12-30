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
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // Conecta al WebSocket
      if (userProvider.token != null && userProvider.token!.isNotEmpty) {
        chatProvider.connect(userProvider.token!);

        // Ejemplo de envío automático de un mensaje
        chatProvider.sendMessage(
          userProvider.nombre ?? 'Anónimo',
          'Hola desde Flutter Web',
        );
      } else {
        print('Error: Token no válido');
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose(); // Liberar recursos del controlador
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
          Expanded(
            child: chatProvider.messages.isEmpty
                ? const Center(
                    child: Text('No hay mensajes todavía'),
                  )
                : ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return ListTile(
                        title: Text(
                          message['user']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(message['message']!),
                      );
                    },
                  ),
          ),
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

                    chatProvider.sendMessage(
                      userProvider.nombre ?? 'Anónimo',
                      _messageController.text.trim(),
                    );

                    _messageController.clear(); // Limpiar el campo de texto
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
