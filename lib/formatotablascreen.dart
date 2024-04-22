import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quimicapp/elemento.dart';

const kRowCount = 10;
const kContentSize = 64.0;
const kGutterWidth = 1.0;
const kGutterInset = EdgeInsets.all(kGutterWidth);

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

class TablePage extends StatefulWidget {
  final Future<List<Elemento>> gridList = fetchElement();
  TablePage(gridList);
  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  Future<List<Elemento>>? elementos;
  @override
  void initState() {
    super.initState();
    elementos = fetchElement();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
          title: Text('Tabla Periodica'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[800]),
      body: FutureBuilder(
        future: widget.gridList,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _buildTable(snapshot.data as List<Elemento>);
            } else {
              return Center(child: Text('No hay datos disponibles'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTable(List<Elemento> elementos) {
    final tiles = elementos
        .map((elemento) => elemento != null
            ? ElementTile(elemento)
            : Container(color: Colors.black38, margin: kGutterInset))
        .toList();

    return SingleChildScrollView(
      child: SizedBox(
        height: kRowCount * (kContentSize + (kGutterWidth * 8)),
        child: GridView.count(
          crossAxisCount: kRowCount,
          scrollDirection: Axis.horizontal,
          children: tiles,
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  DetailPage(this.elemento);
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

  final Elemento elemento;

  @override
  Widget build(BuildContext context) {
    final listItems = <Widget>[
      ListTile(
        leading: Icon(Icons.category),
        title: Text(elemento.getNombre ?? 'Desconocido'),
      ),
      ListTile(
        leading: Icon(Icons.info),
        title: Text(elemento.nombre),
        subtitle: Text(elemento.simbolo),
      ),
      ListTile(
        leading: Icon(Icons.fiber_smart_record),
        title: Text(elemento.pesoAtomico.toString()),
        subtitle: Text('Atomic Weight'),
      ),
    ].expand((widget) => [widget, Divider()]).toList();

    return Scaffold(
      backgroundColor: familias[elemento.familia],
      appBar: AppBar(
        backgroundColor: familias[elemento.familia],
        bottom: ElementTile(elemento, isLarge: true),
      ),
      body: ListView(padding: EdgeInsets.only(top: 24.0), children: listItems),
    );
  }
}

class ElementTile extends StatelessWidget implements PreferredSizeWidget {
  const ElementTile(this.elementdata, {this.isLarge = false});

  final Elemento elementdata;
  final bool isLarge;

  Size get preferredSize => Size.fromHeight(kContentSize * 2);

  @override
  Widget build(BuildContext context) {
    final tileText = <Widget>[
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text('${elementdata.id}', style: TextStyle(fontSize: 8.0)),
      ),
      Text(elementdata.simbolo,
          style: Theme.of(context).primaryTextTheme.headline1),
      Text(
        elementdata.nombre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: isLarge ? 0.65 : 1,
      ),
    ];

    final tile = Container(
      margin: kGutterInset,
      width: kContentSize,
      height: kContentSize,
      /*foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(colors: elementdata.colors),
        backgroundBlendMode: BlendMode.multiply,),*/
      child: RawMaterialButton(
        onPressed: !isLarge
            ? () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => DetailPage(elementdata)))
            : null,
        fillColor: Colors.grey[800],
        disabledElevation: 10.0,
        padding: kGutterInset * 2.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tileText),
      ),
    );

    return Hero(
      tag: 'hero-${elementdata.simbolo}',
      flightShuttleBuilder: (_, anim, __, ___, ____) => ScaleTransition(
          scale: anim.drive(Tween(begin: 1, end: 1.75)), child: tile),
      child: Transform.scale(scale: isLarge ? 1.75 : 1, child: tile),
    );
  }
}
