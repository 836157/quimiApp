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
      '': nombre,
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
      'Rio': radioIonico,
    };
  }
}
