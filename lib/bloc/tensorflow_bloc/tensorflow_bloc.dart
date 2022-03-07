import 'package:breathe/bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/models/recognitions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite/tflite.dart';

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
        var recognitionsMap = await Tflite.detectObjectOnFrame(
            bytesList: event.image.planes.map((plane) {return plane.bytes;}).toList(),// required
            model: "SSDMobileNet",
            imageHeight: event.image.height,
            imageWidth: event.image.width,
            imageMean: 127.5,   // defaults to 127.5
            imageStd: 127.5,    // defaults to 127.5
            rotation: 90,       // defaults to 90, Android only
            threshold: 0.5,     // defaults to 0.1
            asynch: true        // defaults to true
        );
        print('hi');
        print(recognitionsMap);
        List<Recognition> recognitions = [];
        for(var recognition in recognitionsMap??[]) {
          recognitions.add(Recognition.fromJson(recognition));
        }
        emit(state.copyWith(reading: state.reading+1, recognitions: recognitions, imageHeight: event.image.height, imageWidth: event.image.width));
        // await Future.delayed(const Duration(milliseconds: 500));
        predicting = false;
      }
    }
  }
}
