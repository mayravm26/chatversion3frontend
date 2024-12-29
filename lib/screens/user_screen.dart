/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/user_screen.dart';
import 'screens/register_user_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/registerUser': (_) => const RegisterUserScreen(),
          '/users': (_) => const UserScreen(),
          '/chat': (_) => const ChatScreen(),
        },
      ),
    );
  }
}
*/
