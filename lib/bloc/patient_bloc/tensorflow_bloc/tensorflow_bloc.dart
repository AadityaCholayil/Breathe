import 'package:breathe/bloc/patient_bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/recognitions.dart';
import 'package:breathe/models/session_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/tflite.dart';

class TensorFlowBloc extends Bloc<TensorFlowEvent, TensorFlowState> {
  late DateTime startingTime;
  bool predicting = false;
  Duration timeElapsed = const Duration();
  List<Reading> readings = [];
  late SessionReport report;

  TensorFlowBloc() : super(const TensorFlowState.init()) {
    on<StartSession>(_onStartSession);
    on<EndSession>(_onEndSession);
    on<PerformInference>(_onPerformInference);
  }

  Future<void> _onStartSession(
      StartSession event, Emitter<TensorFlowState> emit) async {
    startingTime = DateTime.now();
    report = SessionReport(timeTakenAt: Timestamp.fromDate(startingTime));
    emit(state.copyWith(recording: true));
    while (state.recording) {
      var now = DateTime.now();
      timeElapsed = now.difference(startingTime);
      emit(state.copyWith(timeElapsed: timeElapsed));
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _onEndSession(
      EndSession event, Emitter<TensorFlowState> emit) async {
    emit(state.copyWith(timeElapsed: timeElapsed, recording: false));
    report.totalDuration = readings.last.timeElapsed;
    report.readings = readings;
    report.setAverageScore();
    report.setBestScore();
    report.date = getDateFromDateTime(startingTime);
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(processingDone: true));
  }

  Future<void> _onPerformInference(
      PerformInference event, Emitter<TensorFlowState> emit) async {
    if (state.recording) {
      if (!predicting) {
        predicting = true;
        var recognitionsMap = await Tflite.detectObjectOnFrame(
          bytesList: event.image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "SSDMobileNet",
          imageHeight: event.image.height,
          imageWidth: event.image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          threshold: 0.5,
          asynch: true,
        );
        print(recognitionsMap);
        List<Recognition> recognitions = [];
        for (var recognition in recognitionsMap ?? []) {
          recognitions.add(Recognition.fromJson(recognition));
        }
        int reading = getScoreFromRecognitions(recognitions);
        readings.add(Reading(
            timeElapsed: DateTime.now().difference(startingTime).inMilliseconds,
            score: reading));
        emit(state.copyWith(
          reading: reading,
          recognitions: recognitions,
          imageHeight: event.image.height,
          imageWidth: event.image.width,
        ));
        predicting = false;
      }
    }
  }

  // Algorithm to get score
  int getScoreFromRecognitions(List<Recognition> recognitions) {
    if (recognitions.length >= 3) {
      recognitions.sort((a, b) => b.score.compareTo(a.score));
      recognitions.getRange(0, 3);
      // case zero
      double threshold =
          (recognitions.map((r) => r.location.height).reduce((a, b) => a + b) /
                  3) *
              0.4;
      recognitions.sort((a, b) => a.location.left.compareTo(b.location.left));
      double b1 = recognitions[0].location.bottom;
      double b2 = recognitions[1].location.bottom;
      double b3 = recognitions[2].location.bottom;
      // For 0 and 1200
      if (b2 - b1 < threshold && b3 - b2 < threshold) {
        if (b1 < 0.5) {
          return 1200;
        } else {
          return 0;
        }
      }
      // For 1 ball up
      if (b3 - b2 < threshold && b2 - b1 > threshold) {
        double spiroHeight = recognitions[1].location.height * 4.2;
        int reading = ((b1 / spiroHeight) * 600).ceil();
        print('NEW: h: $spiroHeight, b1: $b1, b2: $b2, reading: $reading');

        double spiroHeight2 = recognitions[1].location.height * 4.2;
        int reading2 = (((b1 - b2) / (spiroHeight2 - b2)) * 600).ceil();
        print('OLD: h: $spiroHeight2, b1: $b1, b2: $b2, reading: $reading2');
        return reading2 < 600 ? reading2 : 600;
      }
      // For 2nd ball middle
      if (b2 - b1 > threshold && b3 - b2 > threshold) {
        double spiroHeight = recognitions[0].location.height * 3.2;
        int reading = (((b2 - b3) / (spiroHeight - b3)) * 300).ceil();
        return 600 + (reading < 300 ? reading : 300);
      }
      if (b2 - b1 < threshold &&
          b3 - b2 < (recognitions[0].location.height * 3.2)) {
        double spiroHeight = recognitions[0].location.height * 3.2;
        int reading = (((spiroHeight - (b2 - b3) / spiroHeight - b3)) * 300).ceil();
        return 900 + (reading < 300 ? reading : 300);
      }
    }
    return state.reading;
  }
}
