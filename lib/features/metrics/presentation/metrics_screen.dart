import 'package:flutter/material.dart';
import '../../../shared/models/metric_record.dart';
import '../../../shared/services/dashboard_service.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_panel.dart';
import '../../../shared/widgets/section_title.dart';

class MetricsScreen extends StatefulWidget {
  const MetricsScreen({super.key});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  final DashboardService _service = DashboardService();
  String _entityType = 'coop';
  int? _segment = 1;
  late Future<List<MetricRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<MetricRecord>> _load() => _service.metrics(entityType: _entityType, segment: _entityType == 'coop' ? _segment : null, limit: 100);

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(showBack: true, title: 'Métricas'),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            SectionTitle(
              title: 'Consulta de métricas sectoriales',
              subtitle: 'Lectura móvil del endpoint /api/metrics para bancos y cooperativas.',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'coop', label: Text('Coop.')),
                        ButtonSegment(value: 'bank', label: Text('Bancos')),
                      ],
                      selected: {_entityType},
                      onSelectionChanged: (v) {
                        _entityType = v.first;
                        _refresh();
                      },
                    ),
                    if (_entityType == 'coop')
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('Seg. 1')),
                          ButtonSegment(value: 2, label: Text('Seg. 2')),
                          ButtonSegment(value: 3, label: Text('Seg. 3')),
                        ],
                        selected: {_segment ?? 1},
                        onSelectionChanged: (v) {
                          _segment = v.first;
                          _refresh();
                        },
                      ),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<MetricRecord>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) return ErrorPanel(message: '${snapshot.error}', onRetry: _refresh);
                final rows = snapshot.data ?? const [];
                if (rows.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No hay métricas disponibles para el filtro seleccionado.'),
                    ),
                  );
                }
                return Column(children: rows.map((r) => _MetricRecordTile(record: r)).toList());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRecordTile extends StatelessWidget {
  const _MetricRecordTile({required this.record});
  final MetricRecord record;

  @override
  Widget build(BuildContext context) {
    final payloadPreview = record.payload.entries.take(4).map((e) => '${e.key}: ${e.value}').join(' · ');
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(record.entityType == 'bank' ? 'B' : '${record.segment ?? 'C'}')),
        title: Text(record.entityName, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('${record.period}\n$payloadPreview'),
        isThreeLine: true,
      ),
    );
  }
}
