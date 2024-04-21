import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/login_screen.dart';
import 'package:quimicapp/modification_screen.dart';
import 'package:quimicapp/quiz/quiz_screen.dart';
import 'package:quimicapp/tabla_periodica_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quimicapp/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).appBarTheme.titleTextStyle ??
                const TextStyle(),
            text: 'Hola ',
            children: <TextSpan>[
              TextSpan(
                text: user?.nombre ?? 'Invitado',
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,
        shadowColor: Colors.black,
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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Cerrar sesión') {
                authService.logout();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Sesión cerrada correctamente. Hasta luego!')));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else if (value == 'Modificar usuario') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModificationScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Cerrar sesión', 'Modificar usuario'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondoFinal.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 30.0),
            buildCard('Tabla Periódica', TablaPeriodicaScreen(), context),
            buildCard('Quiz', const QuizScreen(), context),
            /* buildCard('Formulación', context),
            buildCard('Disoluciones', context),
            buildCard('Estequiometría', context),
            buildCard('Scripts de Física', context),
            buildCard('Tipo Test', context),*/
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Usuarios en línea',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
          ],
          onTap: (index) {
            // Aquí puedes manejar el cambio de la selección
            // Por ejemplo, puedes usar un switch/case para navegar a diferentes pantallas
            switch (index) {
              case 0:
                // Navegar a la pantalla de "Usuarios en línea"
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return FutureBuilder<List<String>>(
                      future: obtenerUsuariosEnLinea(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child:
                                  Text('Error al obtener usuarios en línea'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 5, // Esto da una sombra a la tarjeta
                              child: Container(
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors
                                        .green, // Esto hace que el círculo sea verde
                                  ),
                                  title: Text(
                                    snapshot.data![index],
                                    style: TextStyle(
                                      color: Colors
                                          .white, // Esto hace que el texto sea blanco
                                      fontWeight: FontWeight
                                          .bold, // Esto hace que el texto sea en negrita
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
                break;
              case 1:
                // Navegar a la pantalla de "Ajustes"
                break;
            }
          },
        ),
      ),
    );
  }

  Card buildCard(String title, Widget screen, BuildContext context) {
    return Card(
      color: Colors.white70,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Lottie.asset('assets/iconoAtomo.json',
            width: 42.0, height: 42.0, fit: BoxFit.fill),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }

  Future<List<String>> obtenerUsuariosEnLinea() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8080/quimicApp/usuarios/listarActivos'));
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> datos = jsonDecode(body);

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> usuariosEnJson = json.decode(decodedBody);
        final List<String> usuariosEnLinea = usuariosEnJson
            .map((usuario) => usuario['nombre'] as String)
            .toList();
        return usuariosEnLinea;
      } else {
        throw Exception('request failed');
      }
    } catch (e) {
      throw Exception('Failed to load Element');
    }
  }
}
