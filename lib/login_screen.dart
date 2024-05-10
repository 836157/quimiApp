import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

import 'register_screen.dart';

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
  void dispose() {
    // Llama a dispose en los controladores cuando el widget se descarte
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia de AuthenticationService
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: PersonalizadorWidget.buildGradientAppBar(
            title: 'Iniciar sesión', context: context),
        body: SingleChildScrollView(
          child: Consumer<ThemeNotifier>(
            builder: (context, value, child) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: themeNotifier.isUsingFirstTheme
                    ? const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/humo.gif"),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/humoRojo.gif"),
                          fit: BoxFit.cover,
                        ),
                      ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 100.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0), // Margen agregado aquí
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Colors.blueGrey,
                          ),
                          child: PersonalizadorWidget.buildCustomTextFormField(
                            context: context,
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
                          context: context,
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
                                context, "Iniciar sesión", () async {
                              String pattern =
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(_emailController.text)) {
                                // Mostrar un mensaje de error
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Introduce un correo electrónico válido')));
                              } else if (formKey.currentState!.validate()) {
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
                                context, "Registrate", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
