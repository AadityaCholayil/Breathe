import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/views/home_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final AppState state;

  const Wrapper({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is Uninitialized) {
      return const Loading();
    } else if (state is Unauthenticated ||
        state is LoginPageState ||
        state is SignupPageState ||
        state is EmailInputState) {
      return const Loading();
    } else if (state is Authenticated) {
      return const HomePage();
    } else {
      return const Loading();
    }
  }
}