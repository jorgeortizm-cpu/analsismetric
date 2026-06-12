import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/bce_indicator.dart';
import '../../../shared/models/dashboard_summary.dart';
import '../../../shared/services/dashboard_service.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_panel.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService _service = DashboardService();
  late Future<_HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_HomeData> _load() async {
    final summary = await _service.summary().catchError((_) => DashboardSummary.empty);
    final indicators = await _service.bceIndicators().catchError((_) => <BceIndicator>[]);
    final monitor = await _service.monitorBceSeps().catchError((_) => <String, dynamic>{});
    return _HomeData(summary: summary, indicators: indicators, monitor: monitor);
  }

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<_HomeData>(
          future: _future,
          builder: (context, snapshot) {
            final data = snapshot.data;
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                if (snapshot.hasError)
                  ErrorPanel(message: '${snapshot.error}', onRetry: _refresh)
                else
                  _HeroPanel(data: data),
                const SizedBox(height: 10),
                if (snapshot.connectionState == ConnectionState.waiting && data == null)
                  const LinearProgressIndicator(),
                if (data != null) ...[
                  _KpiGrid(summary: data.summary),
                  _BceStrip(indicators: data.indicators),
                  _MonitorPanel(monitor: data.monitor),
                ],
                SectionTitle(
                  title: 'Ruta móvil recomendada',
                  subtitle: 'La app conserva la metodología web: carga, procesamiento, análisis, reporte y exportación.',
                ),
                _MethodologyPanel(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.data});
  final _HomeData? data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1220), Color(0xFF0F1A2F), Color(0xFF003A86)],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Responsive(
          mobile: _HeroContent(compact: true, data: data),
          desktop: Row(
            children: [
              Expanded(child: _HeroContent(data: data)),
              const SizedBox(width: 20),
              const _AiVisual(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({this.compact = false, required this.data});
  final bool compact;
  final _HomeData? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white24),
          ),
          child: const Text('Data Analyst + Inteligencia Financiera', style: TextStyle(color: Colors.white70)),
        ),
        const SizedBox(height: 16),
        const Text(
          'AnalisisMetric móvil para decisiones financieras con evidencia.',
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.08),
        ),
        const SizedBox(height: 12),
        const Text(
          'Conecta la app Android/iOS con el motor Flask existente: módulos bancarios, cooperativas, empresas, score, análisis de expedientes y exportables PDF/DOCX/IPYNB.',
          style: TextStyle(color: Colors.white70, height: 1.45),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            PrimaryButton(
              text: 'Abrir Data Analyst',
              icon: Icons.analytics,
              onPressed: () => Navigator.pushNamed(context, AppRouter.dataAnalyst),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)),
              onPressed: () => Navigator.pushNamed(context, AppRouter.modules),
              icon: const Icon(Icons.dashboard_customize),
              label: const Text('Módulos web'),
            ),
          ],
        ),
        if (compact) ...[
          const SizedBox(height: 18),
          const _AiVisual(),
        ],
      ],
    );
  }
}

class _AiVisual extends StatelessWidget {
  const _AiVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      constraints: const BoxConstraints(maxWidth: 360),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Motor analítico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('CIIU · BSC · Riesgo · GAP · Caja · Score', style: TextStyle(color: Colors.white70)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(8, (i) {
              final h = 34.0 + (i * 13 % 68);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: AppColors.ibmBlue.withOpacity(.75),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.summary});
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = <Widget>[
      MetricCard(title: 'Bancos', value: Formatters.compactInt(summary.banks), icon: Icons.account_balance),
      MetricCard(title: 'Coop. Segmento 1', value: Formatters.compactInt(summary.coop1), icon: Icons.groups),
      MetricCard(title: 'Coop. Segmentos 2–3', value: Formatters.compactInt(summary.coop2 + summary.coop3), icon: Icons.hub),
      MetricCard(title: 'Consultas Score', value: Formatters.compactInt(summary.scoreQueries), icon: Icons.analytics),
    ];
    return GridView.count(
      crossAxisCount: MediaQuery.sizeOf(context).width < 720 ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: MediaQuery.sizeOf(context).width < 420 ? 1.05 : 1.35,
      children: cards,
    );
  }
}

class _BceStrip extends StatelessWidget {
  const _BceStrip({required this.indicators});
  final List<BceIndicator> indicators;

  @override
  Widget build(BuildContext context) {
    if (indicators.isEmpty) return const SizedBox.shrink();
    final top = indicators.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Indicadores BCE', subtitle: 'Resumen consumido desde /api/bce/indicadores.'),
        SizedBox(
          height: 126,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: top.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => SizedBox(
              width: 230,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(top[i].label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(top[i].value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ibmBlue)),
                      const Spacer(),
                      Text(top[i].period, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonitorPanel extends StatelessWidget {
  const _MonitorPanel({required this.monitor});
  final Map<String, dynamic> monitor;

  @override
  Widget build(BuildContext context) {
    final warning = '${monitor['warning'] ?? ''}'.trim();
    final bce = (monitor['bce'] as Map?)?.cast<String, dynamic>() ?? const {};
    final seps = (monitor['seps'] as Map?)?.cast<String, dynamic>() ?? const {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Monitor BCE + SEPS'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _MonitorRow(label: 'BCE', value: '${bce['count'] ?? 0} publicaciones / señales'),
                const Divider(),
                _MonitorRow(label: 'SEPS', value: '${seps['count'] ?? 0} referencias / señales'),
                if (warning.isNotEmpty) ...[
                  const Divider(),
                  Align(alignment: Alignment.centerLeft, child: Text(warning, style: Theme.of(context).textTheme.bodySmall)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MonitorRow extends StatelessWidget {
  const _MonitorRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))),
        Text(value),
      ],
    );
  }
}

class _MethodologyPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = const [
      ('1', 'Preparar fuentes', 'Catálogo, ranking, BI, MV y logo.'),
      ('2', 'Procesar', 'Normalización, detección de columnas e índice.'),
      ('3', 'Analizar', 'Ficha ejecutiva, score, GAP, BSC y caja.'),
      ('4', 'Exportar', 'PDF, DOCX e IPYNB desde el backend.'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: steps
              .map(
                (e) => ListTile(
                  leading: CircleAvatar(child: Text(e.$1)),
                  title: Text(e.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(e.$3),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _HomeData {
  const _HomeData({required this.summary, required this.indicators, required this.monitor});
  final DashboardSummary summary;
  final List<BceIndicator> indicators;
  final Map<String, dynamic> monitor;
}
