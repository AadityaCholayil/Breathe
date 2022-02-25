import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/views/auth_screens/welcome_screen.dart';
import 'package:breathe/views/home_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final AppState state;

  const Wrapper({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is Uninitialized) {
      return const LoadingPage();
    } else if (state is Unauthenticated ||
        state is LoginPageState ||
        state is SignupPageState ||
        state is EmailInputState) {
      return const WelcomeScreen();
    } else if (state is Authenticated) {
      return const HomePage();
    } else {
      return const LoadingPage();
    }
  }
}