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
        title: const Text('Nuevo usuario'),
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
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondoFinal.jpg"),
              fit: BoxFit.fill,
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
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    context: context,
                    controller: passwordController,
                    labelText: 'Contraseña',
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomElevatedButton(
                    context,
                    'Registrarse',
                    () async {
                      String pattern =
                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                      RegExp regex = RegExp(pattern);
                      if (regex.hasMatch(emailController.text)) {
                        if (_formKey.currentState!.validate()) {
                          authService.registerUser(
                              nameController.text,
                              surnameController.text,
                              emailController.text,
                              passwordController.text,
                              context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor ingrese un correo válido'),
                          ),
                        );
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
