import 'package:breathe/bloc/app_bloc/app_bloc.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 104.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(
              'Welcome Back,',
              style: TextStyle(
                  color: CustomTheme.t1,
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(
              context.read<AppBloc>().userData.name,
              // "Pranav",
              style: TextStyle(
                color: CustomTheme.t1,
                fontSize: 42,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 56.w,
          ),
          Row(
            children: [
              SizedBox(
                width: 24.w,
              ),
              _buildCard("report", "Report"),
              SizedBox(
                width: 20.w,
              ),
              _buildCard("exercise", "Exercise"),
            ],
          ),
          SizedBox(height: 17.w),
          Row(
            children: [
              SizedBox(
                width: 24.w,
              ),
              _buildCard("medicineReminder", "Medicine Reminder"),
              SizedBox(
                width: 20.w,
              ),
              _buildCard("askDoctor", "Chat with your\ndoctor"),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildCard(String asset, String cardType) {
    return Container(
      height: 117.w,
      width: 173.w,
      decoration: BoxDecoration(
        color: CustomTheme.card,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 19.5.w),
        child: Column(
          children: [
            SizedBox(
              child: Image.asset("assets/$asset.png"),
              height: 54.w,
            ),
            SizedBox(
              height: 2.w,
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
