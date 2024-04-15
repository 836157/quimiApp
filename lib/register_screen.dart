import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';

import 'personalizadorwidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Agrega un GlobalKey para acceder al Scaffold
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro nuevo usuario'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondologin.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 120.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: nameController,
                    labelText: 'Nombre',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: surnameController,
                    labelText: 'Apellidos',
                    icon: Icons.label_important,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: emailController,
                    labelText: 'Correo electronico',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: passwordController,
                    labelText: 'Contraseña',
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomElevatedButton(
                    'Registrarse',
                    () async {
                      if (_formKey.currentState!.validate()) {
                        authService.registerUser(
                            nameController.text,
                            surnameController.text,
                            emailController.text,
                            passwordController.text,
                            context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
