import 'package:breathe/bloc/doctor_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/repositories/doctor_auth_repository.dart';
import 'package:breathe/repositories/doctor_database_repository.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/doctor/doctor_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorApp extends StatefulWidget {
  const DoctorApp({Key? key}) : super(key: key);

  @override
  _DoctorAppState createState() => _DoctorAppState();
}

class _DoctorAppState extends State<DoctorApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DoctorAuthRepository>(
      create: (context) => DoctorAuthRepository(),
      child: BlocProvider<DoctorAppBloc>(
        create: (context) {
          DoctorAppBloc appBloc = DoctorAppBloc(
              authRepository: context.read<DoctorAuthRepository>());
          appBloc.add(DoctorAppStarted());
          return appBloc;
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<DoctorAppBloc, DoctorAppState>(
              builder: (context, state) {
                Doctor doctor = context.read<DoctorAppBloc>().doctor;
                DoctorDatabaseBloc databaseBloc = DoctorDatabaseBloc(
                  doctor: doctor,
                  databaseRepository:
                      DoctorDatabaseRepository(uid: doctor.uid),
                );
                return BlocProvider<DoctorDatabaseBloc>.value(
                  value: databaseBloc,
                  child: ScreenUtilInit(
                    designSize: const Size(414, 896),
                    builder: () {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: CustomTheme.getTheme(context),
                        home: DoctorWrapper(state: state),
                        builder: (context, child) {
                          int width = MediaQuery.of(context).size.width.toInt();
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: width / 414),
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
