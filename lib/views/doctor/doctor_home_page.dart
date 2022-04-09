import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/doctor/doctor_chat_page.dart';
import 'package:breathe/views/doctor/doctor_settings_page.dart';
import 'package:breathe/views/patient/report_screens/session_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  List<Patient> patientList = [];

  @override
  void initState() {
    super.initState();
    context.read<DoctorDatabaseBloc>().add(const GetPatientList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorDatabaseBloc, DoctorDatabaseState>(
      listener: (context, state) {
        if (state is DoctorHomePageState) {
          if (state.pageState == PageState.success) {
            patientList = state.patientList;
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Breathe',
                style: TextStyle(
                  color: CustomTheme.onAccent,
                ),
              ),
              centerTitle: false,
              backgroundColor: CustomTheme.accent,
              shadowColor: CustomTheme.cardShadow,
              elevation: 3,
              actions: [
                InkWell(
                  child: Icon(
                    Icons.settings,
                    size: 26,
                    color: CustomTheme.onAccent,
                  ),
                  onTap: () {
                    print("Settings button pressed");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DoctorSettingsPage()));
                  },
                ),
                SizedBox(width: 20.w),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFloatingActionButton(context),
            backgroundColor: CustomTheme.bg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  for (Patient patient in patientList)
                    _buildCard(context, patient),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.w),
      ),
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          barrierColor: Colors.black.withOpacity(0.25),
          backgroundColor: Colors.transparent,
          builder: (context) {
            return _buildBottomCard(context);
          },
        );
      },
      label: Text(
        'Pair with Patient',
        style: TextStyle(
          color: CustomTheme.onAccent,
        ),
      ),
      icon: Icon(
        Icons.add,
        color: CustomTheme.onAccent,
      ),
      backgroundColor: CustomTheme.accent,
    );
  }

  Widget _buildCard(BuildContext context, Patient patient) {
    return InkWell(
      onTap: () {
        context.read<DoctorDatabaseBloc>().add(OpenChat(patient: patient));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorChatPage(patient: patient)));
      },
      child: SizedBox(
        height: 80.w,
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              height: 43.w,
              width: 43.w,
              child: Image.network(patient.profilePic),
            ),
            SizedBox(width: 16.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: TextStyle(
                      fontSize: 19,
                      color: CustomTheme.t1,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2.w),
                SizedBox(
                  width: 260.w,
                  child: Text(
                    patient.lastMessageContents,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomTheme.t1,
                    ),
                  ),
                ),
                SizedBox(height: 3.w),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  patient.lastMessageTimestamp
                      .toDate()
                      .toString()
                      .substring(11, 16),
                  style: TextStyle(
                    fontSize: 14,
                    color: patient.doctorUnreadCount == 0
                        ? CustomTheme.t2
                        : CustomTheme.accent,
                    fontWeight: patient.doctorUnreadCount == 0
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                patient.doctorUnreadCount == 0
                    ? SizedBox(height: 5.w)
                    : Container(
                        height: 23.w,
                        width: 23.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CustomTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${patient.doctorUnreadCount}',
                          style: TextStyle(
                            fontSize: 13,
                            color: CustomTheme.onAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 3.w,
                ),
              ],
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(22.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.w),
      ),
      // shadowColor: CustomTheme.accent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12.w),
            Text(
              'Your ID',
              style: TextStyle(
                fontSize: 16,
                color: CustomTheme.t2,
              ),
            ),
            SizedBox(height: 5.w),
            Text(
              context.read<DoctorDatabaseBloc>().doctor.doctorId,
              style: TextStyle(
                fontSize: 48,
                color: CustomTheme.t1,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }
}
