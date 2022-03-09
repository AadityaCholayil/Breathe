import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData extends Equatable {
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

  const UserData({
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
  });

  static UserData fromUser(User user) {
    return UserData(uid: user.uid, email: user.email ?? '');
  }

  static UserData empty = const UserData(uid: '');

  UserData.fromJson(Map<String, dynamic> json)
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
    return data;
  }

  bool get isEmpty => this == UserData.empty;

  bool get isNotEmpty => this != UserData.empty;

  @override
  String toString() {
    return 'UserData($uid, $email, $name, $age, $gender, $doctorId, $healthStatus, $doctorName, $hospital, $profilePic)';
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
      ];
}
