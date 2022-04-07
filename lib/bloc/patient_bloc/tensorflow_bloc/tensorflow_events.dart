import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class TensorFlowEvent extends Equatable {
  const TensorFlowEvent();

  @override
  List<Object?> get props => [];
}

class StartSession extends TensorFlowEvent {
  @override
  String toString() {
    return 'StartSession';
  }

  @override
  List<Object?> get props => [toString()];
}

class EndSession extends TensorFlowEvent {
  @override
  String toString() {
    return 'EndSession';
  }

  @override
  List<Object?> get props => [toString()];
}

class PerformInference extends TensorFlowEvent {
  final CameraImage image;

  const PerformInference({required this.image});

  @override
  String toString() {
    return 'PerformInference';
  }

  @override
  List<Object?> get props => [toString()];
}

