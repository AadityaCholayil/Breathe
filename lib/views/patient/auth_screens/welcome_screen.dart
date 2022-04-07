import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/auth_screens/get_started_page.dart';
import 'package:breathe/views/patient/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage(CustomTheme.bgImagePath),
        //       fit: BoxFit.cover),
        // ),
        color: CustomTheme.bg,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Spacer(flex: 5,),
            // Image.asset('assets/welcome_page_icon_${CustomTheme.isDark?'dark':'light'}.png'),
            const Spacer(flex: 4,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  CustomElevatedButton(
                    text: 'Sign Up',
                    style: 0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const GetStartedPage()));
                    },
                  ),
                  SizedBox(height: 30.w),
                  CustomElevatedButton(
                    text: 'Login',
                    style: 1,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                  ),
                  SizedBox(height: 75.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
