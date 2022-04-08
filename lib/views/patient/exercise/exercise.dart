import 'package:breathe/shared/coming_soon.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/exercise/exercise-1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Exercise extends StatelessWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.bg,
      body: Column(
        children: [
          Center(
            child: Image.asset("assets/breathingExercise.png"),
          ),
          SizedBox(
            height: 40.w,
          ),
          _buildCard(context, "Exercise-1"),


          SizedBox(
            height: 23.w,
          ),
          _buildCard(context, "Exercise"),
          SizedBox(
            height: 23.w,
          ),
          _buildCard(context, "Exercise"),
          SizedBox(
            height: 23.w,
          ),
          _buildCard(context, "Exercise"),
        ],
      ),
    );
  }
}

Widget _buildCard(
    BuildContext context,String cardType) {
  return InkWell(
    onTap: () {
      print("Button Pressed");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Exercise1()));
    },
    child: Container(
      height: 73.w,
      width: 366.w,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: CustomTheme.cardShadow,
            blurRadius: 15.w,
            // spreadRadius: 1,
            // blurStyle: ,
            offset: Offset(
              4.w,
              4.w,
            ),
          ),
        ],
        color: CustomTheme.card,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   // child: Image.asset("assets/breathingExercise.png"),
          //   // height: iconHeight,
          // ),
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
