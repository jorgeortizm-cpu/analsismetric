class AnalysisResult {
  const AnalysisResult({required this.raw});

  final Map<String, dynamic> raw;

  Map<String, dynamic> get ficha =>
      (raw['ficha_ejecutiva'] as Map?)?.cast<String, dynamic>() ?? const {};

  Map<String, dynamic> get reporte =>
      (raw['reporte_ejecutivo'] as Map?)?.cast<String, dynamic>() ?? const {};

  Map<String, dynamic> get diagnostico =>
      (raw['diagnostico'] as Map?)?.cast<String, dynamic>() ?? const {};

  List<Map<String, dynamic>> get gaps =>
      ((diagnostico['gaps'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();

  List<Map<String, dynamic>> get bscPerspectivas {
    final bsc = (raw['bsc'] as Map?)?.cast<String, dynamic>() ?? const {};
    return ((bsc['perspectivas'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  String get empresa => '${reporte['empresa'] ?? ficha['empresa'] ?? 'Empresa'}';
  String get ruc => '${reporte['ruc'] ?? ficha['ruc'] ?? '—'}';
  String get expediente => '${reporte['expediente'] ?? ficha['expediente'] ?? '—'}';
  String get sector => '${reporte['sector'] ?? ficha['sector'] ?? '—'}';
  String get score => '${ficha['score'] ?? '—'}';
  String get semaforo => '${ficha['semaforo_label'] ?? '—'}';
}
