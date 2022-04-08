import 'dart:io';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PatientDatabaseRepository {
  final String uid;

  PatientDatabaseRepository({required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Patients Collection Reference
  // Reference allows for easy from and to operations
  CollectionReference<Patient> get patientsRef =>
      db.collection('patients').withConverter<Patient>(
            fromFirestore: (snapshot, _) => Patient.fromJson(snapshot.data()!),
            toFirestore: (patient, _) => patient.toJson(),
          );

  // Get PatientData from DB
  Future<Patient> get completePatientData async {
    try {
      Patient patientDataNew = await patientsRef
          .doc(uid)
          .get()
          .then((value) => value.data() ?? Patient.empty);
      return patientDataNew;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return Patient.empty;
    }
  }

  // Update PatientData in DB
  Future<void> updatePatientData(Patient patientData) async {
    await patientsRef.doc(uid).set(patientData);
  }

  // Delete PatientData from db
  Future<void> deletePatient() async {
    await patientsRef.doc(uid).delete();
  }

  // Report Collection Reference for specific patient
  CollectionReference<SessionReport> get reportsRef => db
      .collection('patients')
      .doc(uid)
      .collection('reports')
      .withConverter<SessionReport>(
        fromFirestore: (snapshot, a) =>
            SessionReport.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (report, _) => report.toJson(),
      );

  // Get Today's Reports from db
  Future<List<SessionReport>> getTodaysReports() async {
    List<QueryDocumentSnapshot<SessionReport>> list = [];
    String todaysDate = getDateFromDateTime(DateTime.now());
    list = await reportsRef
        .where('date', isEqualTo: todaysDate)
        .orderBy('timeTakenAt')
        .get()
        .then((snapshot) => snapshot.docs);
    return list.map((e) => e.data()).toList();
  }

  // Add Reports to db
  Future<void> addReport(SessionReport report) async {
    await reportsRef.add(report);
  }

  // Delete Report from db
  Future<void> deleteReport(SessionReport report) async {
    await reportsRef.doc(report.id).delete();
  }

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(File _image) async {
    try {
      await storage.ref('PatientProfiles/$uid/profile_pic.png').putFile(_image);
      var result = await storage
          .ref('PatientProfiles/$uid/profile_pic.png')
          .getDownloadURL();
      print('profileUrl: $result');
      return result;
    } on Exception catch (e) {
      print('Failed - $e');
      return null;
    }
  }

  // Doctors Collection Reference
  // Reference allows for easy from and to operations
  CollectionReference<Doctor> get doctorsRef =>
      db.collection('doctors').withConverter<Doctor>(
            fromFirestore: (snapshot, _) => Doctor.fromJson(snapshot.data()!),
            toFirestore: (doctor, _) => doctor.toJson(),
          );

  // Get PatientData from DB
  Future<Doctor?> getDoctorData(String doctorId) async {
    try {
      Doctor? doctor = await doctorsRef
          .where('doctorId', isEqualTo: doctorId)
          .get()
          .then((value) =>
              value.docs.isEmpty ? null : value.docs.first.data());
      return doctor;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return Doctor.empty;
    }
  }
}
