import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

class FormulacionCarrusel extends StatefulWidget {
  const FormulacionCarrusel({Key? key}) : super(key: key);

  @override
  _FormulacionCarruselState createState() => _FormulacionCarruselState();
}

class _FormulacionCarruselState extends State<FormulacionCarrusel> {
  //String? pdfPath;
  File? localfile;

  @override
  void initState() {
    super.initState();
    requestPermissionAndSelectPdf();
  }

  Future<void> requestPermissionAndSelectPdf() async {
    PermissionStatus status = await Permission.storage.status;

    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        openAppSettings();
        return;
      }
    }

    selectPdf();
  }

  Future<void> selectPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        localfile = File(result.files.single.path!);
      });
    } else {
      selectPdf();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
          title: 'Lector PDF', context: context),
      body: Consumer<ThemeNotifier>(
        builder: (context, value, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
            child: localfile != null
                ? Transform.scale(
                    scale: 1.15,
                    child: PDFView(
                      filePath: localfile!.path,
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
          );
        },
      ),
    );
  }
}
