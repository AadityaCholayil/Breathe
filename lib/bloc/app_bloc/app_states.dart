import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:breathe/models/user.dart';

import '../../models/user.dart';

@immutable
abstract class AppState extends Equatable {
  const AppState([List props = const []]) : super();
}

class Uninitialized extends AppState {
  final UserData userData;

  const Uninitialized({required this.userData});

  @override
  String toString() => 'Uninitialized';

  @override
  List<Object?> get props => [toString()];
}

class Unauthenticated extends AppState {
  final UserData userData;

  const Unauthenticated({required this.userData});

  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object?> get props => [toString()];
}

class Authenticated extends AppState {
  final UserData userData;

  const Authenticated({required this.userData});

  @override
  String toString() => 'Authenticated';

  @override
  List<Object?> get props => [toString()];
}

class ErrorOccurred extends AppState {
  final String error;

  const ErrorOccurred({required this.error});

  @override
  String toString() => 'ErrorOccurred';

  @override
  List<Object?> get props => [toString()];
}

class LoginPageState extends AppState {
  final String message;

  const LoginPageState({required this.message});

  static LoginPageState loading = const LoginPageState(message: 'Loading');

  static LoginPageState success = const LoginPageState(message: 'Successful');

  static LoginPageState noUserFound =
      const LoginPageState(message: 'No user found for that email');

  static LoginPageState wrongPassword =
      const LoginPageState(message: 'Wrong Password provided for that user');

  static LoginPageState somethingWentWrong =
      const LoginPageState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class EmailInputState extends AppState {
  final EmailStatus emailStatus;

  const EmailInputState({required this.emailStatus});

  @override
  List<Object?> get props => [emailStatus];
}

enum EmailStatus {
  loading,
  valid,
  invalid,
}

class SignupPageState extends AppState {
  final String message;

  const SignupPageState({required this.message});

  static SignupPageState loading = const SignupPageState(message: 'Loading');

  static SignupPageState success = const SignupPageState(message: 'Successful');

  static SignupPageState userAlreadyExists =
      const SignupPageState(message: 'Email is already in use');

  static SignupPageState somethingWentWrong =
      const SignupPageState(message: 'Something went wrong, Please try again');

  @override
  List<Object?> get props => [message];
}

class DeleteAccountPageState extends AppState {
  final String message;

  const DeleteAccountPageState({required this.message});

  static DeleteAccountPageState loading =
      const DeleteAccountPageState(message: 'Loading');

  static DeleteAccountPageState invalidCredentials =
      const DeleteAccountPageState(message: 'Invalid Credentials!');

  static DeleteAccountPageState somethingWentWrong =
      const DeleteAccountPageState(
          message: 'Something went wrong, Please try again');

  static DeleteAccountPageState success =
      const DeleteAccountPageState(message: 'Success!');

  @override
  String toString() => 'DeleteAccountPageState';

  @override
  List<Object?> get props => [toString() + message];
}
