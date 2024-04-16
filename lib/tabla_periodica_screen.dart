import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quimicapp/elemento.dart';

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
    print(e.toString());
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
    'Metales post-transicion': const Color.fromARGB(255, 212, 235, 216),
    'Metales de transicion': const Color.fromARGB(255, 247, 246, 204),
    'Halogenos': const Color.fromARGB(255, 224, 224, 240),
    'Gases Nobles': const Color.fromARGB(255, 225, 207, 229),
    'Lantanidos': const Color.fromARGB(255, 252, 224, 237),
    'Actinidos': const Color.fromARGB(255, 250, 191, 226),
  };

  @override
  void initState() {
    super.initState();
    elementos = fetchElement();
  }

  Widget _buildBody(Elemento elemento) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: familias[elemento.familia] ?? Colors.white, // color de fondo
        borderRadius: BorderRadius.circular(20), // bordes redondeados
        boxShadow: [
          // sombra
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 120, // Define el ancho de la imagen
            height: 160, // Define la altura de la imagen
            child: Image.asset(
              'assets/${elemento.id}.jpg',
              fit: BoxFit
                  .contain, // Asegura que la imagen se ajuste al contenedor
            ),
          ),
          Text('Nombre: ${elemento.nombre}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Número Atómico: ${elemento.numeroAtomico}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Símbolo: ${elemento.simbolo}', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Peso Atómico: ${elemento.pesoAtomico} u',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Geometría Más Común: ${elemento.geometriaMasComun}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Densidad: ${elemento.densidad} g/cm³',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Punto de Fusión: ${elemento.puntoFusion}K',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Punto de Ebullición: ${elemento.puntoEbullicion}K',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Calor Específico: ${elemento.calorEspecifico}J/(g·K)',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text(
              'Electronegatividad: ${elemento.electronegatividad} Pauling(0-4)',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Radio Atómico: ${elemento.radioAtomico} pm',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Radio Covalente: ${elemento.radioCovalente}pm',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Radio Iónico: ${elemento.radioIonico}pm',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla Periodica'),
        actions: <Widget>[
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondologin.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Elemento>>(
          future: elementos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              elementosFiltrados = snapshot.data!;
              if (familiaSeleccionada != null) {
                elementosFiltrados = elementosFiltrados
                    .where(
                        (elemento) => elemento.familia == familiaSeleccionada)
                    .toList();
              }
              return GridView.builder(
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
                            content: _buildBody(elementosFiltrados[index]),
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/${elementosFiltrados[index].nombre}.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
