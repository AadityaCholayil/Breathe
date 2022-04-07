import 'dart:io';

import 'package:breathe/models/patient.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PatientAppEvent extends Equatable {
  const PatientAppEvent([List props = const []]) : super();
}

class PatientAppStarted extends PatientAppEvent {
  @override
  String toString() => 'PatientAppStarted';

  @override
  List<Object?> get props => [toString()];
}

class PatientLoginUser extends PatientAppEvent {
  final String email;
  final String password;

  const PatientLoginUser({required this.email, required this.password});

  @override
  String toString() => 'PatientLoginUser';

  @override
  List<Object?> get props => [toString()];
}

class PatientCheckEmailStatus extends PatientAppEvent {
  final String email;

  const PatientCheckEmailStatus({required this.email});

  @override
  String toString() => 'PatientCheckEmailStatus';

  @override
  List<Object?> get props => [toString()];
}

class PatientSignup extends PatientAppEvent {
  final String email;
  final String password;
  final String name;
  final int age;
  final String gender;
  final String doctorId;
  final String hospital;
  final String doctorName;
  final File? profilePic;

  const PatientSignup({
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
    required this.doctorId,
    required this.hospital,
    required this.doctorName,
    required this.profilePic,
  });

  @override
  String toString() =>
      'PatientSignup($email, $password, $name, $age, $gender, $hospital, $doctorName, $doctorId)';

  @override
  List<Object?> get props =>
      [email, password, name, age, gender, doctorId, hospital, doctorName, profilePic];
}

class UpdatePatientData extends PatientAppEvent {
  final Patient userData;

  const UpdatePatientData(this.userData);

  @override
  String toString() => 'UpdatePatientData($userData)';

  @override
  List<Object?> get props => [toString()];
}

class PatientLoggedOut extends PatientAppEvent {
  @override
  String toString() => 'PatientLoggedOut';

  @override
  List<Object?> get props => [toString()];
}

class DeletePatientData extends PatientAppEvent {
  final String email;
  final String password;

  const DeletePatientData({required this.email, required this.password});

  @override
  String toString() => 'DeletePatientData';

  @override
  List<Object?> get props => [toString()];
}
