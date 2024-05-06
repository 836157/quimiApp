import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quimicapp/home_screen.dart';
import 'package:quimicapp/user.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class AuthenticationService extends ChangeNotifier {
  User? currentUser;

  Future<void> login(
      String correo, String password, BuildContext context) async {
    // Aquí el código para iniciar sesión
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.23:8080/quimicApp/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'correo': correo,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, entonces se concede el acceso
        // y se devuelve el usuario
        String body = utf8.decode(response.bodyBytes);
        currentUser = User.fromJson(jsonDecode(body));
        notifyListeners();
        if (currentUser != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: currentUser!),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario o contraseña incorrectos')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Error al iniciar sesión. Por favor, inténtalo de nuevo')));
    }
  }

  Future<void> registerUser(String name, String surname, String email,
      String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.0.23:8080/quimicApp/usuarios/save'), // URL de la API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': name,
          'apellido': surname,
          'correo': email,
          'password': password,
          'activo': false,
        }),
      );
      if (response.statusCode == 200) {
        // Muestra un SnackBar con el mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'El correo insertado ya existe en nuestra Base de datos, por favor intente con otro correo.')),
        );
      }
    } catch (e) {
      // Muestra un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error al registrar el usuario, intente nuevamente mas tarde')),
      );
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser(User user, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.23:8080/quimicApp/usuarios/mod'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": user.id
              .toString(), // Se debe enviar el id del usuario para identificarlo
          'nombre': user.nombre,
          'apellido': user.apellidos,
          'correo': user.email,
          'password': user.password,
        }),
      );
      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, entonces se actualiza la información del usuario
        currentUser = user;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado exitosamente')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: currentUser!),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Error al actualizar el usuario. Por favor, inténtalo de nuevo')));
    }
  }
}
