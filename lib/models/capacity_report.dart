class CapacityReport {
  int bestScore;
  int averageScore;
  List<FullReading> fullReading;
  double totalDuration;
  String timeTaken;

  CapacityReport(
      {this.bestScore = 0,
        this.averageScore = 0,
        this.fullReading = const [],
        this.totalDuration = 0,
        this.timeTaken = ''});

  static CapacityReport fromJson(Map<String, dynamic> json) {
    int bestScore = json['bestScore'];
    int averageScore = json['averageScore'];
    List<FullReading> fullReading = [];
    if (json['fullReading'] != null) {
      json['fullReading'].forEach((v) {
        fullReading.add(FullReading.fromJson(v));
      });
    }
    double totalDuration = json['totalDuration'];
    String timeTaken = json['timeTaken'];
    return CapacityReport(
      bestScore: bestScore,
      averageScore: averageScore,
      fullReading: fullReading,
      totalDuration: totalDuration,
      timeTaken: timeTaken,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bestScore'] = bestScore;
    data['averageScore'] = averageScore;
    data['fullReading'] = fullReading.map((v) => v.toJson()).toList();
    data['totalDuration'] = totalDuration;
    data['timeTaken'] = timeTaken;
    return data;
  }
}

class FullReading {
  double timeElapsed;
  int score;

  FullReading({this.timeElapsed = 0, this.score = 0});

  static FullReading fromJson(Map<String, dynamic> json) {
    double timeElapsed = json['timeElapsed'];
    int score = json['score'];
    return FullReading(
      timeElapsed: timeElapsed,
      score: score
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeElapsed'] = timeElapsed;
    data['score'] = score;
    return data;
  }
}