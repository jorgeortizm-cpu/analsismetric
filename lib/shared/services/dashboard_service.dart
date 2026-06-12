import '../models/bce_indicator.dart';
import '../models/dashboard_summary.dart';
import '../models/metric_record.dart';
import 'api_service.dart';

class DashboardService {
  DashboardService({ApiService? api}) : _api = api ?? ApiService();
  final ApiService _api;

  Future<DashboardSummary> summary() async {
    final json = await _api.getJson('/api/dashboard/summary');
    return DashboardSummary.fromJson(json);
  }

  Future<List<BceIndicator>> bceIndicators({bool force = false}) async {
    final json = await _api.getJson('/api/bce/indicadores', query: {
      if (force) 'force': '1',
    });
    return ((json['items'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => BceIndicator.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<Map<String, dynamic>> monitorBceSeps({bool force = false}) async {
    return _api.getJson('/api/monitor/bce-seps', query: {
      if (force) 'force': '1',
    });
  }

  Future<List<MetricRecord>> metrics({String entityType = 'coop', int? segment, int limit = 50}) async {
    final json = await _api.getJson('/api/metrics', query: {
      'entity_type': entityType,
      'limit': '$limit',
      if (segment != null) 'segment': '$segment',
    });
    return ((json['data'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => MetricRecord.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
