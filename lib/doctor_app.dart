import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/user.dart';
import 'package:breathe/repositories/auth_repository.dart';
import 'package:breathe/repositories/database_repository.dart';
import 'package:breathe/views/patient/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorApp extends StatefulWidget {
  const DoctorApp({Key? key}) : super(key: key);

  @override
  _DoctorAppState createState() => _DoctorAppState();
}

class _DoctorAppState extends State<DoctorApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<PatientAppBloc>(
        create: (context) {
          PatientAppBloc appBloc =
              PatientAppBloc(authRepository: context.read<AuthRepository>());
          appBloc.add(AppStarted());
          return appBloc;
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<PatientAppBloc, AppState>(
              builder: (context, state) {
                UserData userData = context.read<PatientAppBloc>().userData;
                DatabaseBloc databaseBloc = DatabaseBloc(
                  userData: userData,
                  databaseRepository: DatabaseRepository(uid: userData.uid),
                );
                return BlocProvider<DatabaseBloc>.value(
                  value: databaseBloc,
                  child: Wrapper(state: state),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
