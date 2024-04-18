import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia de AuthenticationService
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: Colors.green,
        shadowColor: Colors.grey,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4CAF50), // Un tono de verde
                Color(0xFF8BC34A), // Otro tono de verde
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondoFinal.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 180.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Margen agregado aquí
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueGrey,
                    ),
                    child: PersonalizadorWidget.buildCustomTextFormField(
                      controller: _emailController,
                      labelText: 'Correo electrónico',
                      icon: Icons.email,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Margen agregado aquí
                  child: PersonalizadorWidget.buildCustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    icon: Icons.lock,
                  ),
                ),
                const SizedBox(height: 60.0),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // código para el botón de iniciar sesión
                      PersonalizadorWidget.buildCustomElevatedButton(
                          "Iniciar sesión", () async {
                        if (formKey.currentState!.validate()) {
                          // Si el formulario es válido, muestra un mensaje de éxito
                          await authService.login(_emailController.text,
                              _passwordController.text, context);
                        }
                      }),
                      const SizedBox(height: 150.0),
                      const Text(
                        'No tienes una cuenta',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      PersonalizadorWidget.buildCustomElevatedButton(
                          "Registrate", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
