import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/user.dart';
import 'package:breathe/repositories/auth_repository.dart';
import 'package:breathe/repositories/database_repository.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<AppBloc>(
        create: (context) {
          AppBloc appBloc =
              AppBloc(authRepository: context.read<AuthRepository>());
          appBloc.add(AppStarted());
          return appBloc;
        },
        child: Builder(
          builder: (context) {
            return BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return BlocProvider<DatabaseBloc>(
                  create: (context) {
                    UserData userData = context.read<AppBloc>().userData;
                    return DatabaseBloc(
                      userData: userData,
                      databaseRepository: DatabaseRepository(uid: userData.uid),
                    );
                  },
                  child: ScreenUtilInit(
                    designSize: const Size(414, 896),
                    builder: () {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: CustomTheme.getTheme(context),
                        home: SafeArea(
                          child: Wrapper(state: state),
                        ),
                        builder: (context, child) {
                          int width =
                          MediaQuery.of(context).size.width.toInt();
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
