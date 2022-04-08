import 'package:breathe/doctor_app.dart';
import 'package:breathe/patient_app.dart';
import 'package:breathe/select_user_type.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserWrapper extends StatefulWidget {
  final bool? isDoctor;

  const UserWrapper({Key? key, required this.isDoctor}) : super(key: key);

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

  // void getUserType(bool isDoctor) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final bool? repeat = prefs.getBool('repeat');
  // }

  @override
  void initState() {
    super.initState();
    isDoctor = widget.isDoctor;
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
