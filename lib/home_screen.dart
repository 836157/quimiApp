import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/audioscreen.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/constantes/constantes.dart';
import 'package:quimicapp/formatotablascreen.dart';
import 'package:quimicapp/pdfscreen.dart';
import 'package:quimicapp/login_screen.dart';
import 'package:quimicapp/modification_screen.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/quiz/quiz_screen.dart';
import 'package:quimicapp/reaccionesscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quimicapp/themeAppDark/themenotifier.dart';
import 'package:quimicapp/user.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.user});

  final User? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late bool wasSuccessful;
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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        appBar: PersonalizadorWidget.buildGradientAppBar(
            context: context,
            title: 'Bienvenido ${widget.user?.nombre ?? 'Invitado'}'),
        body: Consumer<ThemeNotifier>(
          builder: (context, value, child) {
            return Container(
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
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    buildCard(
                        'Lector apuntes PDF', FormulacionCarrusel(), context),
                    buildCard('Ajuste Reacciones', ReaccionesScreen(), context),
                    buildCard('Tabla Periódica', TablaPeriodica(), context),
                    buildCard('Quiz', QuizScreen(), context),
                    buildCard('Audios Química', AudioPlayerScreen(), context),
                  ],
                ));
          },
        ),
        bottomNavigationBar:
            PersonalizadorWidget.buildGradientBottomNavigationBar(
          context: context,
          onTap: (index) {
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
                              padding: const EdgeInsets.all(15),
                              child: buildGradientCard(
                                Theme.of(context),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        // Variable para guardar el contenido del correo
                                        String emailContent = '';
                                        String emailSubject =
                                            "Tienes un mensaje de QuimicApp del usuario ${widget.user?.nombre ?? 'desconocido'}";
                                        return AlertDialog(
                                          title: Consumer<ThemeNotifier>(
                                            builder: (context, themeNotifier,
                                                child) {
                                              return Text(
                                                'Enviar correo a ${snapshot.data![index].nombre}',
                                                style: TextStyle(
                                                  color: themeNotifier
                                                          .isSecondTheme()
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    emailContent =
                                                        value; // Guarda el contenido del correo
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Mensaje a enviar:",
                                                    labelStyle: TextStyle(
                                                      color: themeNotifier
                                                              .isSecondTheme()
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  maxLines: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Consumer<ThemeNotifier>(
                                                builder: (context,
                                                    themeNotifier, child) {
                                                  return Text(
                                                    'Enviar',
                                                    style: TextStyle(
                                                      color: themeNotifier
                                                              .isSecondTheme()
                                                          ? Colors.red
                                                          : Colors.black,
                                                    ),
                                                  );
                                                },
                                              ),
                                              onPressed: () async {
                                                // Hacer la función async
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // Evita que el usuario cierre el diálogo
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 100,
                                                        width: 100,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          120),
                                                              child: Consumer<
                                                                  ThemeNotifier>(
                                                                builder: (context,
                                                                    themeNotifier,
                                                                    child) {
                                                                  return CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                        Color>(themeNotifier
                                                                            .isSecondTheme()
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            TweenAnimationBuilder(
                                                              tween:
                                                                  Tween<double>(
                                                                      begin: 1,
                                                                      end: 50),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              builder: (BuildContext
                                                                      context,
                                                                  double value,
                                                                  Widget?
                                                                      child) {
                                                                return Transform
                                                                    .translate(
                                                                  offset:
                                                                      Offset(
                                                                          value,
                                                                          0),
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            75,
                                                                        height:
                                                                            50,
                                                                        child: Consumer<
                                                                            ThemeNotifier>(
                                                                          builder: (context,
                                                                              themeNotifier,
                                                                              child) {
                                                                            return Marquee(
                                                                              text: 'Enviando...',
                                                                              style: TextStyle(color: themeNotifier.isSecondTheme() ? Colors.red : Colors.black),
                                                                              velocity: 50.0,
                                                                              blankSpace: 100.0,
                                                                              startPadding: 1.0,
                                                                              scrollAxis: Axis.horizontal,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Consumer<
                                                                          ThemeNotifier>(
                                                                        builder: (context,
                                                                            themeNotifier,
                                                                            child) {
                                                                          return Icon(
                                                                            Icons.mail_outline,
                                                                            color: themeNotifier.isSecondTheme()
                                                                                ? Colors.red
                                                                                : Colors.black,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );

                                                // Llamar a la función enviarCorreo
                                                bool result =
                                                    await enviarCorreo(
                                                  context,
                                                  snapshot.data![index].email,
                                                  emailSubject,
                                                  emailContent,
                                                );

                                                Navigator.pop(
                                                    context); // Cerrar el diálogo de 'Enviando...'

                                                if (result) {
                                                  // Si el correo se envió con éxito, mostrar un diálogo de éxito y luego volver a la pantalla de inicio
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Correo enviado',
                                                          style: TextStyle(
                                                              color: themeNotifier
                                                                      .isSecondTheme()
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        content: Text(
                                                            'El correo se ha enviado correctamente'),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              'Cerrar',
                                                              style: TextStyle(
                                                                  color: themeNotifier
                                                                          .isSecondTheme()
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context); // Cerrar el diálogo de error
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  // Si el correo no se envió, mostrar un diálogo de error
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Error',
                                                          style: TextStyle(
                                                              color: themeNotifier
                                                                      .isSecondTheme()
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        content: Text(
                                                            'No se ha podido enviar el correo'),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              'Cerrar',
                                                              style: TextStyle(
                                                                  color: themeNotifier
                                                                          .isSecondTheme()
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context); // Cerrar el diálogo de error
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Lottie.asset(
                                    'assets/correo.json',
                                    width: 50,
                                    height: 50, // Ajusta el tamaño a tu gusto
                                  ),
                                ),
                                Text(snapshot.data![index].nombre),
                                () {},
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
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: <Widget>[
                          buildGradientCard(
                            Theme.of(context),
                            const Icon(Icons.logout),
                            const Text('Cerrar sesión'),
                            () {
                              authService.logout();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Sesión cerrada correctamente. Hasta luego!')));
                              Navigator.pop(
                                  context); // Cierra la hoja inferior modal
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              ); // Cierra la hoja inferior modal
                            },
                          ),
                          buildGradientCard(
                            Theme.of(context),
                            Icon(Icons.edit),
                            Text('Modificar usuario'),
                            () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ModificationScreen()),
                              ); // Cierra la hoja inferior modal
                            },
                          ),
                          buildGradientCard(
                            Theme.of(context),
                            Icon(Icons.brightness_6),
                            Text('Cambiar Tema'),
                            () {
                              final themeNotifier = Provider.of<ThemeNotifier>(
                                  context,
                                  listen: false);
                              themeNotifier.setTheme();
                              Navigator.pop(
                                  context); // Cierra la hoja inferior modal
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
                break;
            }
          },
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
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: Lottie.asset('assets/iconoAtomo.json',
              width: 42.0, height: 42.0, fit: BoxFit.cover),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black), // Cambia el color del texto a negro
          ),
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

  Widget buildGradientCard(
      ThemeData theme, Widget leading, Widget title, VoidCallback onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            leading: leading, // Widget personalizado
            title: title, // Widget personalizado
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  Future<List<User>> obtenerUsuariosEnLinea() async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/usuarios/listarActivos'));
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

  Future<bool> enviarCorreo(BuildContext context, String correo, String asunto,
      String contenido) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/send-email/sendUserEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'emailRecipient': correo,
          'emailSubject': asunto,
          'emailBody': contenido,
        }),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
