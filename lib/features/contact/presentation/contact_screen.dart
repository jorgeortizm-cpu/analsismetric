import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/error_panel.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_title.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _topic = TextEditingController(text: 'Consulta desde app móvil');
  final _message = TextEditingController();
  bool _accepted = true;
  bool _busy = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _topic.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
      _success = null;
    });
    try {
      final json = await _api.postJson('/api/contact', {
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'topic': _topic.text.trim(),
        'message': _message.text.trim(),
        'accepted_terms': _accepted,
      });
      if (!mounted) return;
      setState(() => _success = '${json['message'] ?? 'Consulta enviada correctamente.'}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(showBack: true, title: 'Contacto'),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          SectionTitle(
            title: 'Contacto AnalisisMetric',
            subtitle: 'Formulario conectado al endpoint /api/contact con compatibilidad SMTP/SendGrid del backend.',
          ),
          if (_error != null) ErrorPanel(message: _error!),
          if (_success != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Solicitud registrada'),
                subtitle: Text(_success!),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: _name, validator: (v) => Validators.requiredField(v, label: 'Nombre'), decoration: const InputDecoration(labelText: 'Nombre')),
                    const SizedBox(height: 12),
                    TextFormField(controller: _email, validator: Validators.email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo')),
                    const SizedBox(height: 12),
                    TextFormField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Teléfono / WhatsApp')),
                    const SizedBox(height: 12),
                    TextFormField(controller: _topic, validator: (v) => Validators.requiredField(v, label: 'Tema'), decoration: const InputDecoration(labelText: 'Tema')),
                    const SizedBox(height: 12),
                    TextFormField(controller: _message, validator: (v) => Validators.requiredField(v, label: 'Mensaje'), minLines: 4, maxLines: 8, decoration: const InputDecoration(labelText: 'Mensaje')),
                    CheckboxListTile(
                      value: _accepted,
                      onChanged: (v) => setState(() => _accepted = v ?? false),
                      title: const Text('Acepto términos y condiciones'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    PrimaryButton(text: _busy ? 'Enviando...' : 'Enviar consulta', icon: Icons.send, expanded: true, onPressed: _busy ? null : _send),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
