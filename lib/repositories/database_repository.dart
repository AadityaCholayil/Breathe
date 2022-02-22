import 'package:breathe/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Users Collection Reference
  // Reference allows for easy from and to operations
  CollectionReference<UserData> get usersRef =>
      db.collection('users').withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  // Get UserData from DB
  Future<UserData> get completeUserData async {
    try {
      UserData userDataNew = await usersRef
          .doc(uid)
          .get()
          .then((value) => value.data() ?? UserData.empty);
      return userDataNew;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return UserData.empty;
    }
  }

  // Update UserData in DB
  Future<void> updateUserData(UserData userData) async {
    await usersRef.doc(uid).set(userData);
  }

  // Delete UserData from db
  Future<void> deleteUser() async {
    await usersRef.doc(uid).delete();
  }

  // // Pokemons Collection Reference for specific user
  // CollectionReference<PokemonDB> get pokemonsRef => db
  //     .collection('users')
  //     .doc(uid)
  //     .collection('pokemons')
  //     .withConverter<PokemonDB>(
  //       fromFirestore: (snapshot, a) =>
  //           PokemonDB.fromJson(snapshot.data()!, snapshot.id),
  //       toFirestore: (pokemon, _) => pokemon.toJson(),
  //     );
  //
  // // Get Pokemons from db
  // Future<List<PokemonDB>> getPokemons() async {
  //   List<QueryDocumentSnapshot<PokemonDB>> list = [];
  //   list = await pokemonsRef.get().then((snapshot) => snapshot.docs);
  //   return list.map((e) => e.data()).toList();
  // }
  //
  // Future<void> addPokemon(PokemonDB pokemon) async {
  //   await pokemonsRef.add(pokemon);
  // }
  //
  // Future<void> updatePokemon(PokemonDB pokemon) async {
  //   await pokemonsRef.doc(pokemon.id).set(pokemon);
  // }
  //
  // Future<void> deletePokemon(PokemonDB pokemon) async {
  //   await pokemonsRef.doc(pokemon.id).delete();
  // }
}
