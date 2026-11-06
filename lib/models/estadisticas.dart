class Estadisticas {
  final int registrados;
  final int ingresaron;
  final int pendientes;

  const Estadisticas({
    required this.registrados,
    required this.ingresaron,
    required this.pendientes,
  });

  factory Estadisticas.fromJson(Map<String, dynamic> json) {
    return Estadisticas(
      registrados: (json['registrados'] as num).toInt(),
      ingresaron: (json['ingresaron'] as num).toInt(),
      pendientes: (json['pendientes'] as num).toInt(),
    );
  }
}