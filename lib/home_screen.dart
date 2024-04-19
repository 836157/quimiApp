import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/login_screen.dart';
import 'package:quimicapp/modification_screen.dart';
import 'package:quimicapp/quiz/quiz_screen.dart';
import 'package:quimicapp/tabla_periodica_screen.dart';

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
            buildCard('Quiz', QuizScreen(), context),
            /* buildCard('Formulación', context),
            buildCard('Disoluciones', context),
            buildCard('Estequiometría', context),
            buildCard('Scripts de Física', context),
            buildCard('Tipo Test', context),*/
          ],
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
}
