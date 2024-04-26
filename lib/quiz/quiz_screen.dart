import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/pregunta.dart';
import 'package:http/http.dart' as http;
import 'package:quimicapp/quiz/quiz_page.dart';
import 'package:quimicapp/quiz/quiz_makequestion.dart';

Future<List<Pregunta>> cuestionarioQuizTematica(String tematica) async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/quimicApp/preguntas/tematica/$tematica'));

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    List jsonResponse = json.decode(body);
    return jsonResponse.map((item) => Pregunta.fromJson(item)).toList();
  } else {
    throw Exception('Fallo al cargar las preguntas de la temática $tematica');
  }
}

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Game',
          style: TextStyle(
            fontSize: 24,
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoFinal.jpg'), // Imagen de fondo
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            // Nuevo Padding widget
            padding: const EdgeInsets.only(
                bottom: 95.0), // Añade espacio en la parte inferior
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 320, // Define la altura
                  width: 370, // Define la anchura
                  child: PersonalizadorWidget.neonQuiz(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: PersonalizadorWidget.buildCustomElevatedButton(
                      "Iniciar Quiz", () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Elige una temática'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                // Aquí puedes añadir los widgets para las opciones de temática
                                // Por ejemplo, podrías tener un widget para cada familia de la tabla periódica
                                ListTile(
                                  leading: Image.asset(
                                      'assets/icon_cuestionario.png'), // Añade un icono
                                  title: const Text(
                                    'Formulación',
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold), // Hace el texto en negrita
                                    textAlign:
                                        TextAlign.center, // Centra el texto
                                  ),
                                  onTap: () async {
                                    String tematica = 'Formulación';
                                    List<Pregunta> preguntas =
                                        await cuestionarioQuizTematica(
                                            tematica);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QuizPage(preguntas: preguntas),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20), // Añade espacio
                                ListTile(
                                  leading: Image.asset(
                                      'assets/icon_cuestionario.png'), // Añade un icono
                                  title: Text(
                                    'Propiedades de la Materia',
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold), // Hace el texto en negrita
                                    textAlign:
                                        TextAlign.center, // Centra el texto
                                  ),
                                  onTap: () {
                                    // Aquí puedes manejar la selección de esta opción
                                  },
                                ),
                                SizedBox(height: 20), // Añade espacio
                                ListTile(
                                  leading: Image.asset(
                                      'assets/icon_cuestionario.png'), // Añade un icono
                                  title: Text(
                                    'Preguntas Usuarios',
                                    style: TextStyle(
                                        fontWeight: FontWeight
                                            .bold), // Hace el texto en negrita
                                    textAlign:
                                        TextAlign.center, // Centra el texto
                                  ),
                                  onTap: () async {
                                    String tematica = 'usuarios';
                                    List<Pregunta> preguntas =
                                        await cuestionarioQuizTematica(
                                            tematica);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QuizPage(preguntas: preguntas),
                                      ),
                                    );
                                  },
                                ),
                                // Añade más opciones aquí
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PersonalizadorWidget.buildCustomElevatedButton(
                      "Crear preguntas", () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizMakeQuestionScreen()),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
