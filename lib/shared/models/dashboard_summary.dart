class DashboardSummary {
  const DashboardSummary({
    required this.banks,
    required this.coop1,
    required this.coop2,
    required this.coop3,
    required this.metricsTotal,
    required this.pageVisits,
    required this.scoreQueries,
    required this.forumInteractions,
  });

  final int banks;
  final int coop1;
  final int coop2;
  final int coop3;
  final int metricsTotal;
  final int pageVisits;
  final int scoreQueries;
  final int forumInteractions;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? json;
    int asInt(String key) => int.tryParse('${data[key] ?? 0}') ?? 0;
    return DashboardSummary(
      banks: asInt('banks'),
      coop1: asInt('coop1'),
      coop2: asInt('coop2'),
      coop3: asInt('coop3'),
      metricsTotal: asInt('metrics_total'),
      pageVisits: asInt('page_visits'),
      scoreQueries: asInt('score_queries'),
      forumInteractions: asInt('forum_interactions'),
    );
  }

  static const empty = DashboardSummary(
    banks: 0,
    coop1: 0,
    coop2: 0,
    coop3: 0,
    metricsTotal: 0,
    pageVisits: 0,
    scoreQueries: 0,
    forumInteractions: 0,
  );
}
