import 'dart:io';

import 'package:breathe/models/patient.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DoctorAppEvent extends Equatable {
  const DoctorAppEvent([List props = const []]) : super();
}

class DoctorAppStarted extends DoctorAppEvent {
  @override
  String toString() => 'DoctorAppStarted';

  @override
  List<Object?> get props => [toString()];
}

class DoctorLogin extends DoctorAppEvent {
  final String email;
  final String password;

  const DoctorLogin({required this.email, required this.password});

  @override
  String toString() => 'DoctorLogin';

  @override
  List<Object?> get props => [toString()];
}

class DoctorCheckEmailStatus extends DoctorAppEvent {
  final String email;

  const DoctorCheckEmailStatus({required this.email});

  @override
  String toString() => 'DoctorCheckEmailStatus';

  @override
  List<Object?> get props => [toString()];
}

class DoctorSignup extends DoctorAppEvent {
  final String email;
  final String password;
  final String name;
  final String hospital;
  final File? profilePic;
  final String qualification;

  const DoctorSignup({
    required this.email,
    required this.password,
    required this.name,
    required this.hospital,
    required this.profilePic,
    required this.qualification,
  });

  @override
  String toString() =>
      'DoctorSignup($email, $password, $name, $hospital, $qualification)';

  @override
  List<Object?> get props =>
      [email, password, name, hospital, profilePic, qualification];
}

class UpdateDoctorData extends DoctorAppEvent {
  final Patient userData;

  const UpdateDoctorData(this.userData);

  @override
  String toString() => 'UpdateDoctorData($userData)';

  @override
  List<Object?> get props => [toString()];
}

class DoctorLoggedOut extends DoctorAppEvent {
  @override
  String toString() => 'DoctorLoggedOut';

  @override
  List<Object?> get props => [toString()];
}

class DeleteDoctorData extends DoctorAppEvent {
  final String email;
  final String password;

  const DeleteDoctorData({required this.email, required this.password});

  @override
  String toString() => 'DeleteDoctorData';

  @override
  List<Object?> get props => [toString()];
}
