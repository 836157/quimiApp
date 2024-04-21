import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(const MaterialApp(
    home: FormulacionCarrusel(),
  ));
}

class FormulacionCarrusel extends StatefulWidget {
  const FormulacionCarrusel({Key? key}) : super(key: key);

  @override
  _FormulacionCarruselState createState() => _FormulacionCarruselState();
}

class _FormulacionCarruselState extends State<FormulacionCarrusel> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final documentDirectory = (await getApplicationDocumentsDirectory()).path;
    final file = File("$documentDirectory/formulacion.pdf");
    final rawData = await rootBundle.load('assets/formulacion.pdf');
    final bytes = rawData.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Formulación inorgánica',
          style: TextStyle(fontSize: 16),
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
        child: pdfPath != null
            ? Transform.scale(
                scale: 1.15,
                child: PDFView(
                  filePath: pdfPath!,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  swipeHorizontal: true,
                  nightMode: false,
                  onError: (error) {
                    print(error.toString());
                  },
                  onRender: (_pages) {
                    setState(() {});
                  },
                  onViewCreated: (PDFViewController pdfViewController) {},
                  onPageChanged: (int? page, int? total) {},
                  onPageError: (page, error) {},
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
