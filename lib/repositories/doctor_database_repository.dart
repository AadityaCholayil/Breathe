import 'dart:io';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DoctorDatabaseRepository {
  final String uid;

  DoctorDatabaseRepository({required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Doctors Collection Reference
  // Reference allows for easy from and to operations
  CollectionReference<Doctor> get doctorsRef =>
      db.collection('doctors').withConverter<Doctor>(
            fromFirestore: (snapshot, _) => Doctor.fromJson(snapshot.data()!),
            toFirestore: (doctor, _) => doctor.toJson(),
          );

  // Get DoctorData from DB
  Future<Doctor> get completeDoctorData async {
    try {
      Doctor doctorDataNew = await doctorsRef
          .doc(uid)
          .get()
          .then((value) => value.data() ?? Doctor.empty);
      return doctorDataNew;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return Doctor.empty;
    }
  }

  // Update DoctorData in DB
  Future<void> updateDoctorData(Doctor doctorData) async {
    await doctorsRef.doc(uid).set(doctorData);
  }

  // Delete DoctorData from db
  Future<void> deleteDoctor() async {
    await doctorsRef.doc(uid).delete();
  }

  // Report Collection Reference for specific doctor
  CollectionReference<Patient> get patientsRef => db
      .collection('patients')
      .withConverter<Patient>(
        fromFirestore: (snapshot, a) =>
            Patient.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );

  // Get Today's Reports from db
  Future<List<Patient>> getPatients(String doctorId) async {
    List<QueryDocumentSnapshot<Patient>> list = [];
    String todaysDate = getDateFromDateTime(DateTime.now());
    list = await patientsRef
        .where('doctorId', isEqualTo: doctorId)
        .get()
        .then((snapshot) => snapshot.docs);
    return list.map((e) => e.data()).toList();
  }

  // // Add Reports to db
  // Future<void> addReport(SessionReport report) async {
  //   await patientsRef.add(report);
  // }
  //
  // // Delete Report from db
  // Future<void> deleteReport(SessionReport report) async {
  //   await patientsRef.doc(report.id).delete();
  // }

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(File _image) async {
    try {
      await storage.ref('DoctorProfiles/$uid/profile_pic.png').putFile(_image);
      var result = await storage
          .ref('DoctorProfiles/$uid/profile_pic.png')
          .getDownloadURL();
      print('profileUrl: $result');
      return result;
    } on Exception catch (e) {
      print('Failed - $e');
      return null;
    }
  }
}
