class Reaccion {
  final int id;
  final String reaccion;
  final int? A;
  final int? B;
  final int? C;
  final int? D;
  final int? E;

  Reaccion({
    required this.id,
    required this.reaccion,
    this.A,
    this.B,
    this.C,
    this.D,
    this.E,
  });

  int get getid => id;
  String get getReaccion => reaccion;
  int? get getA => A;
  int? get getB => B;
  int? get getC => C;
  int? get getD => D;
  int? get getE => E;

  factory Reaccion.fromJson(Map<String, dynamic> json) {
    return Reaccion(
      id: json['id'],
      reaccion: json['reaccion'],
      A: json['a'],
      B: json['b'],
      C: json['c'],
      D: json['d'],
      E: json['e'],
    );
  }

  @override
  String toString() {
    return '$reaccion(A: $A, B: $B, C: $C, D: $D, E: $E)';
  }
}
