import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../shared/models/module_link.dart';
import '../../../shared/widgets/app_header.dart';

class WebModuleScreen extends StatefulWidget {
  const WebModuleScreen({super.key, required this.link});
  final ModuleLink link;

  @override
  State<WebModuleScreen> createState() => _WebModuleScreenState();
}

class _WebModuleScreenState extends State<WebModuleScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _loading = true;
            _error = null;
          }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (error) => setState(() {
            _loading = false;
            _error = error.description;
          }),
        ),
      )
      ..loadRequest(Uri.parse(widget.link.url));
  }

  Future<void> _openExternal() async {
    await launchUrl(Uri.parse(widget.link.url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(showBack: true, title: widget.link.title),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            Align(
              alignment: Alignment.topCenter,
              child: Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.warning_amber_rounded),
                  title: const Text('No se pudo cargar completamente el módulo'),
                  subtitle: Text(_error!),
                  trailing: TextButton(onPressed: _openExternal, child: const Text('Abrir navegador')),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openExternal,
        icon: const Icon(Icons.open_in_browser),
        label: const Text('Navegador'),
      ),
    );
  }
}
