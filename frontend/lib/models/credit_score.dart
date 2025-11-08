class CreditScore {
  final String id;
  final int score;
  final String grade;
  final List<ScoreHistory> history;
  final String lastUpdated;

  CreditScore({
    required this.id,
    required this.score,
    required this.grade,
    required this.history,
    required this.lastUpdated,
  });

  factory CreditScore.fromJson(Map<String, dynamic> json) {
    return CreditScore(
      id: json['_id'] ?? '',
      score: json['score'] ?? 0,
      grade: json['grade'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
      history: (json['history'] as List<dynamic>? ?? [])
          .map((e) => ScoreHistory.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'grade': grade,
      'lastUpdated': lastUpdated,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}

class ScoreHistory {
  final String date;
  final int score;

  ScoreHistory({
    required this.date,
    required this.score,
  });

  factory ScoreHistory.fromJson(Map<String, dynamic> json) {
    return ScoreHistory(
      date: json['date'] ?? '',
      score: json['score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'score': score,
    };
  }
}
