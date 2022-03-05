import 'package:equatable/equatable.dart';

class TensorFlowState extends Equatable {
  final bool recording;
  final int reading;
  final Duration timeElapsed;
  final List recognitions;
  final int imageHeight;
  final int imageWidth;

  const TensorFlowState({
    required this.recording,
    required this.reading,
    required this.timeElapsed,
    required this.recognitions,
    required this.imageHeight,
    required this.imageWidth,
  });

  TensorFlowState copyWith({
    bool? recording,
    int? reading,
    Duration? timeElapsed,
    List? recognitions,
    int? imageWidth,
    int? imageHeight,
  }) {
    return TensorFlowState(
      recording: recording ?? this.recording,
      reading: reading ?? this.reading,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      recognitions: recognitions ?? this.recognitions,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
    );
  }

  @override
  List<Object?> get props => [recording, reading, timeElapsed];

  const TensorFlowState.init():this(
      recording: false,
      reading: 0,
      timeElapsed: const Duration(milliseconds: 0),
      recognitions: const [],
      imageHeight: 0,
      imageWidth: 0,
  );
}
