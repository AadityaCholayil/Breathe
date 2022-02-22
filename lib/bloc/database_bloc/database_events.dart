import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

// class GetMyPokemons extends DatabaseEvent {
//   @override
//   List<Object?> get props => [];
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
