import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class Init extends DatabaseState {
  @override
  List<Object?> get props => ['Init'];
}

class HomePageState extends DatabaseState {
  final List<SessionReport> reportList;
  final PageState pageState;

  const HomePageState({
    this.reportList = const [],
    this.pageState = PageState.loading,
  });

  @override
  List<Object?> get props => [reportList, pageState];
}

class SessionReportPageState extends DatabaseState {
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
