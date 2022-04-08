import 'dart:async';
import 'package:breathe/bloc/doctor_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/custom_exceptions.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/repositories/doctor_auth_repository.dart';
import 'package:breathe/repositories/doctor_database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DoctorAppBloc extends Bloc<DoctorAppEvent, DoctorAppState> {
  final DoctorAuthRepository _doctorAuthRepository;
  late DoctorDatabaseRepository _databaseRepository;
  late Doctor doctor;
  late DoctorDatabaseBloc databaseBloc;

  DoctorAppBloc({required authRepository})
      : _doctorAuthRepository = authRepository,
        super(UninitializedDoctor(doctor: Doctor.empty)) {
    doctor = _doctorAuthRepository.getUserData;
    _databaseRepository = DoctorDatabaseRepository(uid: doctor.uid);
    on<DoctorAppStarted>(_onAppStarted);
    on<DoctorLogin>(_onLoginUser);
    on<DoctorCheckEmailStatus>(_onCheckEmailStatus);
    on<DoctorSignup>(_onSignupUser);
    on<UpdateDoctorData>(_onUpdateUserData);
    on<DoctorLoggedOut>(_onLoggedOut);
  }

  // When the App Starts
  FutureOr<void> _onAppStarted(DoctorAppStarted event, Emitter<DoctorAppState> emit) async {
    emit(UninitializedDoctor(doctor: Doctor.empty));
    try {
      doctor = _doctorAuthRepository.getUserData;
      if (doctor != Doctor.empty) {
        // Authenticated
        // Update DatabaseRepository
        _databaseRepository = DoctorDatabaseRepository(uid: doctor.uid);
        // Fetch rest of the user details from database
        Doctor completeUserData = await _databaseRepository.completeDoctorData;
        if (completeUserData != Doctor.empty) {
          // if db fetch is successful
          doctor = completeUserData;
          emit(AuthenticatedDoctor(doctor: doctor));
        } else {
          // if db fetch fails
          emit(const ErrorOccurredDoctor(error: 'Failed to fetch details!'));
        }
      } else {
        emit(UnauthenticatedDoctor(doctor: doctor));
      }
    } on Exception catch (e) {
      // If something goes wrong
      emit(ErrorOccurredDoctor(error: e.toString()));
    }
  }

  // When the User Logs in
  FutureOr<void> _onLoginUser(DoctorLogin event, Emitter<DoctorAppState> emit) async {
    emit(DoctorLoginPageState.loading);
    try {
      // Login using email and password
      doctor = await _doctorAuthRepository.logInWithCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DoctorDatabaseRepository(uid: doctor.uid);
      // After login fetch rest of the user details from database
      Doctor completeUserData = await _databaseRepository.completeDoctorData;
      if (completeUserData != Doctor.empty) {
        // if db fetch is successful
        doctor = completeUserData;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isDoctor', true);
        emit(AuthenticatedDoctor(doctor: doctor));
      } else {
        // if db fetch fails
        emit(const ErrorOccurredDoctor(error: 'Failed to fetch details!'));
      }
    } on Exception catch (e) {
      if (e is UserNotFoundException) {
        emit(DoctorLoginPageState.noUserFound);
      } else if (e is WrongPasswordException) {
        emit(DoctorLoginPageState.wrongPassword);
      } else {
        emit(DoctorLoginPageState.somethingWentWrong);
      }
    }
  }

  Future<void> _onCheckEmailStatus(
      DoctorCheckEmailStatus event, Emitter<DoctorAppState> emit) async {
    // emit loading
    emit(const DoctorEmailInputState(emailStatus: EmailStatus.loading));
    try {
      // Try to login with the email provided with null as password
      // This will throw an exception
      await _doctorAuthRepository.logInWithCredentials(event.email, 'null');
    } on Exception catch (e) {
      if (e is UserNotFoundException) {
        // This means there was no existing user found for that email
        // Hence, the email is valid
        emit(const DoctorEmailInputState(emailStatus: EmailStatus.valid));
      } else {
        emit(const DoctorEmailInputState(emailStatus: EmailStatus.invalid));
      }
    }
  }

  // When the User Signs up
  FutureOr<void> _onSignupUser(DoctorSignup event, Emitter<DoctorAppState> emit) async {
    emit(DoctorSignupPageState.loading);
    try {
      // Signup using email and password
      doctor = await _doctorAuthRepository.signUpUsingCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = DoctorDatabaseRepository(uid: doctor.uid);
      // Upload Profile Pic
      String photoUrl = '';
      if (event.profilePic != null) {
        // Upload new image to Firebase storage
        String? res = await _databaseRepository.uploadFile(event.profilePic!);
        if (res != null) {
          photoUrl = res;
        } else {
          // Default profile pic
          photoUrl =
              'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg';
        }
      } else {
        // Default profile pic
        photoUrl =
            'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg';
      }
      print(photoUrl);

      // Generate uuid
      const uuid = Uuid();
      String id = uuid.v1().substring(0, 6);

      // Add User details to db
      Doctor newUserData = Doctor(
        uid: doctor.uid,
        email: event.email,
        name: event.name,
        doctorId: id,
        hospital: event.hospital,
        profilePic: photoUrl,
        qualification: event.qualification,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDoctor', true);

      _databaseRepository.updateDoctorData(newUserData);
      doctor = newUserData;
      emit(AuthenticatedDoctor(doctor: doctor));
    } on Exception catch (e) {
      print(e);
      if (e is EmailAlreadyInUseException) {
        emit(DoctorSignupPageState.userAlreadyExists);
      } else {
        emit(DoctorSignupPageState.somethingWentWrong);
      }
    }
  }

  FutureOr<void> _onUpdateUserData(
      UpdateDoctorData event, Emitter<DoctorAppState> emit) async {
    emit(UninitializedDoctor(doctor: Doctor.empty));
  }

  FutureOr<void> _onLoggedOut(DoctorLoggedOut event, Emitter<DoctorAppState> emit) async {
    emit(UninitializedDoctor(doctor: Doctor.empty));
    doctor = Doctor.empty;
    _databaseRepository = DoctorDatabaseRepository(uid: doctor.uid);
    // updateDatabaseBloc();
    await _doctorAuthRepository.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isDoctor');
    emit(UnauthenticatedDoctor(doctor: doctor));
  }
}
