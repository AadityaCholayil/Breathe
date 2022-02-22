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

// class HomePageState extends DatabaseState {
//   final List<RaidBoss>? raidBossList;
//   final PageState pageState;
//
//   const HomePageState({this.raidBossList, required this.pageState});
//
//   @override
//   List<Object?> get props => [raidBossList, pageState];
// }