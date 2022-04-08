import 'dart:io';

import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
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
  String doctorId = '114283';
  Doctor? doctor;
  PageState pageState = PageState.init;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientAppBloc, PatientAppState>(
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is DoctorLinkingPageState) {
          doctor = state.doctor;
          pageState = state.pageState;
        }
      },
      builder: (context, state) {
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
                        SizedBox(height: 40.h),
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text(
                            "Enter the Doctor code",
                            style: TextStyle(
                              height: 1.25.w,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        _buildDoctorID(),
                        SizedBox(height: 20.w),
                        CustomElevatedButton(
                          text: 'Find Doctor',
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState?.save();
                            context
                                .read<PatientAppBloc>()
                                .add(GetDoctorDetails(doctorId: doctorId));
                          },
                        ),
                        doctor == null
                            ? Container(
                                height: 160.w,
                                alignment: Alignment.center,
                                child: Text(
                                  pageState == PageState.error
                                      ? 'No Doctors found'
                                      : pageState == PageState.loading
                                          ? 'Finding...'
                                          : '',
                                  style: TextStyle(
                                    height: 1.25.w,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: CustomTheme.t2,
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  _buildDoctorCard(doctor!),
                                  CustomElevatedButton(
                                    text: 'Pair with Doctor',
                                    onPressed: () {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      _formKey.currentState?.save();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PatientSignupPage(
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

  Widget _buildDoctorCard(Doctor doctor) {
    return Column(
      children: [
        SizedBox(height: 50.w),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 108.w,
          width: 108.w,
          child: Image.network(
            doctor.profilePic,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 17.w),
        Text(
          doctor.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: CustomTheme.t1,
          ),
        ),
        SizedBox(height: 19.w),
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 23.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: CustomTheme.cardShadow,
                blurRadius: 15,
                offset: Offset(4.w, 4.w),
              ),
            ],
            color: CustomTheme.card,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Qualification',
                      style: TextStyle(
                          color: CustomTheme.t2,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6.w),
                    Text(
                      doctor.qualification,
                      style: TextStyle(
                        color: CustomTheme.t1,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hospital',
                      style: TextStyle(
                          color: CustomTheme.t2,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6.w),
                    Text(
                      doctor.hospital,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomTheme.t1,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 27.w),
      ],
    );
  }

  Widget _buildDoctorID() {
    return CustomShadow(
      child: TextFormField(
        initialValue: doctorId,
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
