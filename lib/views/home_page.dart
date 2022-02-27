import 'package:breathe/bloc/app_bloc/app_bloc.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/report_screens/session_report_page.dart';
import 'package:breathe/views/readings/take_readings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.w),
        ),
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TakeReadingPage()));
        },
        label: Text(
          'Take Reading',
          style: TextStyle(
            color: CustomTheme.onAccent,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: CustomTheme.onAccent,
        ),
        backgroundColor: CustomTheme.accent,
      ),
      backgroundColor: CustomTheme.bg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 25.w, top: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.settings,
                      size: 32,
                      color: CustomTheme.accent,
                    ),
                    onTap: () {
                      print("Settings button pressed");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text(
                'Welcome Back,',
                style: TextStyle(
                  color: CustomTheme.t1,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text(
                context
                    .read<AppBloc>()
                    .userData
                    .name,
                // "Pranav",
                style: TextStyle(
                  color: CustomTheme.t1,
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 56.w),
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                ),
                _buildCard("report", "Report", 54.w),
                SizedBox(
                  width: 20.w,
                ),
                _buildCard("exercise", "Exercise", 48.w),
              ],
            ),
            SizedBox(height: 17.w),
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                ),
                _buildCard("medicineReminder", "Medicine Reminder", 45.w),
                SizedBox(
                  width: 20.w,
                ),
                _buildCard("askDoctor", "Chat with your\ndoctor", 45.w),
              ],
            ),
            SizedBox(height: 36.w),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text(
                "Previous Reading",
                style: TextStyle(
                  color: CustomTheme.t1,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 23.w),
            for (int i = 0; i < 5; i++) _buildPreviousReadingCard(context),
            SizedBox(height: 60.w),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousReadingCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.w),
      child: InkWell(
        onTap: () {
          print("Previous Reading Card pressed");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SessionReportPage()));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          height: 147.w,
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
            borderRadius: BorderRadius.circular(20),
            color: CustomTheme.card,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 19.w, left: 39.w, right: 39.w),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "1200",
                          style: TextStyle(
                            fontSize: 41,
                            fontWeight: FontWeight.w400,
                            color: CustomTheme.t1,
                          ),
                        ),
                        SizedBox(
                          height: 6.w,
                        ),
                        Text(
                          "Best",
                          style: TextStyle(
                            color: CustomTheme.t2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 63.w,
                      child: VerticalDivider(
                        thickness: 1.w,
                        color: CustomTheme.t2,
                        // endIndent: 3.w,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          "1200",
                          style: TextStyle(
                            fontSize: 41,
                            fontWeight: FontWeight.w400,
                            color: CustomTheme.t1,
                          ),
                        ),
                        SizedBox(
                          height: 6.w,
                        ),
                        Text(
                          "Average",
                          style: TextStyle(
                            color: CustomTheme.t2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "03:10 PM - 14 Mar 22",
                    style: TextStyle(
                      fontSize: 18.w,
                      color: CustomTheme.t1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildCard(String asset, String cardType, double iconHeight) {
    return InkWell(
      onTap: () {
        print("Button Pressed");
      },
      child: Container(
        height: 123.w,
        width: 173.w,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset("assets/$asset.png"),
              height: iconHeight,
            ),
            SizedBox(
              height: 5.w,
            ),
            Text(
              cardType,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
