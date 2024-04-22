import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quimicapp/personalizadorwidget.dart';

class ReaccionesScreen extends StatefulWidget {
  const ReaccionesScreen({super.key});

  @override
  _ReaccionesScreenState createState() => _ReaccionesScreenState();
}

class _ReaccionesScreenState extends State<ReaccionesScreen> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _dController = TextEditingController();

  // Esta sería la reacción química que obtienes de tu base de datos
  final String reaction = 'H2 + O2 -> H2O';
  // Estos serían los coeficientes que obtienes de tu base de datos
  final int A = 2, B = 1, C = 2, D = 0;

  void _checkAnswer() {
    if (int.parse(_aController.text) == A &&
        int.parse(_bController.text) == B &&
        int.parse(_cController.text) == C &&
        int.parse(_dController.text) == D) {
      // Los coeficientes introducidos por el usuario son correctos
      print('Correcto');
    } else {
      // Los coeficientes introducidos por el usuario son incorrectos
      print('Incorrecto');
    }
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(1.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
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
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                child: DropdownButton<int>(
                  value: 1,
                  items: List<int>.generate(20, (i) => i + 1).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Reacciones químicas',
          style: TextStyle(fontSize: 18),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondoFinal.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              'Balancea la siguiente reacción química:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Card(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Cambia el color de fondo a blanco
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(90.0), // Ajusta el padding
                  child: Center(
                    child: Text(
                      reaction,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black), // Hace que el texto sea negrita y de color negro
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                buildInputField('A', _aController),
                SizedBox(
                    width: 20), // Agrega espacio entre los campos de entrada
                buildInputField('B', _bController),
              ],
            ),
            SizedBox(height: 20), // Agrega espacio entre las filas
            Row(
              children: <Widget>[
                buildInputField('C', _cController),
                SizedBox(
                    width: 20), // Agrega espacio entre los campos de entrada
                buildInputField('D', _dController),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            PersonalizadorWidget.buildCustomElevatedButton(
                "Validar", () async {})
          ],
        ),
      ),
    );
  }
}
