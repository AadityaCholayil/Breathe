import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({required this.uid});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Users Collection Reference
  // Reference allows for easy from and to operations
  CollectionReference<UserData> get usersRef =>
      db.collection('users').withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  // Get UserData from DB
  Future<UserData> get completeUserData async {
    try {
      UserData userDataNew = await usersRef
          .doc(uid)
          .get()
          .then((value) => value.data() ?? UserData.empty);
      return userDataNew;
    } on Exception catch (_) {
      // TODO: If this doesn't work, throw SomethingWentWrong()
      return UserData.empty;
    }
  }

  // Update UserData in DB
  Future<void> updateUserData(UserData userData) async {
    await usersRef.doc(uid).set(userData);
  }

  // Delete UserData from db
  Future<void> deleteUser() async {
    await usersRef.doc(uid).delete();
  }

  // Report Collection Reference for specific user
  CollectionReference<SessionReport> get reportsRef => db
      .collection('users')
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
    list = await reportsRef
        .where('date', isEqualTo: getDateFromDateTime(DateTime.now()))
        .orderBy('timestamp')
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
}
