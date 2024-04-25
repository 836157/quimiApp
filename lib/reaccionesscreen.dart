import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quimicapp/imagenZoom.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/reaccion.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

Future<List<Reaccion>> listaReacciones() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/quimicApp/reacciones/listar'));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> datos = json.decode(body);
      return datos.map((dynamic item) => Reaccion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load request from API');
    }
  } catch (e) {
    throw Exception('Failed to load request from API');
  }
}

class ReaccionesScreen extends StatefulWidget {
  const ReaccionesScreen({super.key});

  @override
  _ReaccionesScreenState createState() => _ReaccionesScreenState();
}

class _ReaccionesScreenState extends State<ReaccionesScreen>
    with SingleTickerProviderStateMixin {
  Map<String, int?> _selectedValues = {};
  List<Reaccion> reacciones = [];
  int currentReaccionIndex = 0;
  String reaccionConValores = '';
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duración de la animación
      vsync: this,
    );
    _animation = ColorTween(
      begin: Colors.white, // Color inicial
      end: Colors.red, // Color final
    ).animate(_controller);

    listaReacciones().then((reaccionesFromFuture) {
      setState(() {
        //aqui se supone que cargo mi lista de reacciones para ir generando, un screen para cada reaccion.
        reacciones = reaccionesFromFuture;
      });
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // No olvides deshacerte del controlador cuando ya no lo necesites
    super.dispose();
  }

  bool _checkAnswer(Reaccion reaccion) {
    String? inputFieldAValue = _selectedValues['A'].toString();
    String? inputFieldBValue = _selectedValues['B'].toString();
    String? inputFieldCValue = _selectedValues['C'].toString();
    String? inputFieldDValue = _selectedValues['D'].toString();
    String? inputFieldEValue = _selectedValues['E'].toString();

    // Comprobamos si los valores de los campos de entrada coinciden con los valores correspondientes en la reacción.
    bool isCorrect = true;

    if (reaccion.A != null && reaccion.A.toString() != inputFieldAValue) {
      isCorrect = false;
    }
    if (reaccion.B != null && reaccion.B.toString() != inputFieldBValue) {
      isCorrect = false;
    }
    if (reaccion.C != null && reaccion.C.toString() != inputFieldCValue) {
      isCorrect = false;
    }
    if (reaccion.D != null && reaccion.D.toString() != inputFieldDValue) {
      isCorrect = false;
    }
    if (reaccion.E != null && reaccion.E.toString() != inputFieldEValue) {
      isCorrect = false;
    }

    if (isCorrect == false) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }

    final snackBar = SnackBar(
      content: Text(isCorrect ? 'Correcto' : 'Incorrecto'),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return isCorrect;
  }

  Widget buildInputField(String etiqueta, Reaccion reaccion) {
    int? reaccionValue;

    switch (etiqueta) {
      case 'A':
        reaccionValue = reaccion.A;
        break;
      case 'B':
        reaccionValue = reaccion.B;
        break;
      case 'C':
        reaccionValue = reaccion.C;
        break;
      case 'D':
        reaccionValue = reaccion.D;
        break;
      case 'E':
        reaccionValue = reaccion.E;
        break;
    }

    if (reaccionValue == null) {
      return Container(); // Devuelve un contenedor vacío si el valor es nulo
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            //padding: const EdgeInsets.all(1.0),
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
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: DropdownButton<int>(
                    hint: Text(etiqueta), // Texto por defecto
                    value: _selectedValues[
                        etiqueta], // Valor seleccionado para este campo
                    items: List.generate(15,
                            (index) => index + 1) // Genera números del 1 al 15
                        .map((int value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedValues[etiqueta] =
                            newValue; // Actualiza el valor seleccionado para este campo
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalElements = 5; // Cambia esto por el número total de elementos
    int firstRowElements = (totalElements <= 3)
        ? totalElements
        : (totalElements == 4)
            ? 2
            : 3;
    int secondRowElements = totalElements - firstRowElements;

    if (reacciones.isNotEmpty) {
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
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Balancea la siguiente reacción química:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Card(
                        color: _animation
                            .value, // Aquí utilizamos el valor de la animación
                        child: SizedBox(
                          height: 275,
                          width: 400,
                          child: Center(
                            child: Text(
                              reacciones[currentReaccionIndex].reaccion,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      reaccionConValores,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 20),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.green),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Cómo ajustar reacciones químicas'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text(
                                      'El método de tanteo para  balancear una ecuación química consiste en igualar el número y clase de átomos, iones o moléculas reactantes con los productos a fin  de cumplir la Ley de la conservación de la materia.'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ImageViewerScreen()),
                                      );
                                    },
                                    child: Container(
                                      child: Image.asset(
                                          'assets/ajusteReacciones.jpg'),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Wrap(
                spacing: 4.0, // espacio entre los hijos
                runSpacing: 15.0,
                children: <Widget>[
                  for (int i = 0; i < totalElements; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          left: (i == firstRowElements && totalElements == 5)
                              ? 40.0
                              : 0.0), // Ajusta el padding si es el primer elemento de la segunda fila y hay 5 elementos en total
                      child: buildInputField(String.fromCharCode(65 + i),
                          reacciones[currentReaccionIndex]),
                    ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              PersonalizadorWidget.buildCustomElevatedButton("Validar", () {
                //aqui quiero validar si las opciones introducidas para esa reaccion actual son correctas
                bool isCorrect = _checkAnswer(reacciones[currentReaccionIndex]);
                String reaccionABCDE =
                    reacciones[currentReaccionIndex].reaccion;
                reaccionConValores = reaccionABCDE
                    .replaceAll(
                        'A',
                        _selectedValues['A'] != null
                            ? _selectedValues['A'].toString()
                            : 'A')
                    .replaceAll(
                        'B',
                        _selectedValues['B'] != null
                            ? _selectedValues['B'].toString()
                            : 'B')
                    .replaceAll(
                        'C',
                        _selectedValues['C'] != null
                            ? _selectedValues['C'].toString()
                            : 'C')
                    .replaceAll(
                        'D',
                        _selectedValues['D'] != null
                            ? _selectedValues['D'].toString()
                            : 'D')
                    .replaceAll(
                        'E',
                        _selectedValues['E'] != null
                            ? _selectedValues['E'].toString()
                            : 'E');
                if (isCorrect) {
                  //si son correctas quiero pasar a la siguiente reaccion
                  setState(() {
                    reaccionConValores;

                    Future.delayed(const Duration(seconds: 3), () {
                      // Espera 3 segundos y luego pasa a la siguiente reacción
                      setState(() {
                        reaccionConValores =
                            ''; // Oculta la reacción transformada
                        currentReaccionIndex++;
                        _selectedValues = {};
                      });
                    });
                  });
                }
                //si lo fueran quiero pasar a la siguiente reaccion y volver a empezar el proceso.
              })
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
