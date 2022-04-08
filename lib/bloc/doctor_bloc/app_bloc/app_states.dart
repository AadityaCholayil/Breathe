import 'package:breathe/models/doctor.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DoctorAppState extends Equatable {
  const DoctorAppState([List props = const []]) : super();
}

class UninitializedDoctor extends DoctorAppState {
  final Doctor doctor;

  const UninitializedDoctor({required this.doctor});

  @override
  String toString() => 'UninitializedDoctor';

  @override
  List<Object?> get props => [toString()];
}

class UnauthenticatedDoctor extends DoctorAppState {
  final Doctor doctor;

  const UnauthenticatedDoctor({required this.doctor});

  @override
  String toString() => 'UnauthenticatedDoctor';

  @override
  List<Object?> get props => [toString()];
}

class AuthenticatedDoctor extends DoctorAppState {
  final Doctor doctor;

  const AuthenticatedDoctor({required this.doctor});

  @override
  String toString() => 'AuthenticatedDoctor';

  @override
  List<Object?> get props => [toString()];
}

class ErrorOccurredDoctor extends DoctorAppState {
  final String error;

  const ErrorOccurredDoctor({required this.error});

  @override
  String toString() => 'ErrorOccurredDoctor';

  @override
  List<Object?> get props => [toString()];
}

class DoctorLoginPageState extends DoctorAppState {
  final String message;

  const DoctorLoginPageState({required this.message});

  static DoctorLoginPageState loading = const DoctorLoginPageState(message: 'Loading');

  static DoctorLoginPageState success = const DoctorLoginPageState(message: 'Successful');

  static DoctorLoginPageState noUserFound =
      const DoctorLoginPageState(message: 'No user found for that email');

  static DoctorLoginPageState wrongPassword =
      const DoctorLoginPageState(message: 'Wrong Password provided for that user');

  static DoctorLoginPageState somethingWentWrong =
      const DoctorLoginPageState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class DoctorEmailInputState extends DoctorAppState {
  final EmailStatus emailStatus;

  const DoctorEmailInputState({required this.emailStatus});

  @override
  List<Object?> get props => [emailStatus];
}

enum EmailStatus {
  loading,
  valid,
  invalid,
}

class DoctorSignupPageState extends DoctorAppState {
  final String message;

  const DoctorSignupPageState({required this.message});

  static DoctorSignupPageState loading = const DoctorSignupPageState(message: 'Loading');

  static DoctorSignupPageState success = const DoctorSignupPageState(message: 'Successful');

  static DoctorSignupPageState userAlreadyExists =
      const DoctorSignupPageState(message: 'Email is already in use');

  static DoctorSignupPageState somethingWentWrong =
      const DoctorSignupPageState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class DeleteDoctorAccountPageState extends DoctorAppState {
  final String message;

  const DeleteDoctorAccountPageState({required this.message});

  static DeleteDoctorAccountPageState loading =
      const DeleteDoctorAccountPageState(message: 'Loading');

  static DeleteDoctorAccountPageState invalidCredentials =
      const DeleteDoctorAccountPageState(message: 'Invalid Credentials!');

  static DeleteDoctorAccountPageState somethingWentWrong =
      const DeleteDoctorAccountPageState(
          message: 'Something went wrong, Please try again');

  static DeleteDoctorAccountPageState success =
      const DeleteDoctorAccountPageState(message: 'Success!');

  @override
  String toString() => 'DeleteAccountPageState';

  @override
  List<Object?> get props => [toString() + message];
}
