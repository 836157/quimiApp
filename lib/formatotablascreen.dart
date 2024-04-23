import 'package:flutter/material.dart';
import 'package:quimicapp/elemento.dart';

class TablaPeriodica extends StatelessWidget {
  Future<List<Elemento>>? elementos;

  TablaPeriodica({required this.elementos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tabla Periódica'),
          automaticallyImplyLeading: true,
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
          // backgroundColor: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white, // Establece el color de fondo aquí
          ),
          child: FutureBuilder<List<Elemento>>(
            future: elementos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Muestra un mensaje de error si algo sale mal
              } else {
                final elementosResueltos = snapshot.data ?? [];
                final tiles = List.generate(10,
                    (_) => List<Widget>.filled(18, const SizedBox.square()));

                for (int i = 0; i < 10; i++) {
                  for (int j = 0; j < 18; j++) {
                    final elemento = elementosResueltos.firstWhere(
                      (e) => e.posicionX == i && e.posicionY == j,
                      orElse: () => Elemento(
                          id: 0,
                          simbolo: '',
                          posicionX: i,
                          posicionY: j), // Devuelve un nuevo Elemento con id 0
                    );

                    if (elemento.id != 0) {
                      tiles[i][j] = _crearCard(elemento, context);
                    } else {
                      tiles[i][j] = _vaciaCard(elemento);
                    }
                  }
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: tiles.map((row) => Row(children: row)).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget _crearCard(Elemento elemento, BuildContext context) {
    final familias = {
      'Metal Alcalino': const Color.fromARGB(255, 247, 170, 192),
      'Tierra alcalina': const Color.fromARGB(255, 255, 220, 169),
      'No Metal': const Color.fromARGB(255, 192, 215, 240),
      'Metaloides': const Color.fromARGB(255, 147, 217, 245),
      'Metales de post-transición': const Color.fromARGB(255, 212, 235, 216),
      'Metales de transición': const Color.fromARGB(255, 247, 246, 204),
      'Halógenos': const Color.fromARGB(255, 224, 224, 240),
      'Gases Nobles': const Color.fromARGB(255, 225, 207, 229),
      'Lantánidos': const Color.fromARGB(255, 252, 224, 237),
      'Actínidos': const Color.fromARGB(255, 250, 191, 226),
    };
    return SizedBox(
      width: 70.0, // Ancho fijo
      height: 70.0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleElementoScreen(elemento: elemento),
            ),
          );
        },
        child: Card(
          elevation: 10.0,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  elemento.color1 ?? Colors.black,
                  elemento.color2 ?? Colors.black
                ],
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                    elemento.simbolo,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  child: Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: familias[elemento.familia],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vaciaCard(Elemento elemento) {
    return SizedBox(
      width: 70.0, // Ancho fijo
      height: 70.0,
      child: Card(
        color: Colors.transparent,
        elevation: 10.0,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                elemento.simbolo,
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalleElementoScreen extends StatelessWidget {
  final Elemento elemento;

  DetalleElementoScreen({required this.elemento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(elemento.nombre!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _crearFila('Nombre', elemento.nombre!, Icons.account_circle),
              _crearFila('Número Atómico', elemento.numeroAtomico.toString(),
                  Icons.format_list_numbered),
              _crearFila('Símbolo', elemento.simbolo, Icons.text_fields),
              _crearFila('Peso Atómico', elemento.pesoAtomico.toString(),
                  Icons.line_weight),
              _crearFila('Geometría Más Común', elemento.geometriaMasComun!,
                  Icons.grid_view),
              _crearFila(
                  'Densidad', '${elemento.densidad} g/cm³', Icons.view_array),
              _crearFila('Punto de Fusión', '${elemento.puntoFusion} K',
                  Icons.thermostat),
              _crearFila('Punto de Ebullición', '${elemento.puntoEbullicion} K',
                  Icons.thermostat_outlined),
              _crearFila(
                  'Calor Específico',
                  '${elemento.calorEspecifico} J/(g·K)',
                  Icons.fire_extinguisher),
              _crearFila(
                  'Electronegatividad',
                  elemento.electronegatividad.toString(),
                  Icons.electrical_services),
              _crearFila(
                  'Radio Atómico', '${elemento.radioAtomico} pm', Icons.radio),
              _crearFila('Radio Covalente', '${elemento.radioCovalente} pm',
                  Icons.radio_button_checked),
              _crearFila('Radio Iónico', '${elemento.radioIonico} pm',
                  Icons.radio_button_unchecked),
              _crearFila('Familia', elemento.familia!, Icons.family_restroom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearFila(String titulo, String valor, IconData icono) {
    return ListTile(
      leading: Icon(icono, color: Colors.white),
      title: Text(
        titulo,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        valor,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
