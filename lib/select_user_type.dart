import 'package:breathe/patient_app.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectUserTypePage extends StatelessWidget {
  final void Function(bool isDoctor) changeApp;

  const SelectUserTypePage({Key? key, required this.changeApp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.getTheme(context),
          home: SafeArea(
            child: Scaffold(
              body: Container(
                color: CustomTheme.bg,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.w,
                      child: Image.asset('assets/name_logo.png'),
                    ),
                    SizedBox(height: 50.w),
                    Text(
                      'Select one.',
                      style: TextStyle(
                        color: CustomTheme.t2,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    InkWell(
                      onTap: () {
                        print("Button Pressed");
                        changeApp(true);
                      },
                      child: Container(
                        height: 100.w,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Image.asset("assets/askDoctor.png"),
                              height: 40.w,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Text(
                              'Doctor',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: CustomTheme.t1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.w),
                    InkWell(
                      onTap: () async {
                        print("Button Pressed");
                        changeApp(false);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isDoctor', false);
                      },
                      child: Container(
                        height: 100.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: CustomTheme.cardShadow,
                              blurRadius: 15,
                              // spreadRadius: 1,
                              // blurStyle: ,
                              offset: Offset(
                                4.w,
                                4.w,
                              ),
                            ),
                          ],
                          color: CustomTheme.card,
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Image.asset("assets/askDoctor.png"),
                              height: 40.w,
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Text(
                              'Patient',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: CustomTheme.t1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 70.w),
                  ],
                ),
              ),
            ),
          ),
          builder: (context, child) {
            int width = MediaQuery.of(context).size.width.toInt();
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(textScaleFactor: width / 414),
              child: child ?? const SomethingWentWrong(),
            );
          },
        );
      },
    );
  }
}
