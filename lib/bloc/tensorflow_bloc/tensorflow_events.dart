import 'package:breathe/tflite/classifier.dart';
import 'package:breathe/utils/image_utils.dart';
import 'package:breathe/utils/isolate_utils.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class TensorFlowEvent extends Equatable {
  const TensorFlowEvent();

  @override
  List<Object?> get props => [];
}

class ChangeRecordingStatus extends TensorFlowEvent {
  @override
  String toString() {
    return 'ChangeRecordingStatus';
  }

  @override
  List<Object?> get props => [toString()];
}

class PerformInference extends TensorFlowEvent {
  final CameraImage image;
  final IsolateUtils isolateUtils;
  final Classifier classifier;

  const PerformInference({
    required this.image,
    required this.isolateUtils,
    required this.classifier,
  });

  @override
  String toString() {
    return 'PerformInference';
  }

  @override
  List<Object?> get props => [toString()];
}
