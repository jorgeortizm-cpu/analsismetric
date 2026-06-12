import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? AppConstants.baseUrl).replaceAll(RegExp(r'/+$'), '');

  final http.Client _client;
  final String _baseUrl;

  String get baseUrl => _baseUrl;

  Uri uri(String path, [Map<String, String>? query]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final base = Uri.parse('$_baseUrl$cleanPath');
    return query == null ? base : base.replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> getJson(String path, {Map<String, String>? query}) async {
    final response = await _client.get(uri(path, query), headers: _jsonHeaders);
    return _decodeMap(response);
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      uri(path),
      headers: _jsonHeaders,
      body: jsonEncode(body),
    );
    return _decodeMap(response);
  }


  Future<Map<String, dynamic>> postForm(String path, Map<String, String> fields) async {
    final response = await _client.post(
      uri(path),
      headers: const {'Accept': 'application/json'},
      body: fields,
    );
    return _decodeMap(response);
  }

  Future<Map<String, dynamic>> postMultipart({
    required String path,
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
  }) async {
    final req = http.MultipartRequest('POST', uri(path));
    req.fields.addAll(fields);
    req.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    final streamed = await _client.send(req);
    final response = await http.Response.fromStream(streamed);
    return _decodeMap(response);
  }

  Map<String, String> get _jsonHeaders => const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Map<String, dynamic> _decodeMap(http.Response response) {
    final body = response.body.trim();
    dynamic decoded;
    if (body.isEmpty) {
      decoded = <String, dynamic>{};
    } else {
      try {
        decoded = jsonDecode(body);
      } catch (_) {
        throw ApiException(
          'Respuesta no JSON (${response.statusCode}): ${body.length > 180 ? '${body.substring(0, 180)}…' : body}',
          statusCode: response.statusCode,
        );
      }
    }

    final map = decoded is Map ? decoded.cast<String, dynamic>() : <String, dynamic>{'data': decoded};
    final ok = response.statusCode >= 200 && response.statusCode < 300;
    if (!ok || map['ok'] == false) {
      throw ApiException(
        '${map['error'] ?? map['message'] ?? 'Error HTTP ${response.statusCode}'}',
        statusCode: response.statusCode,
      );
    }
    return map;
  }
}
