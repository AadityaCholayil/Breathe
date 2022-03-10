import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class GetTodaysReports extends DatabaseEvent {
  const GetTodaysReports();

  @override
  List<Object?> get props => [];
}

class SaveReport extends DatabaseEvent {
  final SessionReport report;

  const SaveReport({required this.report});

  @override
  List<Object?> get props => [];
}

class DeleteReport extends DatabaseEvent {
  final SessionReport report;

  const DeleteReport({required this.report});

  @override
  List<Object?> get props => [];
}

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
