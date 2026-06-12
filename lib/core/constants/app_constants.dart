class AppConstants {
  static const String brandName = 'AnalisisMetric';
  static const String brandDomain = 'analisismetric.com';
  static const String brandShort = 'AM';

  /// Cambiar en compilación:
  /// flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com
  /// flutter build ios --release --dart-define=API_BASE_URL=https://analisismetric.com
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://analisismetric.com',
  );

  static const String defaultModulePath = '/modulos/empresas';
}
