import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/models/analysis_result.dart';
import '../../../shared/services/analisis_expedientes_service.dart';
import '../../../shared/store/app_state.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_panel.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/widgets/status_chip.dart';

class DataAnalystScreen extends StatefulWidget {
  const DataAnalystScreen({super.key});

  @override
  State<DataAnalystScreen> createState() => _DataAnalystScreenState();
}

class _DataAnalystScreenState extends State<DataAnalystScreen> {
  final AnalisisExpedientesService _service = AnalisisExpedientesService();
  final TextEditingController _query = TextEditingController();
  final TextEditingController _session = TextEditingController();
  final Map<String, UploadMeta> _uploads = {};
  final Map<String, String> _sourceErrors = {};

  AnalysisResult? _analysis;
  Map<String, dynamic>? _processResult;
  bool _busy = false;
  String? _error;

  static const _sources = [
    _SourceDef('catalogo', 'Catálogo', 'Base de expedientes, RUC, razón social y CIIU.'),
    _SourceDef('ranking', 'Ranking', 'Archivo de ranking empresarial o cooperativo.'),
    _SourceDef('bi', 'BI Ranking', 'Fuente BI / balance / cuentas para ratios.'),
    _SourceDef('mv', 'MV', 'ZIP o fuente auxiliar para variables/motores.'),
    _SourceDef('logo', 'Logo', 'Logo institucional opcional para reportes.'),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().millisecondsSinceEpoch;
    _session.text = 'am-mobile-$now';
  }

  @override
  void dispose() {
    _query.dispose();
    _session.dispose();
    super.dispose();
  }

  Future<void> _upload(_SourceDef source) async {
    setState(() {
      _busy = true;
      _error = null;
      _sourceErrors.remove(source.key);
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: source.key == 'logo'
            ? const ['png', 'jpg', 'jpeg', 'svg']
            : const ['csv', 'xlsx', 'xls', 'txt', 'zip'],
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.single.path;
      if (path == null || path.trim().isEmpty) {
        throw Exception('No se obtuvo una ruta válida del archivo seleccionado.');
      }
      final meta = await _service.uploadSource(
        sessionId: _session.text.trim(),
        source: source.key,
        filePath: path,
      );
      if (!mounted) return;
      setState(() => _uploads[source.key] = meta);
      AppStateProvider.of(context).setAnalystContext(sessionId: _session.text.trim());
    } catch (e) {
      if (!mounted) return;
      setState(() => _sourceErrors[source.key] = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _process() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await _service.process(sessionId: _session.text.trim());
      if (!mounted) return;
      setState(() => _processResult = (result['result'] as Map?)?.cast<String, dynamic>() ?? result);
      AppStateProvider.of(context).setAnalystContext(sessionId: _session.text.trim());
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo procesar fuentes: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _analyze() async {
    final q = _query.text.trim();
    if (q.isEmpty) {
      setState(() => _error = 'Escribe expediente, RUC o nombre de empresa para analizar.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _analysis = null;
    });
    try {
      final result = await _service.analyze(sessionId: _session.text.trim(), query: q);
      if (!mounted) return;
      setState(() => _analysis = result);
      AppStateProvider.of(context).setAnalystContext(sessionId: _session.text.trim(), query: q);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo ejecutar análisis: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export(String type) async {
    final q = _query.text.trim();
    if (q.isEmpty) {
      setState(() => _error = 'Primero escribe una consulta para exportar.');
      return;
    }
    final uri = _service.exportUri(sessionId: _session.text.trim(), query: q, type: type);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) setState(() => _error = 'No se pudo abrir el exportable: $uri');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: const AppHeader(showBack: true, title: 'Data Analyst'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SectionTitle(
            title: 'Motor móvil de análisis de expedientes',
            subtitle: 'Carga las fuentes del procedimiento, procesa el índice y genera el reporte ejecutivo desde el backend de AnalisisMetric.',
          ),
          _SessionCard(controller: _session, baseUrl: _service.baseUrl),
          if (_busy) const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: LinearProgressIndicator()),
          if (_error != null) ErrorPanel(message: _error!),
          SectionTitle(title: '1. Fuentes requeridas'),
          GridView.count(
            crossAxisCount: width < 720 ? 1 : 2,
            childAspectRatio: width < 420 ? 2.4 : 3.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _sources
                .map(
                  (s) => _UploadTile(
                    source: s,
                    meta: _uploads[s.key],
                    error: _sourceErrors[s.key],
                    enabled: !_busy,
                    onUpload: () => _upload(s),
                  ),
                )
                .toList(),
          ),
          SectionTitle(title: '2. Procesamiento'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      StatusChip(label: '${_uploads.length}/5 fuentes cargadas', ok: _uploads.isNotEmpty),
                      if (_processResult != null) const StatusChip(label: 'Procesado', ok: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: 'Procesar fuentes',
                    icon: Icons.memory,
                    onPressed: _busy ? null : _process,
                    expanded: width < 520,
                  ),
                  if (_processResult != null) ...[
                    const Divider(height: 28),
                    _ProcessSummary(result: _processResult!),
                  ],
                ],
              ),
            ),
          ),
          SectionTitle(title: '3. Consulta y análisis'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _query,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _analyze(),
                    decoration: const InputDecoration(
                      labelText: 'Expediente, RUC o nombre de empresa',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    text: 'Ejecutar análisis',
                    icon: Icons.analytics,
                    expanded: true,
                    onPressed: _busy ? null : _analyze,
                  ),
                  if (_analysis != null) ...[
                    const Divider(height: 30),
                    _AnalysisPanel(result: _analysis!, onExport: _export),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.controller, required this.baseUrl});
  final TextEditingController controller;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backend: $baseUrl', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Session ID',
                helperText: 'Mantiene agrupadas las cargas y consultas del análisis.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.source,
    required this.meta,
    required this.error,
    required this.enabled,
    required this.onUpload,
  });

  final _SourceDef source;
  final UploadMeta? meta;
  final String? error;
  final bool enabled;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(meta == null ? Icons.upload_file : Icons.check_circle_outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(source.label, style: const TextStyle(fontWeight: FontWeight.w900)),
                  Text(meta?.filename ?? source.help, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (error != null) Text(error!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
            TextButton(onPressed: enabled ? onUpload : null, child: Text(meta == null ? 'Subir' : 'Cambiar')),
          ],
        ),
      ),
    );
  }
}

class _ProcessSummary extends StatelessWidget {
  const _ProcessSummary({required this.result});
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final sources = (result['sources'] as Map?)?.cast<String, dynamic>() ?? const {};
    final stats = (result['stats'] as Map?)?.cast<String, dynamic>() ?? const {};
    final errors = (result['errors'] as List?) ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fuentes detectadas: ${sources.keys.join(', ')}'),
        if (stats.isNotEmpty) Text('Estadísticas: ${stats.length} bloques'),
        if (errors.isNotEmpty) Text('Alertas: ${errors.join(' | ')}'),
      ],
    );
  }
}

class _AnalysisPanel extends StatelessWidget {
  const _AnalysisPanel({required this.result, required this.onExport});
  final AnalysisResult result;
  final Future<void> Function(String type) onExport;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(result.empresa, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            ),
            StatusChip(label: result.semaforo, ok: result.semaforo.toLowerCase().contains('verde')),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            StatusChip(label: 'Score ${result.score}/100', ok: true),
            StatusChip(label: 'RUC ${result.ruc}'),
            StatusChip(label: 'Exp. ${result.expediente}'),
          ],
        ),
        const SizedBox(height: 14),
        Text('Sector: ${result.sector}'),
        if (result.gaps.isNotEmpty) ...[
          const Divider(height: 28),
          const Text('Brechas principales', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...result.gaps.take(5).map((g) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.troubleshoot),
                title: Text('${g['metric'] ?? g['name'] ?? 'Métrica'}'),
                subtitle: Text('Actual: ${g['actual'] ?? '—'} · Ref: ${g['ref'] ?? '—'} · Estado: ${g['status'] ?? '—'}'),
              )),
        ],
        if (result.bscPerspectivas.isNotEmpty) ...[
          const Divider(height: 28),
          const Text('Balanced Scorecard', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...result.bscPerspectivas.take(4).map((p) {
            final raw = double.tryParse('${p['valor'] ?? 0}') ?? 0;
            final value = raw.clamp(0, 100).toDouble();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${p['perspectiva'] ?? 'Perspectiva'}: ${value.toStringAsFixed(1)}'),
                  LinearProgressIndicator(value: value / 100),
                ],
              ),
            );
          }),
        ],
        const Divider(height: 28),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(onPressed: () => onExport('pdf'), icon: const Icon(Icons.picture_as_pdf), label: const Text('PDF')),
            OutlinedButton.icon(onPressed: () => onExport('docx'), icon: const Icon(Icons.description), label: const Text('DOCX')),
            OutlinedButton.icon(onPressed: () => onExport('ipynb'), icon: const Icon(Icons.code), label: const Text('IPYNB')),
          ],
        ),
      ],
    );
  }
}

class _SourceDef {
  const _SourceDef(this.key, this.label, this.help);
  final String key;
  final String label;
  final String help;
}
