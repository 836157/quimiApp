import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';
import 'package:http/http.dart' as http;

class RecuperacionPasswordScreen extends StatefulWidget {
  const RecuperacionPasswordScreen({super.key});

  @override
  State<RecuperacionPasswordScreen> createState() =>
      _RecuperacionPasswordScreenState();
}

class _RecuperacionPasswordScreenState
    extends State<RecuperacionPasswordScreen> {
  Future<bool> recuperarContrasena(String correo, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.0.23:8080/quimicApp/send-email/recuperarCorreo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'emailRecipient': correo,
          "emailSubject": "Recuperacion cuenta correo. Cambio credenciales",
          "emailBody":
              "No comparta contraseñas con terceros y pongalas a buen recaudo."
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool>? _future;

  @override
  void initState() {
    super.initState();
    _future = null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
        context: context,
        title: 'Recuperación de contraseña',
      ),
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
                    const SizedBox(height: 40.0),
                    const Text(
                      'Se enviará un correo con las instrucciones para recuperar tu contraseña a traves de la dirección de correo electrónico proporcionada:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 40.0),
                    PersonalizadorWidget.buildCustomTextFormField(
                      context: context,
                      controller: emailController,
                      labelText: 'Correo electronico',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 40.0),
                    _future == null
                        ? PersonalizadorWidget.buildCustomElevatedButton(
                            context,
                            'Enviar',
                            () {
                              String pattern =
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                              RegExp regex = RegExp(pattern);
                              if (regex.hasMatch(emailController.text)) {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _future = recuperarContrasena(
                                        emailController.text, context);
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor ingrese un correo válido'),
                                  ),
                                );
                              }
                            },
                          )
                        : FutureBuilder<bool>(
                            future: _future,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              } else {
                                if (snapshot.hasError || !snapshot.data!) {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Error al enviar el correo. Por favor, inténtalo de nuevo'),
                                      ),
                                    );
                                  });
                                  return Container(); // Devuelve un Widget vacío
                                } else {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Email enviado correctamente, consulte su correo.'),
                                      ),
                                    );
                                  });
                                  return Container(); // Devuelve un Widget vacío
                                }
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
