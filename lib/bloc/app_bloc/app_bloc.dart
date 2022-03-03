import 'dart:async';
import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/custom_exceptions.dart';
import 'package:breathe/models/user.dart';
import 'package:breathe/repositories/auth_repository.dart';
import 'package:breathe/repositories/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  late DatabaseRepository _databaseRepository;
  late UserData userData;
  late DatabaseBloc databaseBloc;

  AppBloc({required authRepository})
      : _authRepository = authRepository,
        super(Uninitialized(userData: UserData.empty)) {
    userData = _authRepository.getUserData;
    _databaseRepository = DatabaseRepository(uid: userData.uid);
    on<AppStarted>(_onAppStarted);
    on<LoginUser>(_onLoginUser);
    on<CheckEmailStatus>(_onCheckEmailStatus);
    on<SignupUser>(_onSignupUser);
    on<UpdateUserData>(_onUpdateUserData);
    on<LoggedOut>(_onLoggedOut);
  }

  // When the App Starts
  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
    try {
      userData = _authRepository.getUserData;
      if (userData != UserData.empty) {
        // Authenticated
        // Update DatabaseRepository
        _databaseRepository = DatabaseRepository(uid: userData.uid);
        // Fetch rest of the user details from database
        UserData completeUserData = await _databaseRepository.completeUserData;
        if (completeUserData != UserData.empty) {
          // if db fetch is successful
          userData = completeUserData;
          emit(Authenticated(userData: userData));
        } else {
          // if db fetch fails
          emit(const ErrorOccurred(error: 'Failed to fetch details!'));
        }
      } else {
        emit(Unauthenticated(userData: userData));
      }
    } on Exception catch (e) {
      // If something goes wrong
      emit(ErrorOccurred(error: e.toString()));
    }
  }

  // When the User Logs in
  FutureOr<void> _onLoginUser(LoginUser event, Emitter<AppState> emit) async {
    emit(LoginPageState.loading);
    try {
      // Login using email and password
      userData = await _authRepository.logInWithCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DatabaseRepository(uid: userData.uid);
      // After login fetch rest of the user details from database
      UserData completeUserData = await _databaseRepository.completeUserData;
      if (completeUserData != UserData.empty) {
        // if db fetch is successful
        userData = completeUserData;
        emit(Authenticated(userData: userData));
      } else {
        // if db fetch fails
        emit(const ErrorOccurred(error: 'Failed to fetch details!'));
      }
    } on Exception catch (e) {
      print(e);
      if (e is UserNotFoundException) {
        emit(LoginPageState.noUserFound);
      } else if (e is WrongPasswordException) {
        emit(LoginPageState.wrongPassword);
      } else {
        emit(LoginPageState.somethingWentWrong);
      }
    }
  }

  Future<void> _onCheckEmailStatus(
      CheckEmailStatus event, Emitter<AppState> emit) async {
    // emit loading
    emit(const EmailInputState(emailStatus: EmailStatus.loading));
    try {
      // Try to login with the email provided with null as password
      // This will throw an exception
      await _authRepository.logInWithCredentials(event.email, 'null');
    } on Exception catch (e) {
      if (e is UserNotFoundException) {
        // This means there was no existing user found for that email
        // Hence, the email is valid
        emit(const EmailInputState(emailStatus: EmailStatus.valid));
      } else {
        emit(const EmailInputState(emailStatus: EmailStatus.invalid));
      }
    }
  }

  // When the User Signs up
  FutureOr<void> _onSignupUser(SignupUser event, Emitter<AppState> emit) async {
    emit(SignupPageState.loading);
    try {
      // Signup using email and password
      userData = await _authRepository.signUpUsingCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DatabaseRepository(uid: userData.uid);
      // Add User details to db
      UserData newUserData = UserData(
        uid: userData.uid,
        email: event.email,
        name: event.name,
        age: event.age,
        gender: event.gender,
        doctorId: event.doctorId,
        hospital: event.hospital,
      );
      _databaseRepository.updateUserData(newUserData);
      userData = newUserData;
      emit(Authenticated(userData: userData));
    } on Exception catch (e) {
      if (e is EmailAlreadyInUseException) {
        emit(SignupPageState.userAlreadyExists);
      } else {
        emit(SignupPageState.somethingWentWrong);
      }
    }
  }

  FutureOr<void> _onUpdateUserData(
      UpdateUserData event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
  }

  FutureOr<void> _onLoggedOut(LoggedOut event, Emitter<AppState> emit) async {
    emit(Uninitialized(userData: UserData.empty));
    userData = UserData.empty;
    _databaseRepository = DatabaseRepository(uid: userData.uid);
    // updateDatabaseBloc();
    await _authRepository.signOut();
    emit(Unauthenticated(userData: userData));
  }
}
