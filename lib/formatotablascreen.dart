import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/constantes/constantes.dart';
import 'package:quimicapp/elemento.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

final familias = {
  'Metal Alcalino': [
    const Color.fromARGB(255, 247, 170, 192),
    const Color.fromARGB(255, 247, 170, 192)
  ],
  'Tierra alcalina': [
    const Color.fromARGB(255, 255, 220, 169),
    const Color.fromARGB(255, 255, 220, 169)
  ],
  'No Metal': [
    const Color.fromARGB(255, 192, 215, 240),
    const Color.fromARGB(255, 192, 215, 240)
  ],
  'Metaloides': [
    const Color.fromARGB(255, 117, 187, 215),
    const Color.fromARGB(255, 117, 187, 215)
  ],
  'Metales de post-transición': [
    const Color.fromARGB(255, 212, 235, 216),
    const Color.fromARGB(255, 212, 235, 216)
  ],
  'Metales de transición': [
    const Color.fromARGB(255, 241, 240, 182),
    const Color.fromARGB(255, 241, 240, 182)
  ],
  'Halógenos': [
    const Color.fromARGB(255, 198, 198, 241),
    const Color.fromARGB(255, 198, 198, 241)
  ],
  'Gases Nobles': [
    const Color.fromARGB(255, 227, 202, 233),
    const Color.fromARGB(255, 227, 202, 233)
  ],
  'Lantánidos': [
    const Color.fromARGB(255, 199, 252, 192),
    const Color.fromARGB(255, 199, 252, 192)
  ],
  'Actínidos': [
    const Color.fromARGB(255, 250, 191, 226),
    const Color.fromARGB(255, 250, 191, 226)
  ],
};
Map<String, IconData> iconosFamilias = {
  'Metal Alcalino': Icons.circle,
  'Tierra alcalina': Icons.square,
  'No Metal': Icons.rice_bowl,
  'Metaloides': Icons.star,
  'Gases Nobles': Icons.smoke_free_rounded,
  'Metales de post-transición': Icons.pentagon,
  'Metales de transición': Icons.hexagon,
  'Halógenos': Icons.tornado,
  'Lantánidos': Icons.question_mark,
  'Actínidos': Icons.radar,
  // Agrega más familias e íconos aquí
};
Future<List<Elemento>> fetchElement() async {
  try {
    final response = await http.get(Uri.parse('$BASE_URL/elemento/listar'));

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

class TablaPeriodica extends StatefulWidget {
  TablaPeriodica({super.key});

  @override
  State<TablaPeriodica> createState() => _TablaPeriodicaState();
}

class _TablaPeriodicaState extends State<TablaPeriodica> {
  Future<List<Elemento>>? elementos;
  String? familiaSeleccionada;
  List<Elemento> elementosFiltrados = [];

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
        title: 'Tabla Periódica',
        context: context,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                familiaSeleccionada = result == 'TODOS' ? null : result;
              });
            },
            itemBuilder: (BuildContext context) {
              return familias.keys.map((String familia) {
                return PopupMenuItem<String>(
                  value: familia,
                  child: ListTile(
                    leading: Icon(iconosFamilias[familia]),
                    title: Text(familia),
                  ),
                );
              }).toList()
                ..add(const PopupMenuItem<String>(
                  value: 'TODOS',
                  child: ListTile(
                    leading: Icon(Icons.select_all),
                    title: Text('TODOS'),
                  ),
                ));
            },
          ),
        ],
      ),
      body: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return Container(
            decoration: themeNotifier.isUsingFirstTheme
                ? const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/humo.gif"),
                      fit: BoxFit.cover,
                    ),
                  )
                : const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/humoRojo.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: FutureBuilder<List<Elemento>>(
              future: fetchElement(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
                            posicionY: j,
                            valencias: []),
                      );

                      if (elemento.id != 0) {
                        tiles[i][j] = _crearCard(elemento, context);
                      } else {
                        tiles[i][j] = _vaciaCard(elemento);
                      }
                    }
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children:
                              tiles.map((row) => Row(children: row)).toList(),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _crearCard(Elemento elemento, BuildContext context) {
    bool estaHabilitado =
        familiaSeleccionada == null || elemento.familia == familiaSeleccionada;
    return SizedBox(
      width: 70.0, // Ancho fijo
      height: 70.0,
      child: GestureDetector(
        onTap: estaHabilitado
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(elemento),
                  ),
                );
              }
            : null,
        child: Opacity(
          opacity: estaHabilitado ? 1 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: familias[elemento.familia] ??
                    [
                      Colors.black,
                      Colors.grey,
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Card(
              color: Colors.transparent,
              elevation: 20.0,
              //shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      elemento.simbolo,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40.0,
                    right: 7.0,
                    child: Text(
                      elemento.numeroAtomico.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3.0,
                    left: 1.0,
                    child: Icon(
                      iconosFamilias[elemento
                          .familia], // Usa el ícono asociado con la familia del elemento
                      color: Colors.black,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
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
        color: Colors.white.withOpacity(0.7),
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

class DetailPage extends StatelessWidget {
  DetailPage(this.element);
  final List<String> jpgfileIds = ['85,100,101,102,103,104'];
  final Elemento element;

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[
      ListTile(
        leading:
            Icon(Icons.text_increase, color: Theme.of(context).iconTheme.color),
        title: Text('Nombre', style: TextStyle(color: Colors.white)),
        subtitle: Text(element.nombre!, style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(iconosFamilias[element.familia!] ?? Icons.error,
            color: Theme.of(context)
                .iconTheme
                .color), // Usa el icono correspondiente a la familia del elemento, si no existe, usa el icono de error
        title: Text(element.familia!, style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.circle, color: Theme.of(context).iconTheme.color),
        title: const Text('Valencias', style: TextStyle(color: Colors.white)),
        subtitle: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: element.valencias.map((valencia) {
                var valor = valencia['valor'];
                if (valor >= 0) {
                  return CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '+${valor.toString()}', // agrega un '+' delante del número
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return SizedBox
                      .shrink(); // no muestra nada para valores negativos
                }
              }).toList(),
            ),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              children: element.valencias.map((valencia) {
                var valor = valencia['valor'];
                if (valor < 0) {
                  return CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      valor.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return SizedBox
                      .shrink(); // no muestra nada para valores positivos
                }
              }).toList(),
            ),
          ],
        ),
      ),
      ListTile(
        leading:
            Icon(Icons.line_weight, color: Theme.of(context).iconTheme.color),
        title: Text('Peso Atómico', style: TextStyle(color: Colors.white)),
        subtitle: Text(element.pesoAtomico.toString(),
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Lottie.asset('assets/iconoAtomo.json'),
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: 280,
            height: 280,
            child: Image.asset('assets/${element.simbolo}.gif'),
          ),
        ),
        subtitle:
            Text('Orbital Electrónico', style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Lottie.asset('assets/iconoAtomo.json'),
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            width: 200,
            height: 200,
            child: Image.asset('assets/${element.geometriaMasComun}.gif'),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Geometría más común:', style: TextStyle(color: Colors.white)),
            Text(element.geometriaMasComun.toString(),
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      ListTile(
        leading:
            Icon(Icons.view_array, color: Theme.of(context).iconTheme.color),
        title: Text('Densidad', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.densidad} g/cm³',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading:
            Icon(Icons.thermostat, color: Theme.of(context).iconTheme.color),
        title: Text('Punto de Fusión', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.puntoFusion} K',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.thermostat_outlined,
            color: Theme.of(context).iconTheme.color),
        title:
            Text('Punto de Ebullición', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.puntoEbullicion} K',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.fire_extinguisher,
            color: Theme.of(context).iconTheme.color),
        title: Text('Calor Específico', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.calorEspecifico} J/(g·K)',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.electrical_services,
            color: Theme.of(context).iconTheme.color),
        title:
            Text('Electronegatividad', style: TextStyle(color: Colors.white)),
        subtitle: Text(element.electronegatividad.toString(),
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.radio, color: Theme.of(context).iconTheme.color),
        title: Text('Radio Atómico', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.radioAtomico} pm',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.radio_button_checked,
            color: Theme.of(context).iconTheme.color),
        title: Text('Radio Covalente', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.radioCovalente} pm',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.radio_button_unchecked,
            color: Theme.of(context).iconTheme.color),
        title: Text('Radio Iónico', style: TextStyle(color: Colors.white)),
        subtitle: Text('${element.radioIonico} pm',
            style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading:
            Icon(Icons.color_lens, color: Theme.of(context).iconTheme.color),
        title:
            Text('Espectro de Emisión', style: TextStyle(color: Colors.white)),
        subtitle: (element.id == 85 ||
                element.id == 100 ||
                element.id == 101 ||
                element.id == 102 ||
                element.id == 103 ||
                element.id == 104)
            ? Image.asset('assets/espectros/nodisponible.jpg')
            : Image.asset('assets/espectros/${element.id}.jpg'),
      ),
    ].expand((widget) => [widget, Divider()]).toList();

    return Scaffold(
      backgroundColor: Color.lerp(Colors.grey[850], element.color1, 0.07),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(175.0),
        child: AppBar(
          flexibleSpace: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/${element.id}.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Si la carga de la imagen .jpg falla, intenta cargar la imagen .jpeg
                  return Image.asset('assets/${element.id}.jpeg',
                      fit: BoxFit.cover);
                },
              ),
              Positioned(
                top:
                    160, // Ajusta este valor para mover el ElementTile hacia arriba o hacia abajo
                right:
                    20, // Ajusta este valor para mover el ElementTile hacia la izquierda o la derecha
                child: ElementTile(element, isLarge: true),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
          padding: const EdgeInsets.only(top: 24.0), children: listItems),
    );
  }
}

class ElementTile extends StatelessWidget implements PreferredSizeWidget {
  final kRowCount = 10;
  final kContentSize = 64.0;
  final kGutterWidth = 2.0;
  final kGutterInset = const EdgeInsets.all(2.0);
  ElementTile(this.element, {this.isLarge = false});
  final Elemento element;
  final bool isLarge;
  Size get preferredSize => Size.fromHeight(kContentSize * 1.5);
  @override
  Widget build(BuildContext context) {
    final tileText = <Widget>[
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text('${element.id}',
            style: TextStyle(fontSize: 5.0, color: Colors.white)),
      ),
      Text(element.simbolo,
          style: Theme.of(context)
              .primaryTextTheme
              .headline1
              ?.copyWith(color: Colors.white, fontSize: 10.0)),
    ];

    final tile = Container(
      width: 40,
      height: 40,
      margin: kGutterInset,
      color: Colors.white.withOpacity(0.8),
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          familias[element.familia]?[0] ?? Colors.white,
          familias[element.familia]?[1] ?? Colors.black,
        ]),
        backgroundBlendMode: BlendMode.multiply,
      ),
      child: RawMaterialButton(
        onPressed: element.id != 0
            ? () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => DetailPage(element)))
            : null,
        fillColor: Colors.transparent,
        disabledElevation: 10.0,
        padding: kGutterInset * 2.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tileText),
      ),
    );

    return Hero(
      tag: 'hero-${element.simbolo}',
      flightShuttleBuilder: (_, anim, __, ___, ____) => ScaleTransition(
          scale: anim.drive(Tween(begin: 1, end: 1.75)), child: tile),
      child: Transform.scale(scale: isLarge ? 1.75 : 1, child: tile),
    );
  }
}
