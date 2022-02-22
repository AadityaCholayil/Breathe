import 'package:breathe/models/user.dart';
import 'package:breathe/repositories/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'database_bloc_files.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  UserData userData;
  DatabaseRepository databaseRepository;

  DatabaseBloc({
    required this.userData,
    required this.databaseRepository,
  }) : super(Init()) {
    // on<GetRaidBossInfo>(_onGetRaidBossInfo);
    // on<GetPVPInfoFromImage>(_onGetPVPInfoFromImage);
    // on<GetPVPInfoFromAPI>(_onGetPVPInfoFromAPI);
    // on<GetWildPokemonInfoFromImage>(_onGetWildPokemonInfoFromImage);
    // on<GetWildPokemonInfoFromAPI>(_onGetWildPokemonInfoFromAPI);
    // on<GetMyPokemons>(_onGetMyPokemons);
    // on<AddPokemon>(_onAddPokemon);
    // on<UpdatePokemon>(_onUpdatePokemon);
    // on<DeletePokemon>(_onDeletePokemon);
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
