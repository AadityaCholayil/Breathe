import 'package:flutter/material.dart';

/// Represents the recognition output from the model
class Recognition {
  /// Label of the result
  String label;

  /// Confidence [0.0, 1.0]
  double score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  Rect location;

  Recognition(
      {required this.label, required this.score, required this.location});

  static Recognition fromJson(Map json) {
    return Recognition(
      label: json['detectedClass'],
      score: json['confidenceInClass'],
      location: Rect.fromLTWH(
        json['rect']['x'] ?? 0,
        json['rect']['y'] ?? 0,
        json['rect']['w'] ?? 0,
        json['rect']['h'] ?? 0,
      ),
    );
  }

  @override
  String toString() {
    return 'Recognition(label: $label, score: $score, location: $location)';
  }
}
