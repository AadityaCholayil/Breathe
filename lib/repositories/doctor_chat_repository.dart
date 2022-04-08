import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorChatRepository {
  final Doctor doctor;

  DoctorChatRepository({required this.doctor});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Patient> get patientsRef =>
      db.collection('patients').withConverter<Patient>(
            fromFirestore: (snapshot, _) => Patient.fromJson(snapshot.data()!),
            toFirestore: (patient, _) => patient.toJson(),
          );

  Stream<List<Patient>> patientsStream() {
    return patientsRef
        .where('doctorId', isEqualTo: doctor.doctorId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  CollectionReference<Message> get messagesRef =>
      db.collection('messages').withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
            toFirestore: (message, _) => message.toJson(),
          );

  Stream<List<Message>> messagesStream(Patient patient) {
    return messagesRef
        .where('doctorUid', isEqualTo: doctor.uid)
        .where('patientUid', isEqualTo: patient.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  void sendMessage(Message message) async {
    await messagesRef.add(message);
  }
}
