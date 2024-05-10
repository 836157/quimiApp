import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

class Elemento {
  final int id;
  final String? nombre;
  final int? numeroAtomico;
  final String simbolo;
  final double? pesoAtomico;
  final String? geometriaMasComun;
  final double? densidad;
  final double? puntoFusion;
  final double? puntoEbullicion;
  final double? calorEspecifico;
  final double? electronegatividad;
  final double? radioAtomico;
  final double? radioCovalente;
  final double? radioIonico;
  final String? familia;
  final Color? color1;
  final Color? color2;
  final String? source;
  final int? posicionX;
  final int? posicionY;
  List<Map<String?, dynamic>> valencias;

  String? get getNombre => nombre;
  int? get getNumeroAtomico => numeroAtomico;
  String get getSimbolo => simbolo;
  double? get getPesoAtomico => pesoAtomico;
  String? get getGeometriaMasComun => geometriaMasComun;
  double? get getDensidad => densidad;
  double? get getPuntoFusion => puntoFusion;
  double? get getPuntoEbullicion => puntoEbullicion;
  double? get getCalorEspecifico => calorEspecifico;
  double? get getElectronegatividad => electronegatividad;
  double? get getRadioAtomico => radioAtomico;
  double? get getRadioCovalente => radioCovalente;
  double? get getRadioIonico => radioIonico;
  String? get getFamilia => familia;
  Color? get getColor1 => color1;
  Color? get getColor2 => color2;
  String? get getSource => source;
  int? get getPosicionX => posicionX;
  int? get getPosicionY => posicionY;

  Elemento({
    required this.id,
    this.nombre,
    this.numeroAtomico,
    required this.simbolo,
    this.pesoAtomico,
    this.geometriaMasComun,
    this.densidad,
    this.puntoFusion,
    this.puntoEbullicion,
    this.calorEspecifico,
    this.electronegatividad,
    this.radioAtomico,
    this.radioCovalente,
    this.radioIonico,
    this.familia,
    this.color1,
    this.color2,
    this.source,
    required this.posicionX,
    required this.posicionY,
    required this.valencias,
  });

  factory Elemento.fromJson(Map<String, dynamic> json) {
    return Elemento(
      id: json['id'],
      nombre: json['nombre'],
      numeroAtomico: json['numeroAtomico'],
      simbolo: json['simbolo'],
      pesoAtomico: json['pesoAtomico'],
      geometriaMasComun: json['geometriaMasComun'],
      densidad: json['densidad'],
      puntoFusion: json['puntoFusion'],
      puntoEbullicion: json['puntoEbullicion'],
      calorEspecifico: json['calorEspecifico'],
      electronegatividad: json['electronegatividad'],
      radioAtomico: json['radioAtomico'],
      radioCovalente: json['radioCovalente'],
      radioIonico: json['radioIonico'],
      familia: json['familia'],
      color1: _colorFromHex(json['color1']),
      color2: _colorFromHex(json['color2']),
      source: json['source'],
      posicionX: json['posicionX'],
      posicionY: json['posicionY'],
      valencias: (json['valencias'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Map<String, dynamic> toMap() {
    return {
      'Nombre': nombre,
      'A': numeroAtomico,
      'Sim': simbolo,
      'Uma': pesoAtomico,
      'Geometria': geometriaMasComun,
      'd': densidad,
      'p.f.°': puntoFusion,
      'p.e.': puntoEbullicion,
      'Q': calorEspecifico,
      'electronegatividad': electronegatividad,
      'Ra': radioAtomico,
      'Rc': radioCovalente,
      'Ri': radioIonico,
    };
  }
}
