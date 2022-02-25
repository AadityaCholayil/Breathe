import 'package:breathe/bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
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
        emit(state.copyWith(reading: state.reading+10));
        await Future.delayed(const Duration(milliseconds: 500));
        predicting = false;
      }
    }
  }
}
