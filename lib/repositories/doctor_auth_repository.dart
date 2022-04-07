import 'package:breathe/models/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathe/models/custom_exceptions.dart';
import 'package:breathe/models/patient.dart';

class DoctorAuthRepository{
  final FirebaseAuth _firebaseAuth;

  DoctorAuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Login using email and password
  Future<Doctor> logInWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user==null?Doctor.empty:Doctor.fromUser(user);
    } on FirebaseAuthException catch (e) {
      // throw custom exceptions that can be handled in AppBloc
      print(e.code);
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException();
        case 'wrong-password':
          throw WrongPasswordException();
        default:
          throw SomethingWentWrongException();
      }
    } catch (_) {
      throw SomethingWentWrongException();
    }
  }

  // Signup using email and password
  Future<Doctor> signUpUsingCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user==null?Doctor.empty:Doctor.fromUser(user);
    } on FirebaseAuthException catch (e) {
      // throw custom exceptions that can be handled in AppBloc
      print(e.code);
      switch (e.code) {
        case 'email-already-in-use':
          throw EmailAlreadyInUseException();
        default:
          throw SomethingWentWrongException();
      }
    } catch (_) {
      throw SomethingWentWrongException();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception catch (_) {
      // throw custom exceptions that can be handled in AppBloc
      throw SignOutFailure();
    }
  }

  Future<void> deleteUser() async {
    try {
      _firebaseAuth.currentUser!.delete();
    } on Exception catch (_) {
      // TODO add exception

    }
  }

  // returns true if a user is signed in
  // TODO: test in AppBloc
  bool get isSignedIn {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Doctor get getUserData {
    User? user = _firebaseAuth.currentUser;
    return user==null?Doctor.empty:Doctor.fromUser(user);
  }

  Stream<Doctor> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      return user==null?Doctor.empty:Doctor.fromUser(user);
    });
  }

}
