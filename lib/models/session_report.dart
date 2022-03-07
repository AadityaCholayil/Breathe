class SessionReport {
  int bestScore;
  int averageScore;
  List<Reading> reading;
  int totalDuration;
  String timeTakeAt;

  SessionReport(
      {this.bestScore = 0,
        this.averageScore = 0,
        this.reading = const [],
        this.totalDuration = 0,
        this.timeTakeAt = ''});

  static SessionReport fromJson(Map<String, dynamic> json) {
    int bestScore = json['bestScore'];
    int averageScore = json['averageScore'];
    List<Reading> reading = [];
    if (json['reading'] != null) {
      json['reading'].forEach((v) {

      });
      for(var reading in json['reading']){
        reading.add(Reading.fromJson(reading));
      }
    }
    int totalDuration = json['totalDuration'];
    String timeTakenAt = json['timeTakenAt'];
    print(reading);
    return SessionReport(
      bestScore: bestScore,
      averageScore: averageScore,
      reading: reading,
      totalDuration: totalDuration,
      timeTakeAt: timeTakenAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bestScore'] = bestScore;
    data['averageScore'] = averageScore;
    data['reading'] = reading.map((v) => v.toJson()).toList();
    data['totalDuration'] = totalDuration;
    data['timeTakenAt'] = timeTakeAt;
    return data;
  }
}

class Reading {
  int timeElapsed;
  int score;

  Reading({this.timeElapsed = 0, this.score = 0});

  static Reading fromJson(Map<String, dynamic> json) {
    int timeElapsed = json['timeElapsed'] ;
    int score = json['score'];
    return Reading(
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