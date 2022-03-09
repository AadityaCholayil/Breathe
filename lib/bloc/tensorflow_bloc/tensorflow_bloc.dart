import 'package:breathe/bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/models/recognitions.dart';
import 'package:breathe/models/session_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/tflite.dart';

class TensorFlowBloc extends Bloc<TensorFlowEvent, TensorFlowState> {
  late DateTime startingTime;
  bool predicting = false;
  Duration timeElapsed = const Duration();
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
    report.totalDuration = report.readings.last.timeElapsed;
    report.setAverageScore();
    report.setBestScore();
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
        report.readings.add(Reading(timeElapsed: timeElapsed.inMilliseconds, score: reading));
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

  // Algo to get score
  int getScoreFromRecognitions(List<Recognition> recognitions) {
    if (recognitions.length >= 3) {
      recognitions.sort((a, b) => b.score.compareTo(a.score));
      recognitions.getRange(0, 3);
    }

    return (state.reading + 10) % 1200;
  }
}
