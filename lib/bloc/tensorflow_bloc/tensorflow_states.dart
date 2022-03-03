import 'package:breathe/tflite/recognition.dart';
import 'package:breathe/tflite/stats.dart';
import 'package:equatable/equatable.dart';

class TensorFlowState extends Equatable {
  final bool recording;
  final int reading;
  final Duration timeElapsed;
  final List<Recognition> recognitions;
  final Stats stats;

  const TensorFlowState({
    required this.recording,
    required this.reading,
    required this.timeElapsed,
    required this.recognitions,
    required this.stats,
  });

  TensorFlowState copyWith({
    bool? recording,
    int? reading,
    Duration? timeElapsed,
    List<Recognition>? recognitions,
    Stats? stats,
  }) {
    return TensorFlowState(
      recording: recording ?? this.recording,
      reading: reading ?? this.reading,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      recognitions: recognitions ?? this.recognitions,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props =>
      [recording, reading, timeElapsed, recognitions, stats];

  const TensorFlowState.init()
      : this(
          recording: false,
          reading: 0,
          timeElapsed: const Duration(milliseconds: 0),
          recognitions: const [],
          stats: const Stats.init(),
        );
}
