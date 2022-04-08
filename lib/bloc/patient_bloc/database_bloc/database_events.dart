import 'package:breathe/models/session_report.dart';
import 'package:equatable/equatable.dart';

abstract class PatientDatabaseEvent extends Equatable {
  const PatientDatabaseEvent();

  @override
  List<Object?> get props => [];
}

class GetTodaysReports extends PatientDatabaseEvent {
  const GetTodaysReports();

  @override
  List<Object?> get props => [];
}

class GetReports extends PatientDatabaseEvent {
  const GetReports();

  @override
  List<Object?> get props => [];
}

class SaveReport extends PatientDatabaseEvent {
  final SessionReport report;

  const SaveReport({required this.report});

  @override
  List<Object?> get props => [report];
}

class DeleteReport extends PatientDatabaseEvent {
  final SessionReport report;

  const DeleteReport({required this.report});

  @override
  List<Object?> get props => [report];
}

class GetMessages extends PatientDatabaseEvent {
  const GetMessages();

  @override
  List<Object?> get props => [];
}

class SendMessage extends PatientDatabaseEvent {
  final String message;

  const SendMessage({required this.message});

  @override
  List<Object?> get props => [];
}
