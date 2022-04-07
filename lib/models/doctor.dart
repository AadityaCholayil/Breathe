import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Doctor extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String doctorId;
  final String hospital;
  final String profilePic;
  final String qualification;

  const Doctor({
    this.uid = '',
    this.email = '',
    this.name = '',
    this.doctorId = '',
    this.hospital = '',
    this.profilePic = '',
    this.qualification = '',
  });

  static Doctor fromUser(User user) {
    return Doctor(uid: user.uid, email: user.email ?? '');
  }

  static Doctor empty = const Doctor(uid: '');

  Doctor.fromJson(Map<String, dynamic> json)
      : this(
          uid: json['uid'],
          email: json['email'],
          name: json['name'],
          doctorId: json['doctorId'],
          hospital: json['hospital'],
          profilePic: json['profilePic'],
          qualification: json['qualification'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['name'] = name;
    data['doctorId'] = doctorId;
    data['hospital'] = hospital;
    data['profilePic'] = profilePic;
    data['qualification'] = qualification;
    return data;
  }

  bool get isEmpty => this == Doctor.empty;

  bool get isNotEmpty => this != Doctor.empty;

  @override
  String toString() {
    return 'Doctor($uid, $email, $name, $doctorId, $hospital, $profilePic, $qualification)';
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        doctorId,
        hospital,
        profilePic,
        qualification,
      ];
}
