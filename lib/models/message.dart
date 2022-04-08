import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable{
  final String uid;
  final String content;
  final String doctorUid;
  final String patientUid;
  final Timestamp timestamp;
  final bool sentByDoctor;
  final bool isSpecial;
  final bool seen;
  final bool sent;

  const Message({
    this.uid = '',
    this.content = '',
    this.doctorUid = '',
    this.patientUid = '',
    required this.timestamp,
    this.sentByDoctor = false,
    this.isSpecial = false,
    this.seen = false,
    this.sent = false,
  });

  static Message empty = Message(uid: '', timestamp: Timestamp(0, 0));

  Message.fromJson(Map<String, dynamic> json)
      : this(
    uid: json['uid'],
    content: json['content'],
    doctorUid: json['doctorUid'],
    patientUid: json['patientUid'],
    timestamp: json['timestamp'],
    sentByDoctor: json['sentByDoctor'],
    isSpecial: json['isSpecial'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['content'] = content;
    data['doctorUid'] = doctorUid;
    data['patientUid'] = patientUid;
    data['timestamp'] = timestamp;
    data['sentByDoctor'] = sentByDoctor;
    data['isSpecial'] = isSpecial;
    return data;
  }

  Message copyWith({String? uid, bool? seen, bool? sent}){
    return Message(
      uid: uid ?? this.uid,
      content: content,
      doctorUid: doctorUid,
      patientUid: patientUid,
      timestamp: timestamp,
      sentByDoctor: sentByDoctor,
      isSpecial: isSpecial,
      seen: seen ?? this.seen,
      sent: sent ?? this.sent,
    );
  }

  bool get isEmpty => this == Message.empty;

  bool get isNotEmpty => this != Message.empty;

  @override
  String toString() {
    return 'Message($uid, $content, $doctorUid, $patientUid, $seen, $timestamp, $sentByDoctor, $isSpecial)';
  }

  @override
  List<Object?> get props => [
    uid,
    content,
    doctorUid,
    patientUid,
    timestamp,
    sentByDoctor,
    isSpecial,
    seen,
    sent,
  ];
}

enum MessageType{received, sent, special}