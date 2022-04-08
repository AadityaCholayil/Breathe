import 'dart:async';
import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/custom_exceptions.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/repositories/patient_auth_repository.dart';
import 'package:breathe/repositories/patient_database_repository.dart';
import 'package:breathe/repositories/patient_chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientAppBloc extends Bloc<PatientAppEvent, PatientAppState> {
  final PatientAuthRepository _authRepository;
  late PatientDatabaseRepository _databaseRepository;
  PatientChatRepository _chatRepository =
      PatientChatRepository(doctor: Doctor.empty);
  late Patient patient;
  late PatientDatabaseBloc databaseBloc;

  PatientAppBloc({required authRepository})
      : _authRepository = authRepository,
        super(UninitializedPatient(patient: Patient.empty)) {
    patient = _authRepository.getUserData;
    _databaseRepository = PatientDatabaseRepository(uid: patient.uid);
    on<PatientAppStarted>(_onAppStarted);
    on<PatientLoginUser>(_onLoginUser);
    on<GetDoctorDetails>(_onGetDoctorDetails);
    on<PatientCheckEmailStatus>(_onCheckEmailStatus);
    on<PatientSignup>(_onSignupUser);
    on<UpdatePatientData>(_onUpdateUserData);
    on<PatientLoggedOut>(_onLoggedOut);
  }

  // When the App Starts
  FutureOr<void> _onAppStarted(
      PatientAppStarted event, Emitter<PatientAppState> emit) async {
    emit(UninitializedPatient(patient: Patient.empty));
    try {
      patient = _authRepository.getUserData;
      if (patient != Patient.empty) {
        // Authenticated
        // Update DatabaseRepository
        _databaseRepository = PatientDatabaseRepository(uid: patient.uid);
        // Fetch rest of the user details from database
        Patient completeUserData =
            await _databaseRepository.completePatientData;
        if (completeUserData != Patient.empty) {
          // if db fetch is successful
          patient = completeUserData;
          emit(AuthenticatedPatient(patient: patient));
        } else {
          // if db fetch fails
          emit(const ErrorOccurredPatient(error: 'Failed to fetch details!'));
        }
      } else {
        emit(UnauthenticatedPatient(patient: patient));
      }
    } on Exception catch (e) {
      // If something goes wrong
      emit(ErrorOccurredPatient(error: e.toString()));
    }
  }

  // When the User Logs in
  FutureOr<void> _onLoginUser(
      PatientLoginUser event, Emitter<PatientAppState> emit) async {
    emit(PatientLoginPageState.loading);
    try {
      // Login using email and password
      patient = await _authRepository.logInWithCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = PatientDatabaseRepository(uid: patient.uid);
      // After login fetch rest of the user details from database
      Patient completeUserData = await _databaseRepository.completePatientData;
      if (completeUserData != Patient.empty) {
        // if db fetch is successful
        patient = completeUserData;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isDoctor', false);
        emit(AuthenticatedPatient(patient: patient));
      } else {
        // if db fetch fails
        emit(const ErrorOccurredPatient(error: 'Failed to fetch details!'));
      }
    } on Exception catch (e) {
      print(e);
      if (e is UserNotFoundException) {
        emit(PatientLoginPageState.noUserFound);
      } else if (e is WrongPasswordException) {
        emit(PatientLoginPageState.wrongPassword);
      } else {
        emit(PatientLoginPageState.somethingWentWrong);
      }
    }
  }

  Future<void> _onGetDoctorDetails(
      GetDoctorDetails event, Emitter<PatientAppState> emit) async {
    // emit loading
    emit(const DoctorLinkingPageState(pageState: PageState.loading));
    try {
      Doctor? doctor = await _databaseRepository.getDoctorData(event.doctorId);
      if (doctor == null) {
        emit(const DoctorLinkingPageState(pageState: PageState.error));
      } else {
        emit(DoctorLinkingPageState(
            doctor: doctor, pageState: PageState.success));
      }
    } on Exception catch (_) {
      emit(const DoctorLinkingPageState(pageState: PageState.error));
    }
  }

  Future<void> _onCheckEmailStatus(
      PatientCheckEmailStatus event, Emitter<PatientAppState> emit) async {
    // emit loading
    emit(const PatientEmailInputState(emailStatus: EmailStatus.loading));
    try {
      // Try to login with the email provided with null as password
      // This will throw an exception
      await _authRepository.logInWithCredentials(event.email, 'null');
    } on Exception catch (e) {
      if (e is UserNotFoundException) {
        // This means there was no existing user found for that email
        // Hence, the email is valid
        emit(const PatientEmailInputState(emailStatus: EmailStatus.valid));
      } else {
        emit(const PatientEmailInputState(emailStatus: EmailStatus.invalid));
      }
    }
  }

  // When the User Signs up
  FutureOr<void> _onSignupUser(
      PatientSignup event, Emitter<PatientAppState> emit) async {
    emit(PatientSignupPageState.loading);
    try {
      // Signup using email and password
      patient = await _authRepository.signUpUsingCredentials(
          event.email, event.password);
      // Update DatabaseRepository
      _databaseRepository = PatientDatabaseRepository(uid: patient.uid);
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
      print('Uploaded to ' + photoUrl);

      _chatRepository = PatientChatRepository(doctor: event.doctor);
      Timestamp now = Timestamp.now();
      // Send Message
      Message message = Message(
        content: 'Paired!',
        patientUid: patient.uid,
        doctorUid: event.doctor.uid,
        timestamp: now,
        sentByDoctor: false,
        isSpecial: true,
      );
      message = await _chatRepository.sendMessage(message);

      // Add User details to db
      Patient newUserData = Patient(
        uid: patient.uid,
        email: event.email,
        name: event.name,
        age: event.age,
        gender: event.gender,
        doctorId: event.doctor.doctorId,
        hospital: event.doctor.hospital,
        doctorName: event.doctor.name,
        profilePic: photoUrl,
        lastMessageContents: 'Paired!',
        unreadMessages: 1,
        lastMessageTimestamp: now,
        patientLastOpened: now,
        doctorLastOpened: now,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDoctor', false);

      _databaseRepository.updatePatientData(newUserData);
      patient = newUserData;

      emit(AuthenticatedPatient(patient: patient));
    } on Exception catch (e) {
      print(e);
      if (e is EmailAlreadyInUseException) {
        emit(PatientSignupPageState.userAlreadyExists);
      } else {
        emit(PatientSignupPageState.somethingWentWrong);
      }
    }
  }

  FutureOr<void> _onUpdateUserData(
      UpdatePatientData event, Emitter<PatientAppState> emit) async {
    emit(UninitializedPatient(patient: Patient.empty));
  }

  FutureOr<void> _onLoggedOut(
      PatientLoggedOut event, Emitter<PatientAppState> emit) async {
    emit(UninitializedPatient(patient: Patient.empty));
    patient = Patient.empty;
    _databaseRepository = PatientDatabaseRepository(uid: patient.uid);
    // updateDatabaseBloc();
    await _authRepository.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isDoctor');
    emit(UnauthenticatedPatient(patient: patient));
  }
}
