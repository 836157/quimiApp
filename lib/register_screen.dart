import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

import 'personalizadorwidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
          context: context, title: 'Registro de usuario'),
      body: SingleChildScrollView(
        child: Consumer<ThemeNotifier>(builder: (context, value, child) {
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: nameController,
                      labelText: 'Nombre',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: surnameController,
                      labelText: 'Apellidos',
                      icon: Icons.label_important,
                    ),
                    const SizedBox(height: 20.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: emailController,
                      labelText: 'Correo electronico',
                      icon: Icons.email,
                      validator: (value) {
                        String pattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Correo no valido, por favor ingrese un correo válido.'),
                            ),
                          );
                          return 'Invalid password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: passwordController,
                      labelText: 'Contraseña',
                      icon: Icons.lock,
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Usa el color del icono del tema actual
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      validator: (value) {
                        String patternPassword =
                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\W_]{8,}$';
                        RegExp regex = RegExp(patternPassword);
                        if (!regex.hasMatch(value!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'La contraseña debe tener al menos 8 caracteres, una letra,un número y un caracter especial. Por favor, inténtelo de nuevo.'),
                            ),
                          );
                          return 'Invalid password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: confirmPasswordController,
                      labelText: 'Confirmar contraseña',
                      icon: Icons.lock,
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Usa el color del icono del tema actual
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      validator: (value) {
                        String patternPassword =
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$';
                        RegExp regex = RegExp(patternPassword);
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Las contraseñas no coinciden. Por favor, inténtelo de nuevo.'),
                            ),
                          );
                          return 'Invalid password';
                        }
                        if (!regex.hasMatch(value!)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'La contraseña debe tener al menos 8 caracteres, una letra,un número y un caracter especial. Por favor, inténtelo de nuevo.'),
                            ),
                          );
                          return 'Invalid password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20.0),
                    PersonalizadorWidget.buildCustomElevatedButton(
                      context,
                      'Registrarse',
                      () async {
                        String pattern =
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$';
                        RegExp regex = RegExp(pattern);
                        if (regex.hasMatch(emailController.text)) {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text ==
                                confirmPasswordController.text) {
                              authService.registerUser(
                                  nameController.text,
                                  surnameController.text,
                                  emailController.text,
                                  passwordController.text,
                                  context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Las contraseñas no coinciden. Por favor, inténtelo de nuevo.'),
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Por favor ingrese un correo válido'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
