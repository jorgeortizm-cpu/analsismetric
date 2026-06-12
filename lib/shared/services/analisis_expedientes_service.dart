import '../models/analysis_result.dart';
import 'api_service.dart';

class UploadMeta {
  const UploadMeta({required this.source, required this.filename, required this.sizeBytes});
  final String source;
  final String filename;
  final int sizeBytes;

  factory UploadMeta.fromJson(String source, Map<String, dynamic> json) => UploadMeta(
        source: source,
        filename: '${json['filename'] ?? ''}',
        sizeBytes: int.tryParse('${json['size_bytes'] ?? 0}') ?? 0,
      );
}

class AnalisisExpedientesService {
  AnalisisExpedientesService({ApiService? api}) : _api = api ?? ApiService();
  final ApiService _api;

  String get baseUrl => _api.baseUrl;

  Future<Map<String, dynamic>> health() => _api.getJson('/analisis_expedientes/health');

  Future<UploadMeta> uploadSource({
    required String sessionId,
    required String source,
    required String filePath,
  }) async {
    final json = await _api.postMultipart(
      path: '/analisis_expedientes/api/upload',
      fields: {'session_id': sessionId, 'source': source},
      fileField: 'file',
      filePath: filePath,
    );
    return UploadMeta.fromJson(source, (json['meta'] as Map?)?.cast<String, dynamic>() ?? const {});
  }

  /// Endpoint /process no necesita archivo; envía session_id como form-data simple,
  /// que es exactamente lo que el backend Flask lee con request.form/request.args.
  Future<Map<String, dynamic>> process({required String sessionId}) async {
    return _api.postForm('/analisis_expedientes/api/process', {'session_id': sessionId});
  }

  Future<List<Map<String, dynamic>>> suggest({required String sessionId, required String query}) async {
    final json = await _api.getJson('/analisis_expedientes/api/suggest', query: {
      'session_id': sessionId,
      'q': query,
    });
    return ((json['items'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  Future<Map<String, dynamic>> resolve({required String sessionId, required String query}) async {
    return _api.postJson('/analisis_expedientes/api/resolve', {
      'session_id': sessionId,
      'query': query,
    });
  }

  Future<AnalysisResult> analyze({
    required String sessionId,
    required String query,
    Map<String, dynamic> params = const {},
  }) async {
    final json = await _api.postJson('/analisis_expedientes/api/analyze', {
      'session_id': sessionId,
      'query': query,
      'params': params,
    });
    final analysis = (json['analysis'] as Map?)?.cast<String, dynamic>() ?? const {};
    return AnalysisResult(raw: analysis);
  }

  Uri exportUri({required String sessionId, required String query, required String type}) {
    final safeType = {'pdf', 'docx', 'ipynb'}.contains(type) ? type : 'pdf';
    final base = _api.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return Uri.parse('$base/analisis_expedientes/api/export/$safeType').replace(queryParameters: {
      'session_id': sessionId,
      'query': query,
    });
  }
}
