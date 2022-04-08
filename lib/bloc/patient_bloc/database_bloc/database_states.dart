import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class PatientDatabaseState extends Equatable {
  const PatientDatabaseState();

  @override
  List<Object?> get props => [];
}

class PatientInit extends PatientDatabaseState {
  @override
  List<Object?> get props => ['Init'];
}

class PatientHomePageState extends PatientDatabaseState {
  final List<SessionReport> reportList;
  final PageState pageState;

  const PatientHomePageState({
    this.reportList = const [],
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [reportList, pageState];
}

class SessionReportPageState extends PatientDatabaseState {
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