import 'dart:io';

import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/auth_screens/login_screen.dart';
import 'package:breathe/views/patient/auth_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientDoctorLinkingPage extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final File? image;

  const PatientDoctorLinkingPage(
      {Key? key,
      required this.name,
      required this.age,
      required this.gender,
      required this.image})
      : super(key: key);

  @override
  _PatientDoctorLinkingPageState createState() =>
      _PatientDoctorLinkingPageState();
}

class _PatientDoctorLinkingPageState extends State<PatientDoctorLinkingPage> {
  String doctorId = '';
  Doctor? doctor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientAppBloc, PatientAppState>(
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is DoctorLinkingPageState) {
          doctor = state.doctor;
        }
      },
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.bg,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //       image: AssetImage(CustomTheme.bgImagePath), fit: BoxFit.cover),
                // ),
                // color: CustomTheme.bg,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 25.w),
                        const CustomBackButton(),
                        SizedBox(height: 20.h),
                        Text(
                          'Welcome to,',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: CustomTheme.t2,
                            height: 0.9,
                          ),
                        ),
                        Text(
                          'Breathe',
                          style: TextStyle(
                            height: 1.25,
                            fontSize: 45,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Enter the Doctor code",
                          style: TextStyle(
                            height: 1.25.w,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 25.h),
                        _buildDoctorID(),
                        SizedBox(height: 20.w),
                        doctor == null
                            ? CustomElevatedButton(
                                text: 'Next',
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState?.save();
                                  context.read<PatientAppBloc>().add(
                                      GetDoctorDetails(doctorId: doctorId));
                                },
                              )
                            : CustomElevatedButton(
                                text: 'Confirm and Proceed',
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  _formKey.currentState?.save();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PatientSignupPage(
                                        name: widget.name,
                                        age: widget.age,
                                        gender: widget.gender,
                                        doctor: doctor!,
                                        profilePic: widget.image,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            TextButton(
                              child: Text(
                                "Login!",
                                style: TextStyle(
                                    fontSize: 16, color: CustomTheme.accent),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PatientLoginPage()));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDoctorID() {
    return CustomTextFormField(
      child: TextFormField(
        decoration: customInputDecoration(labelText: 'Doctor Id'),
        style: formTextStyle(),
        onSaved: (value) {
          doctorId = value ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Doctor's Id";
          }
          return null;
        },
      ),
    );
  }
}
