import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

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
  var _confirmPasswordController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  User? currentUser;
  late AuthenticationService authService;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthenticationService>(context, listen: false);
    currentUser = authService.currentUser;
    if (currentUser != null) {
      _nameController = TextEditingController(text: currentUser?.nombre);
      _lastNameController = TextEditingController(text: currentUser?.apellidos);
      _emailController = TextEditingController(text: currentUser?.email);
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay un usuario autenticado'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
        title: 'Modificar usuario',
        context: context,
      ),
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40.0),
                      PersonalizadorWidget.buildCustomTextFormField(
                        context: context,
                        controller: _nameController,
                        labelText: 'Nombre',
                        icon: Icons.face,
                      ),
                      const SizedBox(height: 20.0),
                      PersonalizadorWidget.buildCustomTextFormField(
                        context: context,
                        controller: _lastNameController,
                        labelText: 'Apellidos',
                        icon: Icons.description,
                      ),
                      const SizedBox(height: 20.0),
                      PersonalizadorWidget.buildCustomTextFormField(
                        context: context,
                        controller: _emailController,
                        labelText: 'Correo Electrónico',
                        icon: Icons.mail,
                      ),
                      const SizedBox(height: 20.0),
                      PersonalizadorWidget.buildCustomTextFormField(
                        context: context,
                        controller: _passwordController,
                        labelText: 'Contraseña',
                        icon: Icons.vpn_key,
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
                                    '1 La contraseña debe tener al menos 8 caracteres, una letra y un número. Por favor, inténtelo de nuevo.'),
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
                        controller: _confirmPasswordController,
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
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d\W_]{8,}$';
                          RegExp regex = RegExp(patternPassword);
                          if (_confirmPasswordController.text !=
                              _passwordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '2 Las contraseñas no coinciden. Por favor, inténtelo de nuevo.'),
                              ),
                            );
                            return 'Invalid password';
                          }
                          if (!regex.hasMatch(value!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'La contraseña debe tener al menos 8 caracteres, una letra y un número. Por favor, inténtelo de nuevo.'),
                              ),
                            );
                            return 'Invalid password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 35.0),
                      PersonalizadorWidget.buildCustomElevatedButton(
                        context,
                        'Actualizar',
                        () async {
                          if (_formKey.currentState!.validate()) {
                            // Crea una copia del usuario actual
                            User updatedUser = User.clone(currentUser!);
                            // Si el formulario es válido, actualiza la información del usuario
                            // Actualiza la información del usuario en la copia
                            updatedUser.setNombre = _nameController.text;
                            updatedUser.setApellidos = _lastNameController.text;
                            updatedUser.setEmail = _emailController.text;
                            updatedUser.setPassword = _passwordController.text;

                            // Actualiza el usuario en la base de datos
                            await authService.updateUser(updatedUser, context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
