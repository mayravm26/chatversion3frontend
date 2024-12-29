import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Liberamos los controladores para evitar fugas de memoria.
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, introduce un email válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce tu contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await Provider.of<UserProvider>(context, listen: false)
                          .register(
                        _nombreController.text,
                        _emailController.text,
                        _passwordController.text,
                      );

                      // Muestra un mensaje de éxito y redirige al inicio de sesión
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario registrado con éxito'),
                        ),
                      );

                      // Redirigir al inicio de sesión
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      // Manejo de errores
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al registrar usuario: $e'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Redirigir al inicio de sesión si ya tienen cuenta
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('¿Ya tienes cuenta? Inicia sesión aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
