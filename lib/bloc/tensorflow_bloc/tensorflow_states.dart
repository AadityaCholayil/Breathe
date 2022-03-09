import 'package:breathe/models/recognitions.dart';
import 'package:equatable/equatable.dart';

class TensorFlowState extends Equatable {
  final bool recording;
  final bool processingDone;
  final int reading;
  final Duration timeElapsed;
  final List<Recognition> recognitions;
  final int imageHeight;
  final int imageWidth;

  const TensorFlowState({
    required this.recording,
    required this.processingDone,
    required this.reading,
    required this.timeElapsed,
    required this.recognitions,
    required this.imageHeight,
    required this.imageWidth,
  });

  TensorFlowState copyWith({
    bool? recording,
    bool? processingDone,
    int? reading,
    Duration? timeElapsed,
    List<Recognition>? recognitions,
    int? imageWidth,
    int? imageHeight,
  }) {
    return TensorFlowState(
      recording: recording ?? this.recording,
      processingDone: processingDone ?? this.processingDone,
      reading: reading ?? this.reading,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      recognitions: recognitions ?? this.recognitions,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
    );
  }

  @override
  List<Object?> get props => [
        recording,
        processingDone,
        reading,
        timeElapsed,
        recognitions,
        imageWidth,
        imageHeight
      ];

  const TensorFlowState.init()
      : this(
          recording: false,
          processingDone: false,
          reading: 0,
          timeElapsed: const Duration(milliseconds: 0),
          recognitions: const [],
          imageHeight: 0,
          imageWidth: 0,
        );
}
