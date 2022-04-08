import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorDatabaseEvent extends Equatable {
  const DoctorDatabaseEvent();

  @override
  List<Object?> get props => [];
}

class GetPatientList extends DoctorDatabaseEvent {
  const GetPatientList();

  @override
  List<Object?> get props => [];
}
//
// class SaveReport extends DoctorDatabaseEvent {
//   final SessionReport report;
//
//   const SaveReport({required this.report});
//
//   @override
//   List<Object?> get props => [report];
// }
//
// class DeleteReport extends DoctorDatabaseEvent {
//   final SessionReport report;
//
//   const DeleteReport({required this.report});
//
//   @override
//   List<Object?> get props => [report];
// }

// class AddPokemon extends DatabaseEvent {
//   final PokemonPVP pokemon;
//
//   const AddPokemon(this.pokemon);
//
//   @override
//   List<Object?> get props => [pokemon];
// }
//
// class UpdatePokemon extends DatabaseEvent {
//   final PokemonDB pokemon;
//
//   const UpdatePokemon(this.pokemon);
//
//   @override
//   List<Object?> get props => [pokemon];
// }
//
// class DeletePokemon extends DatabaseEvent {
//   final PokemonDB pokemon;
//
//   const DeletePokemon(this.pokemon);
//
//   @override
//   List<Object?> get props => [pokemon];
// }