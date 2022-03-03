import 'package:breathe/bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/tflite/recognition.dart';
import 'package:breathe/tflite/stats.dart';
import 'package:breathe/utils/isolate_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TensorFlowBloc extends Bloc<TensorFlowEvent, TensorFlowState> {
  DateTime? startingTime;
  bool predicting = false;

  TensorFlowBloc() : super(const TensorFlowState.init()) {
    on<ChangeRecordingStatus>(_onChangeRecordingStatus);
    on<PerformInference>(_onPerformInference);
  }

  Future<void> _onChangeRecordingStatus(
      ChangeRecordingStatus event, Emitter<TensorFlowState> emit) async {
    startingTime = DateTime.now();
    emit(state.copyWith(recording: !state.recording));
    while(state.recording){
      var now = DateTime.now();
      Duration timeElapsed = now.difference(startingTime ?? now);
      emit(state.copyWith(timeElapsed: timeElapsed));
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> _onPerformInference(
      PerformInference event, Emitter<TensorFlowState> emit) async {
    if (state.recording) {
      if (!predicting) {
        predicting = true;

        var uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

        // Data to be passed to inference isolate
        var isolateData = IsolateData(
            event.image, event.classifier.interpreter!.address, event.classifier.labels!);

        // We could have simply used the compute method as well however
        // it would be as in-efficient as we need to continuously passing data
        // to another isolate.

        /// perform inference in separate isolate
        Map<String, dynamic> inferenceResults = await IsolateUtils.inference(event.isolateUtils, isolateData);

        var uiThreadInferenceElapsedTime =
            DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

        List<Recognition> recognitions = inferenceResults["recognitions"];

        Stats stats = inferenceResults["stats"] as Stats;
        stats.copyWith(totalElapsedTime: uiThreadInferenceElapsedTime);

        print(recognitions);
        print(stats);

        emit(state.copyWith(reading: state.reading+10, recognitions: recognitions));
        predicting = false;
      }
    }
  }
}
