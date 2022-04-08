import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc.dart';
import 'package:breathe/shared/coming_soon.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/edit_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomBackButton(),
            SizedBox(
              height: 30.w,
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
                backgroundImage: NetworkImage(
                    context.read<PatientDatabaseBloc>().patient.profilePic),
              ),
            ),
            SizedBox(height: 11.w),
            Center(
              child: Text(
                context.read<PatientAppBloc>().patient.name,
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
                context.read<PatientAppBloc>().patient.doctorName,
                // "Dr. Pranav Shegekar",
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
                context.read<PatientAppBloc>().patient.hospital,
                // "XYZ Hospital",
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
            const SettingsOptions(
              listItemName: 'Edit Details',
              destination: EditPatientProfilePage(),
            ),
            SizedBox(height: 28.w),
            const SettingsOptions(
              listItemName: 'Delete Account',
              destination: ComingSoon(),
            ),
            SizedBox(height: 28.w),
            const SettingsOptions(listItemName: 'Sign Out', destination: null),
          ],
        ),
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
        // border: Border.all(color: CustomTheme.accent),
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
          SizedBox(width: 15.w),
          _buildProfileCardElements(
            context,
            'Age',
            context.read<PatientAppBloc>().patient.age.toString(),
          ),
          // const Spacer(),
          _buildProfileCardElements(
            context,
            'Status',
            // context.read<AppBloc>().userData.healthStatus,
            "Healthy",
          ),
          // const Spacer(),
          _buildProfileCardElements(
            context,
            'Sex',
            context.read<PatientAppBloc>().patient.gender.substring(0,1),
            // "O",
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  Widget _buildProfileCardElements(
      BuildContext context, String headingText, String mainText) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            headingText,
            style: TextStyle(
              color: CustomTheme.t2,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            mainText,
            // "Pranav",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomTheme.t1,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsOptions extends StatelessWidget {
  final String listItemName;
  final Widget? destination;

  const SettingsOptions({
    Key? key,
    required this.listItemName,
    this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (destination == null) {
          // context.read<AuthBloc>().add(LoggedOut());
          showDialog(
            context: context,
            builder: (context) {
              return const PatientSignOutPrompt();
            },
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination!,
            ),
          );
        }
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
