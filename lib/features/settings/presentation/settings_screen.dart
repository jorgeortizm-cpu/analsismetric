import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const apkCommand = 'flutter build apk --release --dart-define=API_BASE_URL=https://analisismetric.com';
    const iosCommand = 'flutter build ipa --release --dart-define=API_BASE_URL=https://analisismetric.com';

    return Scaffold(
      appBar: const AppHeader(showBack: true, title: 'Configuración'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SectionTitle(title: 'Parámetros de compilación'),
          const Card(
            child: ListTile(
              leading: Icon(Icons.cloud_done),
              title: Text('API_BASE_URL'),
              subtitle: Text(AppConstants.baseUrl),
            ),
          ),
          SectionTitle(title: 'Comandos'),
          const _CommandCard(title: 'Android APK', command: apkCommand),
          const _CommandCard(title: 'iOS IPA', command: iosCommand),
          SectionTitle(title: 'Notas técnicas'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'La app usa la estructura core/features/shared del proyecto móvil base y se conecta al backend Flask de Analisismetric. Los módulos HTML se conservan por WebView para no romper la lógica existente. El Data Analyst móvil consume /analisis_expedientes/api/upload, /process, /analyze y /export.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({required this.title, required this.command});
  final String title;
  final String command;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            SelectableText(command),
          ],
        ),
      ),
    );
  }
}
