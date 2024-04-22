class Elemento {
  final int id;
  final String nombre;
  final int numeroAtomico;
  final String simbolo;
  final double pesoAtomico;
  final String geometriaMasComun;
  final double? densidad;
  final double? puntoFusion;
  final double? puntoEbullicion;
  final double? calorEspecifico;
  final double? electronegatividad;
  final double? radioAtomico;
  final double? radioCovalente;
  final double? radioIonico;
  final String? familia;

  String get getNombre => nombre;
  int get getNumeroAtomico => numeroAtomico;
  String get getSimbolo => simbolo;
  double get getPesoAtomico => pesoAtomico;
  String get getGeometriaMasComun => geometriaMasComun;
  double? get getDensidad => densidad;
  double? get getPuntoFusion => puntoFusion;
  double? get getPuntoEbullicion => puntoEbullicion;
  double? get getCalorEspecifico => calorEspecifico;
  double? get getElectronegatividad => electronegatividad;
  double? get getRadioAtomico => radioAtomico;
  double? get getRadioCovalente => radioCovalente;
  double? get getRadioIonico => radioIonico;
  String? get getFamilia => familia;

  Elemento({
    required this.id,
    required this.nombre,
    required this.numeroAtomico,
    required this.simbolo,
    required this.pesoAtomico,
    required this.geometriaMasComun,
    this.densidad,
    this.puntoFusion,
    this.puntoEbullicion,
    this.calorEspecifico,
    this.electronegatividad,
    this.radioAtomico,
    this.radioCovalente,
    this.radioIonico,
    this.familia,
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
    );
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
