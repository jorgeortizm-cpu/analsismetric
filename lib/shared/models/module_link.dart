import '../../core/constants/app_constants.dart';

class ModuleLink {
  const ModuleLink({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.iconName,
  });

  final String key;
  final String title;
  final String subtitle;
  final String path;
  final String iconName;

  String get url => '${AppConstants.baseUrl}$path';

  static ModuleLink defaultModule() => modules.firstWhere((m) => m.key == 'empresas');

  static const modules = [
    ModuleLink(
      key: 'bancos',
      title: 'Bancos',
      subtitle: 'Indicadores, métricas y consulta sectorial bancaria.',
      path: '/modulos/bancos',
      iconName: 'account_balance',
    ),
    ModuleLink(
      key: 'coop1',
      title: 'Cooperativas Segmento 1',
      subtitle: 'Indicadores principales para cooperativas grandes.',
      path: '/modulos/coops-seg1',
      iconName: 'groups',
    ),
    ModuleLink(
      key: 'coop23',
      title: 'Cooperativas Segmentos 2–3',
      subtitle: 'Métricas, señales y análisis comparativo.',
      path: '/modulos/coops-seg23',
      iconName: 'hub',
    ),
    ModuleLink(
      key: 'coop23v',
      title: 'Volatilidad Segmentos 2–3',
      subtitle: 'Lectura de sensibilidad, estabilidad y comportamiento.',
      path: '/modulos/coops-seg23-volatilidad',
      iconName: 'show_chart',
    ),
    ModuleLink(
      key: 'empresas',
      title: 'Empresas / BSC Radar',
      subtitle: 'CIIU, marketing, gastos, contactos, radar BSC y reporte integral.',
      path: '/modulos/empresas',
      iconName: 'business_center',
    ),
    ModuleLink(
      key: 'score',
      title: 'Análisis de Score',
      subtitle: 'Evaluación de score financiero y registro de consultas.',
      path: '/modulos/score',
      iconName: 'analytics',
    ),
  ];
}
