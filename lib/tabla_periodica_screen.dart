import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:quimicapp/elemento.dart';
import 'package:quimicapp/formatotablascreen.dart';
import 'package:quimicapp/personalizadorwidget.dart';

Future<List<Elemento>> fetchElement() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/quimicApp/elemento/listar'));

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      List<dynamic> datos = jsonDecode(body);
      return datos.map((dynamic item) => Elemento.fromJson(item)).toList();
    } else {
      throw Exception('request failed');
    }
  } catch (e) {
    throw Exception('Failed to load Element');
  }
}

class TablaPeriodicaScreen extends StatefulWidget {
  @override
  _TablaPeriodicaScreenState createState() => _TablaPeriodicaScreenState();
}

class _TablaPeriodicaScreenState extends State<TablaPeriodicaScreen> {
  Future<List<Elemento>>? elementos;
  String? familiaSeleccionada;
  List<Elemento> elementosFiltrados = [];

  final familias = {
    'Metal Alcalino': const Color.fromARGB(255, 247, 170, 192),
    'Tierra alcalina': const Color.fromARGB(255, 255, 220, 169),
    'No Metal': const Color.fromARGB(255, 192, 215, 240),
    'Metaloides': const Color.fromARGB(255, 147, 217, 245),
    'Metales de post-transicion': const Color.fromARGB(255, 212, 235, 216),
    'Metales de transicion': const Color.fromARGB(255, 247, 246, 204),
    'Halogenos': const Color.fromARGB(255, 224, 224, 240),
    'Gases Nobles': const Color.fromARGB(255, 225, 207, 229),
    'Lantánidos': const Color.fromARGB(255, 252, 224, 237),
    'Actínidos': const Color.fromARGB(255, 250, 191, 226),
  };

  @override
  void initState() {
    super.initState();
    elementos = fetchElement();
  }

  Widget _buildBody(Elemento elemento) {
    return FractionallySizedBox(
      widthFactor: 1.2, // Ajusta esto para cambiar el ancho del contenedor
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: familias[elemento.familia] ?? Colors.white, // color de fondo
          borderRadius: BorderRadius.circular(20), // bordes redondeados
        ),
        child: SingleChildScrollView(
          // Hace que el contenido sea desplazable
          child: Column(
            children: <Widget>[
              Image.asset('assets/${elemento.simbolo}.gif',
                  fit: BoxFit.cover), // Añade el gif al principio
              DataTableTheme(
                data: const DataTableThemeData(
                  headingRowHeight:
                      0.0, // Set this to 0.0 to remove the header space
                ),
                child: DataTable(
                  columnSpacing: 10,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: SizedBox.shrink(),
                    ),
                    DataColumn(
                      label: SizedBox.shrink(),
                    ),
                  ],
                  rows: elemento.toMap().entries.map((entry) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Row(
                            children: <Widget>[
                              Lottie.asset('assets/iconoAtomo.json',
                                  width: 24, height: 24),
                              Text(entry.key,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        DataCell(
                          Text('${entry.value}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tabla Periodica'),
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
          IconButton(
            icon: Icon(Icons.table_chart), // Cambia esto al ícono que prefieras
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TablaPeriodica(elementos: elementos)),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                familiaSeleccionada = result;
              });
            },
            itemBuilder: (BuildContext context) {
              return familias.keys.map((String familia) {
                return PopupMenuItem<String>(
                  value: familia,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: familias[familia],
                        radius: 10,
                      ),
                      const SizedBox(width: 8),
                      Text(familia),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Elemento>>(
        future: elementos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            elementosFiltrados = snapshot.data!;
            if (familiaSeleccionada != null) {
              elementosFiltrados = elementosFiltrados
                  .where((elemento) => elemento.familia == familiaSeleccionada)
                  .toList();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: elementosFiltrados.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pop(), // Cierra el diálogo cuando se toca fuera
                              child: _buildBody(elementosFiltrados[index]),
                            ),
                          );
                        },
                      );
                    },
                    child: ElementCard(elemento: elementosFiltrados[index]),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
