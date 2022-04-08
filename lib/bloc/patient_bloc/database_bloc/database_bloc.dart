import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/repositories/patient_database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'database_bloc_files.dart';

class PatientDatabaseBloc extends Bloc<PatientDatabaseEvent, PatientDatabaseState> {
  Patient patient;
  PatientDatabaseRepository databaseRepository;

  PatientDatabaseBloc({
    required this.patient,
    required this.databaseRepository,
  }) : super(PatientInit()) {
    on<GetTodaysReports>(_onGetTodaysReports);
    on<GetReports>(_onGetWeeklyReport);
    on<SaveReport>(_onSaveReport);
    on<DeleteReport>(_onDeleteReport);
  }

  Future<void> _onGetTodaysReports(
      GetTodaysReports event, Emitter<PatientDatabaseState> emit) async {
    emit(const PatientHomePageState(pageState: PageState.loading));
    try {
      List<SessionReport> reportList =
          await databaseRepository.getTodaysReports();
      print(reportList);
      emit(PatientHomePageState(
        reportList: reportList,
        pageState: PageState.success,
      ));
    } on Exception catch (_) {
      emit(const PatientHomePageState(pageState: PageState.error));
    }
  }

  Future<void> _onGetWeeklyReport(
      GetReports event, Emitter<PatientDatabaseState> emit) async {
    emit(const ReportPageState(pageState: PageState.loading));
    try {
      List<SessionReport> rawWeeklyReport =
      await databaseRepository.getWeeklyReport();
      List<DailyReport> weeklyReport = [];

      print(weeklyReport);
      emit(ReportPageState(
        weeklyReport: weeklyReport,
        pageState: PageState.success,
      ));
    } on Exception catch (_) {
      emit(const ReportPageState(pageState: PageState.error));
    }
  }

  Future<void> _onSaveReport(
      SaveReport event, Emitter<PatientDatabaseState> emit) async {
    emit(const SessionReportPageState(pageState: PageState.loading));
    try {
      await databaseRepository.addReport(event.report);
      emit(SessionReportPageState(
        report: event.report,
        pageState: PageState.success,
      ));
    } on Exception catch (_) {
      emit(const SessionReportPageState(pageState: PageState.error));
    }
  }

  Future<void> _onDeleteReport(
      DeleteReport event, Emitter<PatientDatabaseState> emit) async {
    emit(const SessionReportPageState(pageState: PageState.loading));
    try {
      await databaseRepository.deleteReport(event.report);
      emit(SessionReportPageState(
        report: event.report,
        pageState: PageState.success,
      ));
    } on Exception catch (_) {
      emit(const SessionReportPageState(pageState: PageState.error));
    }
  }

// Future<void> _onGetMyPokemons(
//     GetMyPokemons event, Emitter<DatabaseState> emit) async {
//   emit(const MyPokemonsPageState(pageState: PageState.loading));
//   try {
//     List<PokemonDB> list = await databaseRepository.getPokemons();
//     emit(MyPokemonsPageState(pokemonList: list, pageState: PageState.success));
//   } on Exception catch (_) {
//     emit(const MyPokemonsPageState(pageState: PageState.error));
//   }
// }
//
// Future<void> _onAddPokemon(
//     AddPokemon event, Emitter<DatabaseState> emit) async {
//   emit(const PokemonDBState(pageState: PageState.loading));
//   try {
//     PokemonDB pokemonDB = PokemonDB.fromPokemonPVP(event.pokemon);
//     await databaseRepository.addPokemon(pokemonDB);
//     print('Added to Database');
//     emit(const PokemonDBState(pageState: PageState.success));
//   } on Exception catch (_) {
//     emit(const PokemonDBState(pageState: PageState.error));
//   }
// }
//
// Future<void> _onUpdatePokemon(
//     UpdatePokemon event, Emitter<DatabaseState> emit) async {
//   emit(const PokemonDBState(pageState: PageState.loading));
//   try {
//     await databaseRepository.updatePokemon(event.pokemon);
//     emit(const PokemonDBState(pageState: PageState.success));
//   } on Exception catch (_) {
//     emit(const PokemonDBState(pageState: PageState.error));
//   }
// }
//
// Future<void> _onDeletePokemon(
//     DeletePokemon event, Emitter<DatabaseState> emit) async {
//   emit(const PokemonDBState(pageState: PageState.loading));
//   try {
//     await databaseRepository.deletePokemon(event.pokemon);
//     emit(const PokemonDBState(pageState: PageState.success));
//   } on Exception catch (_) {
//     emit(const PokemonDBState(pageState: PageState.error));
//   }
// }
}
