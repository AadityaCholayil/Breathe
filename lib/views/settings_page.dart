import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/app_bloc/app_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 85.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: const CustomBackButton(),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: CircleAvatar(
              radius: 75.w,
              backgroundColor: Colors.grey,
              backgroundImage: const AssetImage("assets/DummyProfile.jpg"),
            ),
          ),
          SizedBox(height: 11.w),
          Center(
            child: Text(
              context.read<AppBloc>().userData.name,
              // "Pranav",
              style: TextStyle(
                color: CustomTheme.t1,
                fontSize: 29,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 11.w),
          Center(child: _buildProfileCard(context)),
          SizedBox(height: 29.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              "Consulting Doctor",
              // "Pranav",
              style: TextStyle(
                color: CustomTheme.t2,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              // context.read<AppBloc>().userData.doctorName,
              "Dr. Pranav Shegekar",
              style: TextStyle(
                color: CustomTheme.t1,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 20.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              // context.read<AppBloc>().userData.doctorName,
              "Hospital",
              style: TextStyle(
                color: CustomTheme.t2,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              // context.read<AppBloc>().userData.hospital,
              "XYZ Hospital",
              style: TextStyle(
                color: CustomTheme.t1,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 29.w),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              // context.read<AppBloc>().userData.doctorName,
              "Account",
              style: TextStyle(
                color: CustomTheme.t2,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8.w),
          const SettingsOptions(listItemName: 'Edit Details'),
          SizedBox(height: 28.w),
          const SettingsOptions(listItemName: 'Delete Account'),
          SizedBox(height: 28.w),
          const SettingsOptions(listItemName: 'Sign Out'),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      height: 87.w,
      width: 366.w,
      decoration: BoxDecoration(
        color: CustomTheme.card,
        borderRadius: BorderRadius.circular(25.w),
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
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34.w,
          ),
          _buildProfileCardElements(
            context,
            'Age',
            context.read<AppBloc>().userData.age.toString(),
          ),
          const Spacer(),
          _buildProfileCardElements(
            context,
            'Status',
            // context.read<AppBloc>().userData.healthStatus,
            "Healthy",
          ),
          const Spacer(),
          _buildProfileCardElements(
            context,
            'Sex',
            // context.read<AppBloc>().userData.gender,
            "M",
          ),
          SizedBox(width: 34.w),
        ],
      ),
    );
  }

  Widget _buildProfileCardElements(
      BuildContext context, String headingText, String mainText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headingText,
              style: TextStyle(
                color: CustomTheme.t2,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              mainText,
              // "Pranav",
              style: TextStyle(
                color: CustomTheme.t1,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsOptions extends StatelessWidget {
  final String listItemName;
  final Widget? destination;
  const SettingsOptions({
    Key? key, required this.listItemName, this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination!,
            ),
          );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          children: [
            Text(
              listItemName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: CustomTheme.t1,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 25.w,
              color: CustomTheme.accent,
            ),
          ],
        ),
      ),
    );
  }
}
