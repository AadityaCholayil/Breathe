import 'package:breathe/bloc/doctor_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/views/doctor/auth_screens/welcome_screen.dart';
import 'package:breathe/views/doctor/doctor_home_page.dart';
import 'package:flutter/material.dart';

class DoctorWrapper extends StatelessWidget {
  final DoctorAppState state;

  const DoctorWrapper({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is UninitializedDoctor) {
      return const LoadingPage();
    } else if (state is UnauthenticatedDoctor ||
        state is DoctorLoginPageState ||
        state is DoctorSignupPageState ||
        state is DoctorEmailInputState) {
      return const DoctorWelcomeScreen();
    } else if (state is AuthenticatedDoctor) {
      return const DoctorHomePage();
    } else {
      return const LoadingPage();
    }
  }
}