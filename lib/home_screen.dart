import 'package:flutter/material.dart';
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
            text: 'Bienvenido, ',
            style: const TextStyle(color: Colors.black, fontSize: 18),
            children: <TextSpan>[
              TextSpan(
                text: user?.nombre ?? 'Invitado',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              TextSpan(
                text: ' ${user?.apellidos ?? ''}',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
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
            image: AssetImage("assets/fondoAzulmetal.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          //color: Colors.white.withOpacity(0.2), // Semi-transparent white
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 120.0),
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
        leading: Image.asset('assets/atomo.png', width: 42.0, height: 42.0),
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
