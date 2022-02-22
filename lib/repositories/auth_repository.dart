import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:breathe/models/custom_exceptions.dart';
import 'package:breathe/models/user.dart';

class AuthRepository{

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth , GoogleSignIn? googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  // Login using Google Auth
  Future<UserData> logInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      await _firebaseAuth.signInWithCredential(credential);
      User? user = _firebaseAuth.currentUser;
      return user==null?UserData.empty:UserData.fromUser(user);
    } on Exception catch (_) {
      // throw custom exception that can be handled in AppBloc
      throw SignInWithGoogleFailure();
    }
  }

  // Login using email and password
  Future<UserData> logInWithCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user==null?UserData.empty:UserData.fromUser(user);
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
  Future<UserData> signUpUsingCredentials(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user==null?UserData.empty:UserData.fromUser(user);
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
      await _googleSignIn.signOut();
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

  UserData get getUserData {
    User? user = _firebaseAuth.currentUser;
    return user==null?UserData.empty:UserData.fromUser(user);
  }

  Stream<UserData> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      return user==null?UserData.empty:UserData.fromUser(user);
    });
  }

}
