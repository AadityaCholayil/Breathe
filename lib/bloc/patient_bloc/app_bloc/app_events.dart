import 'dart:io';

import 'package:breathe/models/doctor.dart';
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

class GetDoctorDetails extends PatientAppEvent {
  final String doctorId;

  const GetDoctorDetails({required this.doctorId});

  @override
  String toString() => 'PatientCheckEmailStatus';

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
  final Doctor doctor;
  final File? profilePic;

  const PatientSignup({
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.gender,
    required this.doctor,
    required this.profilePic,
  });

  @override
  String toString() => 'PatientSignup($email, $password, $name, $age, $gender)';

  @override
  List<Object?> get props => [email, password, name, age, gender, profilePic];
}

class UpdatePatientData extends PatientAppEvent {
  // final Patient userData;
  final String name;
  final int age;
  final String gender;
  // final File? profilePic;

  const UpdatePatientData({
    required this.name,
    required this.age,
    required this.gender,
  });

  @override
  String toString() => 'UpdatePatientData($name, $age, $gender)';

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
