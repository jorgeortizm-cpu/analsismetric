class BceIndicator {
  const BceIndicator({
    required this.label,
    required this.value,
    required this.period,
    required this.category,
    required this.sourceUrl,
  });

  final String label;
  final String value;
  final String period;
  final String category;
  final String sourceUrl;

  factory BceIndicator.fromJson(Map<String, dynamic> json) => BceIndicator(
        label: '${json['label'] ?? ''}',
        value: '${json['value'] ?? ''}',
        period: '${json['period'] ?? ''}',
        category: '${json['category'] ?? ''}',
        sourceUrl: '${json['source_url'] ?? ''}',
      );
}
