import 'package:breathe/doctor_app.dart';
import 'package:breathe/patient_app.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/select_user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserWrapper extends StatefulWidget {
  const UserWrapper({Key? key}) : super(key: key);

  @override
  State<UserWrapper> createState() => _UserWrapperState();
}

class _UserWrapperState extends State<UserWrapper> {
  bool? isDoctor;

  void changeApp(bool isDoctor){
    setState(() {
      this.isDoctor = isDoctor;
      print(this.isDoctor);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isDoctor == null) {
      return SelectUserTypePage(changeApp: changeApp);
    } else if (isDoctor!) {
      return const DoctorApp();
    } else {
      return const PatientApp();
    }
  }
}
