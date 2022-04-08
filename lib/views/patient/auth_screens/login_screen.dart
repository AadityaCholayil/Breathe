import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/auth_screens/get_started_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({Key? key}) : super(key: key);

  @override
  _PatientLoginPageState createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  String email = 'aadi@gmail.com';
  String password = 'aadi123';
  String stateMessage = '';
  bool showPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientAppBloc, PatientAppState>(
      listener: (context, state) async {
        if (state is PatientLoginPageState) {
          if (state == PatientLoginPageState.loading) {
            showLoadingDialog(context);
          } else {
            showErrorSnackBar(context, state.message);
          }
        }
        if (state is AuthenticatedPatient) {
          stateMessage = 'Success!';
          Navigator.pop(context);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Navigating..');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              color: CustomTheme.bg,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
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
                        'Login to continue',
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
                          decoration: customInputDecoration(labelText: 'Email'),
                          style: formTextStyle(),
                          onSaved: (value) {
                            email = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!validateEmail(email)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Stack(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15.w),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: TextFormField(
                              decoration:
                                  customInputDecoration(labelText: 'Password'),
                              style: formTextStyle(),
                              obscureText: !showPassword,
                              onSaved: (value) {
                                password = value ?? '';
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
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
                      SizedBox(height: 25.w),
                      CustomElevatedButton(
                        text: 'Login',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState?.save();
                          showErrorSnackBar(context, stateMessage);
                          BlocProvider.of<PatientAppBloc>(context)
                              .add(PatientLoginUser(email: email, password: password));
                        },
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            TextButton(
                              child: Text(
                                "Sign Up!",
                                style: TextStyle(
                                    fontSize: 16, color: CustomTheme.accent),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GetStartedPage()));
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
}
