import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class SessionReport {
  String id;
  int bestScore;
  int averageScore;
  List<Reading> readings;
  int totalDuration;
  Timestamp timeTakenAt;
  String date;

  SessionReport({
    this.id = '',
    this.date = '',
    this.bestScore = 0,
    this.averageScore = 0,
    this.readings = const [],
    this.totalDuration = 0,
    required this.timeTakenAt,
  });

  static SessionReport fromJson(Map<String, dynamic> json, String id) {
    String date = json['date'];
    int bestScore = json['bestScore'];
    int averageScore = json['averageScore'];
    List<Reading> readings = [];
    if (json['readings'] != null) {
      for (var reading in json['readings']) {
        readings.add(Reading.fromJson(reading));
      }
    }
    int totalDuration = json['totalDuration'];
    Timestamp timeTakenAt = json['timeTakenAt'];
    print(readings);
    return SessionReport(
      id: id,
      date: date,
      bestScore: bestScore,
      averageScore: averageScore,
      readings: readings,
      totalDuration: totalDuration,
      timeTakenAt: timeTakenAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['bestScore'] = bestScore;
    data['averageScore'] = averageScore;
    data['readings'] = readings.map((v) => v.toJson()).toList();
    data['totalDuration'] = totalDuration;
    data['timeTakenAt'] = timeTakenAt;
    return data;
  }

  List<Reading> get peaks {
    List<Reading> peaks = [];
    for (int i = 1; i < readings.length; i++) {
      if (readings[i].score < readings[i - 1].score) {
        peaks.add(readings[i - 1]);
      }
    }
    return peaks;
  }

  void setAverageScore() {
    averageScore =
        (peaks.map((p) => p.score).reduce((a, b) => a + b) / peaks.length)
            .ceil();
  }

  void setBestScore() {
    bestScore = (peaks.reduce((p1, p2) => p1.score > p2.score ? p1 : p2)).score;
  }

  @override
  String toString() {
    return 'SessionReport(id: $id, date: $date, bestScore: $bestScore, averageScore: $averageScore, readings: $readings, totalDuration: $totalDuration, timeTakenAt: $timeTakenAt)';
  }

  static SessionReport empty() {
    return SessionReport(
      id: '',
      date: '',
      bestScore: 0,
      averageScore: 0,
      readings: [],
      totalDuration: 0,
      timeTakenAt: Timestamp.fromMillisecondsSinceEpoch(0),
    );
  }

//    const SessionReport.init() : this(
//     id: '',
//     bestScore: 0,
//     averageScore: 0,
//     reading: [],
//     totalDuration: 0,
//     timeTakenAt: Timestamp.fromMillisecondsSinceEpoch(0),
//   );

}

class Reading {
  int timeElapsed;
  int score;

  Reading({this.timeElapsed = 0, this.score = 0});

  static Reading fromJson(Map<String, dynamic> json) {
    int timeElapsed = json['timeElapsed'];
    int score = json['score'];
    return Reading(timeElapsed: timeElapsed, score: score);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['timeElapsed'] = timeElapsed;
    data['score'] = score;
    return data;
  }

  @override
  String toString() {
    return "Reading($timeElapsed, $score)";
  }
}
