import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Game'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/quiz.jpg'), // Imagen de fondo
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Padding(
            // Nuevo Padding widget
            padding: const EdgeInsets.only(
                bottom: 55.0), // Añade espacio en la parte inferior
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PersonalizadorWidget.buildCustomElevatedButton(
                      "Iniciar Quiz", () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Elige una temática'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                // Aquí puedes añadir los widgets para las opciones de temática
                                // Por ejemplo, podrías tener un widget para cada familia de la tabla periódica
                                ListTile(
                                  leading: Image.asset(
                                      'assets/icon_cuestionario.png'), // Añade un icono
                                  title: Text(
                                    'Formulacion Inorganica',
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
                                    'Ajuste de Reacciones Químicas',
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
                      "Repasar Quiz", () async {}),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
