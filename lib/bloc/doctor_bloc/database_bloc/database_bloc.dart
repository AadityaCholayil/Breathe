import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/repositories/doctor_chat_repository.dart';
import 'package:breathe/repositories/doctor_database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'database_bloc_files.dart';

class DoctorDatabaseBloc
    extends Bloc<DoctorDatabaseEvent, DoctorDatabaseState> {
  Doctor doctor;
  DoctorDatabaseRepository databaseRepository;
  late DoctorChatRepository chatRepository = DoctorChatRepository(doctor: Doctor.empty);

  DoctorDatabaseBloc({
    required this.doctor,
    required this.databaseRepository,
  }) : super(DoctorInit()) {
    chatRepository = DoctorChatRepository(doctor: doctor);
    on<GetPatientList>(_onGetPatientList);
    // on<SaveReport>(_onSaveReport);
    // on<DeleteReport>(_onDeleteReport);
  }

  Future<void> _onGetPatientList(
      GetPatientList event, Emitter<DoctorDatabaseState> emit) async {
    emit(const DoctorHomePageState(pageState: PageState.loading));
    try {
      // List<Patient> patientList =
      //     await databaseRepository.getPatients(doctor.doctorId);
      emit.forEach(
        chatRepository.patientsStream(),
        onData: (List<Patient> patientList) {
          return DoctorHomePageState(
            patientList: patientList,
            pageState: PageState.success,
          );
        },
      );
    } on Exception catch (_) {
      emit(const DoctorHomePageState(pageState: PageState.error));
    }
  }

// Future<void> _onSaveReport(
//     SaveReport event, Emitter<DoctorDatabaseState> emit) async {
//   emit(const SessionReportPageState(pageState: PageState.loading));
//   try {
//     await databaseRepository.addReport(event.report);
//     emit(SessionReportPageState(
//       report: event.report,
//       pageState: PageState.success,
//     ));
//   } on Exception catch (_) {
//     emit(const SessionReportPageState(pageState: PageState.error));
//   }
// }
//
// Future<void> _onDeleteReport(
//     DeleteReport event, Emitter<DoctorDatabaseState> emit) async {
//   emit(const SessionReportPageState(pageState: PageState.loading));
//   try {
//     await databaseRepository.deleteReport(event.report);
//     emit(SessionReportPageState(
//       report: event.report,
//       pageState: PageState.success,
//     ));
//   } on Exception catch (_) {
//     emit(const SessionReportPageState(pageState: PageState.error));
//   }
// }

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
