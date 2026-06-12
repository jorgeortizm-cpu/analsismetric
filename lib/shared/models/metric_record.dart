class MetricRecord {
  const MetricRecord({
    required this.id,
    required this.entityType,
    this.segment,
    required this.entityName,
    required this.period,
    required this.payload,
    this.createdAt,
  });

  final int id;
  final String entityType;
  final int? segment;
  final String entityName;
  final String period;
  final Map<String, dynamic> payload;
  final String? createdAt;

  factory MetricRecord.fromJson(Map<String, dynamic> json) => MetricRecord(
        id: int.tryParse('${json['id'] ?? 0}') ?? 0,
        entityType: '${json['entity_type'] ?? ''}',
        segment: json['segment'] == null ? null : int.tryParse('${json['segment']}'),
        entityName: '${json['entity_name'] ?? ''}',
        period: '${json['period'] ?? ''}',
        payload: (json['payload'] as Map?)?.cast<String, dynamic>() ?? const {},
        createdAt: json['created_at']?.toString(),
      );
}
