class Validators {
  static String? requiredField(String? value, {String label = 'Campo'}) {
    if (value == null || value.trim().isEmpty) return '$label requerido';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Correo requerido';
    if (!text.contains('@') || !text.split('@').last.contains('.')) {
      return 'Correo inválido';
    }
    return null;
  }
}
