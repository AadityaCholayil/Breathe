import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/auth_screens/login_screen.dart';
import 'package:breathe/views/auth_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  String name = '';
  int age = 0;
  String gender = '';
  String doctorId = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //       image: AssetImage(CustomTheme.bgImagePath), fit: BoxFit.cover),
          // ),
          color: CustomTheme.bg,
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
                  SizedBox(height: 90.h),
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
                  SizedBox(height: 75.h),
                  Text(
                    "Let's get started",
                    style: TextStyle(
                      height: 1.25.w,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15.w),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: TextFormField(
                      decoration: customInputDecoration(labelText: 'Name'),
                      style: formTextStyle(),
                      onSaved: (value) {
                        name = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15.w),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: TextFormField(
                      decoration: customInputDecoration(labelText: 'Age'),
                      style: formTextStyle(),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        age = int.tryParse(value ?? '') ?? 18;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age!';
                        }
                        if (int.tryParse(value) == null) {
                          return "Invalid!";
                        }
                        if (int.tryParse(value)! > 100 ||
                            int.tryParse(value)! < 0) {
                          return "Please enter valid age!";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25.w),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15.w),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: TextFormField(
                      decoration: customInputDecoration(labelText: 'Gender'),
                      style: formTextStyle(),
                      onSaved: (value) {
                        gender = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your gender';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15.w),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
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
                  ),
                  SizedBox(height: 20.w),
                  CustomElevatedButton(
                    text: 'Next',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState?.save();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage(
                                    name: name,
                                    age: age,
                                    gender: gender,
                                    doctorId: doctorId,
                                  )));
                    },
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface),
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
                                    builder: (context) => const LoginPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
