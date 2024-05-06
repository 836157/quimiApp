import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';

import 'personalizadorwidget.dart';
import 'user.dart';

class ModificationScreen extends StatefulWidget {
  @override
  _ModificationScreenState createState() => _ModificationScreenState();
}

class _ModificationScreenState extends State<ModificationScreen> {
  final _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia de AuthenticationService
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);

    // Obtén el usuario actual (esto depende de cómo estés manejando la autenticación)
    User? currentUser = authService.currentUser;

    // Inicializa los controladores con la información del usuario actual
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No hay un usuario autenticado'),
      ));
      return const Scaffold(
        body: Center(
          child: Text('No hay un usuario autenticado'),
        ),
      );
    }

    _nameController.text = currentUser.nombre;
    _lastNameController.text = currentUser.apellidos;
    _emailController.text = currentUser.email;
    _passwordController.text = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modificación usuario',
          style: TextStyle(fontSize: 14),
        ),
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
                    controller: _nameController,
                    labelText: 'Nombre',
                    icon: Icons.face,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: _lastNameController,
                    labelText: 'Apellidos',
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: _emailController,
                    labelText: 'Correo Electrónico',
                    icon: Icons.mail,
                  ),
                  const SizedBox(height: 20.0),
                  PersonalizadorWidget.buildCustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    icon: Icons.vpn_key,
                  ),
                  const SizedBox(height: 35.0),
                  PersonalizadorWidget.buildCustomElevatedButton(
                    'Actualizar',
                    () async {
                      if (_formKey.currentState!.validate()) {
                        // Crea una copia del usuario actual
                        User updatedUser = User.clone(currentUser);
                        // Si el formulario es válido, actualiza la información del usuario
                        // Actualiza la información del usuario en la copia
                        updatedUser.nombre = _nameController.text;
                        updatedUser.apellidos = _lastNameController.text;
                        updatedUser.email = _emailController.text;
                        updatedUser.password = _passwordController.text;

                        // Actualiza el usuario en la base de datos
                        await authService.updateUser(updatedUser, context);
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
