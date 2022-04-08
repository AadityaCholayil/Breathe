import 'package:breathe/bloc/doctor_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc.dart';
import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/shared/coming_soon.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/doctor/doctor_settings_page.dart';
import 'package:breathe/views/patient/report_screens/session_report_page.dart';
import 'package:breathe/views/patient/readings/take_readings_page.dart';
import 'package:breathe/views/patient/settings_page.dart';
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
                  for (Patient patient in patientList)
                    SizedBox(
                      height: 85.w,
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
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
                                  fontWeight: FontWeight.w500
                                ),
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
                          Text(
                            patient.lastMessageTimestamp.toDate().toString().substring(11,16)+'\n',
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomTheme.t2,
                            ),
                          ),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ),
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
        'Pair with patient',
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

  Widget _buildCard(
      BuildContext context, String asset, String cardType, double iconHeight) {
    return InkWell(
      onTap: () {
        print("Button Pressed");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ComingSoon()));
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
