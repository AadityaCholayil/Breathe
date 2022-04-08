import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:breathe/models/patient.dart';

@immutable
abstract class PatientAppState extends Equatable {
  const PatientAppState([List props = const []]) : super();
}

class UninitializedPatient extends PatientAppState {
  final Patient patient;

  const UninitializedPatient({required this.patient});

  @override
  String toString() => 'UninitializedPatient';

  @override
  List<Object?> get props => [toString()];
}

class UnauthenticatedPatient extends PatientAppState {
  final Patient patient;

  const UnauthenticatedPatient({required this.patient});

  @override
  String toString() => 'UnauthenticatedPatient';

  @override
  List<Object?> get props => [toString()];
}

class AuthenticatedPatient extends PatientAppState {
  final Patient patient;

  const AuthenticatedPatient({required this.patient});

  @override
  String toString() => 'AuthenticatedPatient';

  @override
  List<Object?> get props => [toString()];
}

class ErrorOccurredPatient extends PatientAppState {
  final String error;

  const ErrorOccurredPatient({required this.error});

  @override
  String toString() => 'ErrorOccurredPatient';

  @override
  List<Object?> get props => [toString()];
}

class PatientLoginPageState extends PatientAppState {
  final String message;

  const PatientLoginPageState({required this.message});

  static PatientLoginPageState loading =
      const PatientLoginPageState(message: 'Loading');

  static PatientLoginPageState success =
      const PatientLoginPageState(message: 'Successful');

  static PatientLoginPageState noUserFound =
      const PatientLoginPageState(message: 'No user found for that email');

  static PatientLoginPageState wrongPassword = const PatientLoginPageState(
      message: 'Wrong Password provided for that user');

  static PatientLoginPageState somethingWentWrong = const PatientLoginPageState(
      message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class DoctorLinkingPageState extends PatientAppState {
  final Doctor? doctor;
  final PageState pageState;

  const DoctorLinkingPageState({
    this.doctor,
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [doctor, pageState];
}

class PatientEmailInputState extends PatientAppState {
  final EmailStatus emailStatus;

  const PatientEmailInputState({required this.emailStatus});

  @override
  List<Object?> get props => [emailStatus];
}

enum EmailStatus {
  loading,
  valid,
  invalid,
}

class PatientSignupPageState extends PatientAppState {
  final String message;

  const PatientSignupPageState({required this.message});

  static PatientSignupPageState loading =
      const PatientSignupPageState(message: 'Loading');

  static PatientSignupPageState success =
      const PatientSignupPageState(message: 'Successful');

  static PatientSignupPageState userAlreadyExists =
      const PatientSignupPageState(message: 'Email is already in use');

  static PatientSignupPageState somethingWentWrong =
      const PatientSignupPageState(
          message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class DeletePatientAccountPageState extends PatientAppState {
  final String message;

  const DeletePatientAccountPageState({required this.message});

  static DeletePatientAccountPageState loading =
      const DeletePatientAccountPageState(message: 'Loading');

  static DeletePatientAccountPageState invalidCredentials =
      const DeletePatientAccountPageState(message: 'Invalid Credentials!');

  static DeletePatientAccountPageState somethingWentWrong =
      const DeletePatientAccountPageState(
          message: 'Something went wrong, Please try again');

  static DeletePatientAccountPageState success =
      const DeletePatientAccountPageState(message: 'Success!');

  @override
  String toString() => 'DeleteAccountPageState';

  @override
  List<Object?> get props => [toString() + message];
}
