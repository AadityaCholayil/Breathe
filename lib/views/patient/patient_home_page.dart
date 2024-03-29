import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/shared/coming_soon.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/patient_chat_page.dart';
import 'package:breathe/views/patient/report_screens/report_page.dart';
import 'package:breathe/views/patient/report_screens/session_report_page.dart';
import 'package:breathe/views/patient/readings/take_readings_page.dart';
import 'package:breathe/views/patient/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  List<SessionReport> reportList = [];

  @override
  void initState() {
    super.initState();
    context.read<PatientDatabaseBloc>().add(const GetTodaysReports());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientDatabaseBloc, PatientDatabaseState>(
      listener: (context, state) {
        if (state is PatientHomePageState) {
          if (state.pageState == PageState.success) {
            reportList = state.reportList;
          }
        }
      },
      builder: (context, state) {
        Patient patient = context.read<PatientAppBloc>().patient;
        return SafeArea(
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _buildFloatingActionButton(context),
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
                            color: CustomTheme.t1,
                          ),
                          onTap: () {
                            print("Settings button pressed");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsPage()));
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
                      patient.name,
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
                      _buildCard(context, "report", "Report", 54.w,
                          const ReportPage()),
                      SizedBox(
                        width: 20.w,
                      ),
                      _buildCard(context, "exercise", "Exercise", 48.w,
                          const ComingSoon()),
                    ],
                  ),
                  Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                          ),
                          Column(
                            children: [
                              SizedBox(height: 17.w),
                              _buildCard(
                                  context,
                                  "medicineReminder",
                                  "Medicine Reminder",
                                  45.w,
                                  const ComingSoon()),
                            ],
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 17.w),
                                  _buildCard(
                                      context,
                                      "askDoctor",
                                      "Chat with your\ndoctor",
                                      45.w,
                                      const PatientChatPage()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      patient.patientUnreadCount == 0
                          ? SizedBox(height: 5.w)
                          : Positioned(
                              right: 15.w,
                              top: 7.w,
                              child: Container(
                                height: 28.w,
                                width: 28.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: CustomTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${patient.patientUnreadCount}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomTheme.onAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
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
                  for (var report in reportList)
                    _buildPreviousReadingCard(context, report),
                  reportList.isEmpty
                      ? SizedBox(
                          height: 200.w,
                          child: Center(
                            child: Text(
                              'No reports added yet.',
                              style: TextStyle(
                                color: CustomTheme.t1,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  SizedBox(height: 60.w),
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
    );
  }

  Widget _buildPreviousReadingCard(BuildContext context, SessionReport report) {
    return Padding(
      padding: EdgeInsets.only(bottom: 35.w),
      child: InkWell(
        onTap: () {
          print("Previous Reading Card pressed");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SessionReportPage(report: report)));
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
                          report.bestScore.toString(),
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
                          report.averageScore.toString(),
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
                    report.timeTakenAt.toDate().toIso8601String(),
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

  Widget _buildCard(BuildContext context, String asset, String cardType,
      double iconHeight, Widget destination) {
    return InkWell(
      onTap: () {
        print("Button Pressed");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.videocam),
              title: Text(
                'Record',
                style: TextStyle(fontSize: 16, color: CustomTheme.t1),
              ),
              onTap: () {},
            ),
            Divider(
              color: CustomTheme.accent,
              indent: 10.w,
              endIndent: 10.w,
              height: 8.w,
              thickness: 1.5.w,
            ),
            ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.edit),
                title: Text(
                  'Manual',
                  style: TextStyle(fontSize: 16, color: CustomTheme.t1),
                ),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
