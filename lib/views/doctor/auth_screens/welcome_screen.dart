import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/doctor/auth_screens/get_started_page.dart';
import 'package:breathe/views/doctor/auth_screens/login_screen.dart';
import 'package:breathe/views/patient/auth_screens/get_started_page.dart';
import 'package:breathe/views/patient/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorWelcomeScreen extends StatefulWidget {
  const DoctorWelcomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorWelcomeScreenState createState() => _DoctorWelcomeScreenState();
}

class _DoctorWelcomeScreenState extends State<DoctorWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/onBoardingScreen.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Spacer(
                flex: 5,
              ),
              // Image.asset('assets/welcome_page_icon_${CustomTheme.isDark?'dark':'light'}.png'),
              const Spacer(
                flex: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    CustomElevatedButton(
                      text: 'Sign Up',
                      style: 0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DoctorGetStartedPage()));
                      },
                    ),
                    SizedBox(height: 30.w),
                    CustomElevatedButton(
                      text: 'Login',
                      style: 1,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DoctorLoginPage()));
                      },
                    ),
                    SizedBox(height: 75.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
