class Elemento {
  final int id;
  final String nombre;
  final int numeroAtomico;
  final String simbolo;
  final int pesoAtomico;
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
      densidad: json['densidad']?.toDouble(),
      puntoFusion: json['puntoFusion']?.toDouble(),
      puntoEbullicion: json['puntoEbullicion']?.toDouble(),
      calorEspecifico: json['calorEspecifico']?.toDouble(),
      electronegatividad: json['electronegatividad']?.toDouble(),
      radioAtomico: json['radioAtomico']?.toDouble(),
      radioCovalente: json['radioCovalente']?.toDouble(),
      radioIonico: json['radioIonico']?.toDouble(),
      familia: json['familia'],
    );
  }
}
