import 'package:equatable/equatable.dart';

class TensorFlowState extends Equatable {
  final bool recording;
  final int reading;
  final Duration timeElapsed;

  const TensorFlowState({
    required this.recording,
    required this.reading,
    required this.timeElapsed,
  });

  TensorFlowState copyWith({
    bool? recording,
    int? reading,
    Duration? timeElapsed,
  }) {
    return TensorFlowState(
      recording: recording ?? this.recording,
      reading: reading ?? this.reading,
      timeElapsed: timeElapsed ?? this.timeElapsed,
    );
  }

  @override
  List<Object?> get props => [recording, reading, timeElapsed];

  const TensorFlowState.init():this(
      recording: false,
      reading: 0,
      timeElapsed: const Duration(milliseconds: 0),
  );
}
