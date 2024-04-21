import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quimicapp/personalizadorwidget.dart';

class ReaccionesScreen extends StatefulWidget {
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
              padding: const EdgeInsets.all(24.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(labelText: label),
                keyboardType: TextInputType.number,
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
      body: SingleChildScrollView(
        child: Container(
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
              Card(
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
                    padding: const EdgeInsets.all(60.0),
                    child: Text('Reacción:\n $reaction'),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  buildInputField('A', _aController),
                  buildInputField('B', _bController),
                ],
              ),
              Row(
                children: <Widget>[
                  buildInputField('C', _cController),
                  buildInputField('D', _dController),
                ],
              ),
              PersonalizadorWidget.buildCustomElevatedButton(
                  "Validar", () async {})
            ],
          ),
        ),
      ),
    );
  }
}
