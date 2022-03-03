/// Bundles different elapsed times
class Stats {
  /// Total time taken in the isolate where the inference runs
  final int totalPredictTime;

  /// [totalPredictTime] + communication overhead time
  /// between main isolate and another isolate
  final int totalElapsedTime;

  /// Time for which inference runs
  final int inferenceTime;

  /// Time taken to pre-process the image
  final int preProcessingTime;

  const Stats(
      {required this.totalPredictTime,
      this.totalElapsedTime = 0,
      required this.inferenceTime,
      required this.preProcessingTime});

  const Stats.init()
      : this(
          totalPredictTime: 0,
          totalElapsedTime: 0,
          inferenceTime: 0,
          preProcessingTime: 0,
        );

  Stats copyWith(
      {int? totalPredictTime,
      int? totalElapsedTime,
      int? inferenceTime,
      int? preProcessingTime}) {
    return Stats(
      totalPredictTime: totalPredictTime ?? this.totalPredictTime,
      totalElapsedTime: totalElapsedTime ?? this.totalElapsedTime,
      inferenceTime: inferenceTime ?? this.inferenceTime,
      preProcessingTime: preProcessingTime ?? this.preProcessingTime,
    );
  }

  @override
  String toString() {
    return 'Stats{totalPredictTime: $totalPredictTime, totalElapsedTime: $totalElapsedTime, inferenceTime: $inferenceTime, preProcessingTime: $preProcessingTime}';
  }
}
