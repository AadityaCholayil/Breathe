import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class DoctorDatabaseState extends Equatable {
  const DoctorDatabaseState();

  @override
  List<Object?> get props => [];
}

class DoctorInit extends DoctorDatabaseState {
  @override
  List<Object?> get props => ['Init'];
}

class DoctorHomePageState extends DoctorDatabaseState {
  final List<Patient> patientList;
  final PageState pageState;

  const DoctorHomePageState({
    this.patientList = const [],
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [patientList, pageState];
}

class DoctorChatPageState extends DoctorDatabaseState {
  final List<Message> messages;
  final PageState pageState;

  const DoctorChatPageState({
    this.messages = const [],
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [messages, pageState];
}

class SessionReportPageState extends DoctorDatabaseState {
  final SessionReport? report;
  final PageState pageState;

  const SessionReportPageState({
    this.report,
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [report, pageState];
}

// class HomePageState extends DatabaseState {
//   final List<RaidBoss>? raidBossList;
//   final PageState pageState;
//
//   const HomePageState({this.raidBossList, required this.pageState});
//
//   @override
//   List<Object?> get props => [raidBossList, pageState];
// }
