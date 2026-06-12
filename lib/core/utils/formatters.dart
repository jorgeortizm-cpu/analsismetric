class Formatters {
  static String compactInt(dynamic value) {
    final n = int.tryParse('$value') ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  static String money(dynamic value) {
    final n = double.tryParse('$value');
    if (n == null) return '—';
    return n.toStringAsFixed(2);
  }

  static String percent(dynamic value) {
    final n = double.tryParse('$value');
    if (n == null) return '—';
    final pct = n.abs() <= 1 ? n * 100 : n;
    return '${pct.toStringAsFixed(2)}%';
  }
}
