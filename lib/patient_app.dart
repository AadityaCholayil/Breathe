import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/repositories/patient_auth_repository.dart';
import 'package:breathe/repositories/patient_database_repository.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/patient_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientApp extends StatefulWidget {
  const PatientApp({Key? key}) : super(key: key);

  @override
  _PatientAppState createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PatientAuthRepository>(
      create: (context) => PatientAuthRepository(),
      child: BlocProvider<PatientAppBloc>(
        create: (context) {
          PatientAppBloc appBloc =
              PatientAppBloc(authRepository: context.read<PatientAuthRepository>());
          appBloc.add(PatientAppStarted());
          return appBloc;
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<PatientAppBloc, PatientAppState>(
              builder: (context, state) {
                Patient userData = context.read<PatientAppBloc>().patient;
                PatientDatabaseBloc databaseBloc = PatientDatabaseBloc(
                  patient: userData,
                  databaseRepository: PatientDatabaseRepository(uid: userData.uid),
                );
                return BlocProvider<PatientDatabaseBloc>.value(
                  value: databaseBloc,
                  child: ScreenUtilInit(
                    designSize: const Size(414, 896),
                    builder: () {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: CustomTheme.getTheme(context),
                        home: PatientWrapper(state: state),
                        builder: (context, child) {
                          int width = MediaQuery.of(context).size.width.toInt();
                          return MediaQuery(
                            data:
                            MediaQuery.of(context).copyWith(textScaleFactor: width / 414),
                            child: child ?? const SomethingWentWrong(),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
