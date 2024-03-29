import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientChatRepository {
  final Doctor doctor;
  final Patient patient;

  PatientChatRepository({required this.doctor, required this.patient,});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Patient> get patientsRef =>
      db.collection('patients').withConverter<Patient>(
            fromFirestore: (snapshot, _) => Patient.fromJson(snapshot.data()!),
            toFirestore: (patient, _) => patient.toJson(),
          );

  CollectionReference<Doctor> get doctorsRef =>
      db.collection('doctors').withConverter<Doctor>(
            fromFirestore: (snapshot, _) => Doctor.fromJson(snapshot.data()!),
            toFirestore: (doctor, _) => doctor.toJson(),
          );

  CollectionReference<Message> get messagesRef =>
      db.collection('messages').withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
            toFirestore: (message, _) => message.toJson(),
          );

  Stream<List<Message>> messagesStream() {
    return messagesRef
        .where('doctorUid', isEqualTo: doctor.uid)
        .where('patientUid', isEqualTo: patient.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<Message> sendMessage(Message message) async {
    var res = await messagesRef.add(message);
    return message.copyWith(uid: res.id);
  }
}
