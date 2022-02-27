class SessionReport {
  int bestScore;
  int averageScore;
  List<FullReading> fullReading;
  int totalDuration;
  String timeTakeAt;

  SessionReport(
      {this.bestScore = 0,
        this.averageScore = 0,
        this.fullReading = const [],
        this.totalDuration = 0,
        this.timeTakeAt = ''});

  static SessionReport fromJson(Map<String, dynamic> json) {
    int bestScore = json['bestScore'];
    int averageScore = json['averageScore'];
    List<FullReading> fullReading = [];
    if (json['fullReading'] != null) {
      json['fullReading'].forEach((v) {

      });
      for(var reading in json['fullReading']){
        fullReading.add(FullReading.fromJson(reading));
      }
    }
    int totalDuration = json['totalDuration'];
    String timeTakenAt = json['timeTakenAt'];
    print(fullReading);
    return SessionReport(
      bestScore: bestScore,
      averageScore: averageScore,
      fullReading: fullReading,
      totalDuration: totalDuration,
      timeTakeAt: timeTakenAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bestScore'] = bestScore;
    data['averageScore'] = averageScore;
    data['fullReading'] = fullReading.map((v) => v.toJson()).toList();
    data['totalDuration'] = totalDuration;
    data['timeTakenAt'] = timeTakeAt;
    return data;
  }
}

class FullReading {
  int timeElapsed;
  int score;

  FullReading({this.timeElapsed = 0, this.score = 0});

  static FullReading fromJson(Map<String, dynamic> json) {
    int timeElapsed = json['timeElapsed'] ;
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

  @override
  String toString() {
    return "FullReading($timeElapsed, $score)";
  }
}