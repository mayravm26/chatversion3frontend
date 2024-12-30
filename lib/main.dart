import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_user_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Configuración de los proveedores
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/crearUsuario', // Ruta inicial
        routes: {
          // Declaración de rutas
          '/login': (context) => const LoginScreen(),
          '/crearUsuario': (context) => const RegisterUserScreen(),
          '/chat': (context) => const ChatScreen(),
        },
        onUnknownRoute: (settings) {
          // Maneja rutas desconocidas
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Ruta no encontrada'),
              ),
            ),
          );
        },
      ),
    );
  }
}
