import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/audioscreen.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/formatotablascreen.dart';
import 'package:quimicapp/pdfscreen.dart';
import 'package:quimicapp/login_screen.dart';
import 'package:quimicapp/modification_screen.dart';
import 'package:quimicapp/quiz/quiz_screen.dart';
import 'package:quimicapp/reaccionesscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quimicapp/user.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.user});

  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _timer = Timer.periodic(const Duration(seconds: 25), (timer) {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService =
        Provider.of<AuthenticationService>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              style: (Theme.of(context).appBarTheme.titleTextStyle ??
                      const TextStyle())
                  .copyWith(fontSize: 14),
              text: 'Bienvenido ',
              children: <TextSpan>[
                TextSpan(
                  text: widget.user?.nombre ?? 'Invitado',
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
                    MaterialPageRoute(
                        builder: (context) => ModificationScreen()),
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
              buildCard('Apuntes PDF', FormulacionCarrusel(), context),
              buildCard('Ajuste Reacciones', ReaccionesScreen(), context),
              buildCard('Tabla Periódica', TablaPeriodica(), context),
              buildCard('Quiz', QuizScreen(), context),
              buildCard('Audios Química', AudioPlayerScreen(), context),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            /*borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),*/
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
                      return FutureBuilder<List<User>>(
                        future: obtenerUsuariosEnLinea(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<User>> snapshot) {
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
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(6),
                                child: Card(
                                  elevation:
                                      5, // Esto da una sombra a la tarjeta
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(
                                                0xFF4CAF50), // Un tono de verde
                                            Color(
                                                0xFF8BC34A), // Otro tono de verde
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title:
                                                    const Text('Enviar correo'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Enviar'),
                                                    onPressed: () async {},
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Lottie.asset(
                                            'assets/correo.json',
                                            width: 50,
                                            height:
                                                50, // Ajusta el tamaño a tu gusto
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data![index].nombre,
                                          style: const TextStyle(
                                            color: Colors
                                                .white, // Esto hace que el texto sea blanco
                                            fontWeight: FontWeight
                                                .bold, // Esto hace que el texto sea en negrita
                                          ),
                                        ),
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
      ),
    );
  }

  Widget buildCard(String title, Widget screen, BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspectiva
            ..rotateX(2 * pi * _controller.value),
          alignment: FractionalOffset.center,
          child: child,
        );
      },
      child: Card(
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
      ),
    );
  }

  Future<List<User>> obtenerUsuariosEnLinea() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.23:8080/quimicApp/usuarios/listarActivos'));
      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final List<dynamic> datosActivos = json.decode(body);
        return datosActivos.map((dynamic item) => User.fromJson(item)).toList();
      } else {
        throw Exception('request failed');
      }
    } catch (e) {
      throw Exception('Failed to load Element');
    }
  }
}
