import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Patient extends Equatable {
  final String uid;
  final String email;
  final String name;
  final int age;
  final String gender;
  final String doctorId;
  final String healthStatus;
  final String doctorName;
  final String hospital;
  final String profilePic;
  final String lastMessageContents;
  final Timestamp lastMessageTimestamp;
  final Timestamp patientLastOpened;
  final Timestamp doctorLastOpened;

  const Patient({
    this.uid = '',
    this.email = '',
    this.name = '',
    this.age = 0,
    this.gender = '',
    this.doctorId = '',
    this.healthStatus = '',
    this.doctorName = '',
    this.hospital = '',
    this.profilePic = '',
    this.lastMessageContents = '',
    required this.lastMessageTimestamp,
    required this.patientLastOpened,
    required this.doctorLastOpened,
  });

  static Patient fromUser(User user) {
    return Patient(
        uid: user.uid,
        email: user.email ?? '',
        patientLastOpened: Timestamp.now(),
        doctorLastOpened: Timestamp.now(),
        lastMessageTimestamp: Timestamp.now());
  }

  static Patient empty = Patient(
      uid: '',
      lastMessageTimestamp: Timestamp(0, 0),
      patientLastOpened: Timestamp(0, 0),
      doctorLastOpened: Timestamp(0, 0));

  Patient.fromJson(Map<String, dynamic> json)
      : this(
          uid: json['uid'],
          email: json['email'],
          name: json['name'],
          age: json['age'],
          gender: json['gender'],
          doctorId: json['doctorId'],
          healthStatus: json['healthStatus'],
          doctorName: json['doctorName'],
          hospital: json['hospital'],
          profilePic: json['profilePic'],
          lastMessageContents: json['lastMessageContents'],
          lastMessageTimestamp: json['lastMessageTimestamp'],
          patientLastOpened: json['patientLastOpened'],
          doctorLastOpened: json['doctorLastOpened'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['doctorId'] = doctorId;
    data['healthStatus'] = healthStatus;
    data['doctorName'] = doctorName;
    data['hospital'] = hospital;
    data['profilePic'] = profilePic;
    data['lastMessageContents'] = lastMessageContents;
    data['lastMessageTimestamp'] = lastMessageTimestamp;
    data['patientLastOpened'] = patientLastOpened;
    data['doctorLastOpened'] = doctorLastOpened;
    return data;
  }

  bool get isEmpty => this == Patient.empty;

  bool get isNotEmpty => this != Patient.empty;

  @override
  String toString() {
    return 'Patient($uid, $email, $name, $age, $gender, $doctorId, $healthStatus, $doctorName, $hospital, $profilePic, $lastMessageContents, $lastMessageTimestamp, $patientLastOpened, $doctorLastOpened)';
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        age,
        gender,
        doctorId,
        healthStatus,
        doctorName,
        hospital,
        profilePic,
        lastMessageContents,
    lastMessageTimestamp,
        patientLastOpened,
        doctorLastOpened,
      ];
}
