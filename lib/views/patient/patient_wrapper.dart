import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/views/patient/auth_screens/welcome_screen.dart';
import 'package:breathe/views/patient/patient_home_page.dart';
import 'package:flutter/material.dart';

class PatientWrapper extends StatelessWidget {
  final PatientAppState state;

  const PatientWrapper({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is UninitializedPatient) {
      return const LoadingPage();
    } else if (state is UnauthenticatedPatient ||
        state is PatientLoginPageState ||
        state is PatientSignupPageState ||
        state is PatientEmailInputState) {
      return const PatientWelcomeScreen();
    } else if (state is AuthenticatedPatient) {
      return const PatientHomePage();
    } else {
      return const LoadingPage();
    }
  }
}