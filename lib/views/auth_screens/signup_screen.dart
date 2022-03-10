import 'dart:io';

import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String doctorId;
  final String hospital;
  final File? profilePic;

  const SignupPage({
    Key? key,
    required this.name,
    required this.age,
    required this.gender,
    required this.doctorId,
    required this.hospital,
    required this.profilePic,
  }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = '';
  String password = '';
  String stateMessage = '';
  bool showPassword = false;
  bool showConfirmPassword = false;
  EmailStatus emailStatus = EmailStatus.invalid;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is EmailInputState) {
          emailStatus = state.emailStatus;
          print(emailStatus);
        }
        if (state is SignupPageState) {
          showErrorSnackBar(context, state.message);
        }
        if (state is Authenticated) {
          stateMessage = 'Success!';
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Navigating..');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
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
                      SizedBox(height: 70.h),
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
                      SizedBox(height: 60.h),
                      Text(
                        'Create an account',
                        style: TextStyle(
                          height: 1.25.w,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Stack(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15.w),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: TextFormField(
                              decoration: emailStatus == EmailStatus.valid
                                  ? customInputDecoration(labelText: 'Email')
                                      .copyWith(
                                      enabledBorder: greenBorder,
                                      focusedBorder: greenBorder,
                                    )
                                  : customInputDecoration(labelText: 'Email'),
                              style: formTextStyle(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!validateEmail(email)) {
                                  return 'Invalid email format';
                                }
                                if (emailStatus == EmailStatus.invalid) {
                                  return 'This email is already taken!';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                                if (value.isNotEmpty && validateEmail(email)) {
                                  context
                                      .read<AppBloc>()
                                      .add(CheckEmailStatus(email: value));
                                } else {
                                  setState(() {
                                    emailStatus = EmailStatus.invalid;
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 15.w),
                            height: 55.w,
                            alignment: Alignment.centerRight,
                            child: emailStatus == EmailStatus.loading
                                ? const CircularProgressIndicator()
                                : emailStatus == EmailStatus.valid
                                    ? Icon(
                                        Icons.check,
                                        size: 30.w,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.close,
                                        size: 30.w,
                                        color: email == ''
                                            ? Colors.transparent
                                            : Colors.red,
                                      ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.w),
                      Stack(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15.w),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(15.w),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: TextFormField(
                                decoration: customInputDecoration(
                                    labelText: 'Password'),
                                style: formTextStyle(),
                                obscureText: !showPassword,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 8) {
                                    return 'Minimum 8 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10.w),
                            height: 56.w,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 28.w),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.w),
                      Stack(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15.w),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: TextFormField(
                              decoration: customInputDecoration(
                                  labelText: 'Confirm Password'),
                              style: formTextStyle(),
                              obscureText: !showConfirmPassword,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please re-enter your password';
                                }
                                if (value != password) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10.w),
                            height: 56.w,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                  showConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 28.w),
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.w),
                      CustomElevatedButton(
                        text: 'Signup',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState?.save();
                          showErrorSnackBar(context, stateMessage);
                          BlocProvider.of<AppBloc>(context).add(SignupUser(
                            email: email,
                            password: password,
                            name: widget.name,
                            age: widget.age,
                            gender: widget.gender,
                            doctorId: widget.doctorId,
                            hospital: widget.hospital,
                            profilePic: widget.profilePic,
                          ));
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
                                            const LoginPage()));
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
      },
    );
  }

  bool validateEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  OutlineInputBorder greenBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.green,
      width: 2.w,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0.w)),
  );
}
