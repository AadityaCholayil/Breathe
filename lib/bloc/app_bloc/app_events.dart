import 'package:breathe/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppEvent extends Equatable {
  const AppEvent([List props = const []]) : super();
}

class AppStarted extends AppEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object?> get props => [toString()];
}

class LoginUser extends AppEvent {
  final String email;
  final String password;

  const LoginUser({required this.email, required this.password});

  @override
  String toString() => 'LoginUser';

  @override
  List<Object?> get props => [toString()];
}

class CheckEmailStatus extends AppEvent {
  final String email;

  const CheckEmailStatus({required this.email});

  @override
  String toString() => 'CheckEmailStatus';

  @override
  List<Object?> get props => [toString()];
}

class SignupUser extends AppEvent {
  final String email;
  final String password;
  final String name;
  final int age;
  final String gender;
  final String doctorId;

  const SignupUser({
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
    required this.doctorId,
  });

  @override
  String toString() => 'SignupUser($email, $password, $name, $age, $gender, $doctorId)';

  @override
  List<Object?> get props => [email, password, name, age, gender, doctorId];
}

class UpdateUserData extends AppEvent {
  final UserData userData;

  const UpdateUserData(this.userData);

  @override
  String toString() => 'UpdateUserData($userData)';

  @override
  List<Object?> get props => [toString()];
}

class LoggedOut extends AppEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object?> get props => [toString()];
}

class DeleteUser extends AppEvent {
  final String email;
  final String password;

  const DeleteUser({required this.email, required this.password});

  @override
  String toString() => 'DeleteUser';

  @override
  List<Object?> get props => [toString()];
}
