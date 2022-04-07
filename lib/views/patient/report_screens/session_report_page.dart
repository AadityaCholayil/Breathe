import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var data = {
  "date": "2022-03-09",
  "bestScore": 1150,
  "averageScore": 900,
  "readings": [
    {
      'score': 1000,
      'timeElapsed': 500,
    },
    {
      'score': 995,
      'timeElapsed': 1000,
    },
    {
      'score': 887,
      'timeElapsed': 1500,
    },
    {
      'score': 999,
      'timeElapsed': 2000,
    },
    {
      'score': 1111,
      'timeElapsed': 2500,
    },
    {
      'score': 1150,
      'timeElapsed': 3000,
    },
    {
      'score': 608,
      'timeElapsed': 3500,
    },
    {
      'score': 500,
      'timeElapsed': 4000,
    },
    {
      'score': 899,
      'timeElapsed': 4500,
    },
    {
      'score': 752,
      'timeElapsed': 5000,
    },
    {
      'score': 800,
      'timeElapsed': 5500,
    },
  ],
  "totalDuration": 5500,
  "timeTakenAt": Timestamp.now(),
};

class SessionReportPage extends StatelessWidget {
  final SessionReport report;

  const SessionReportPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String bestToolTip = "Shows the best reading.";
    String averageToolTip = "Shows the average reading.";
    print(report);
    return BlocConsumer<DatabaseBloc,DatabaseState>(
      listener: (context, state){
        if (state is SessionReportPageState){
          if(state.pageState == PageState.loading){
            showLoadingSnackBar(context);
          }
          if(state.pageState == PageState.success){
            showErrorSnackBar(context, 'Successfully saved!');
          }
          if(state.pageState == PageState.error){
            showErrorSnackBar(context, 'Something went wrong. Please try again!');
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.bg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.w),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    child: Row(
                      children: [
                        const CustomBackButton(),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            context
                                .read<DatabaseBloc>()
                                .add(SaveReport(report: report));
                          },
                          icon: Icon(
                            Icons.save_alt,
                            size: 32.w,
                            color: CustomTheme.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Text(
                      "Session Report",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: CustomTheme.t1,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Text(
                      report.timeTakenAt.toDate().toIso8601String(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CustomTheme.t2,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard("Best", report.bestScore, bestToolTip),
                      SizedBox(
                        width: 16.w,
                      ),
                      _buildCard("Average", report.averageScore, averageToolTip),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: Text(
                      "Timeline",
                      style: TextStyle(
                        color: CustomTheme.t1,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  _buildGraph(context, report),
                  SizedBox(height: 20.w),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: Text(
                      "Peak Values",
                      style: TextStyle(
                        color: CustomTheme.t1,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.w),
                  _buildGraph2(context, report),
                  SizedBox(height: 50.w),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildGraph(BuildContext context, SessionReport report) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding:
            EdgeInsets.only(top: 30.w, left: 10.w, right: 15.w, bottom: 15.w),
        // height: MediaQuery.of(context).size.height,
        height: 256.w,
        width: 366.w,
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
        child: LineChart(
          LineChartData(
            maxX: (report.totalDuration / 1000).toDouble(),
            minY: 0,
            maxY: 1200,
            gridData: FlGridData(
              drawHorizontalLine: false,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(color: CustomTheme.t1),
                left: BorderSide(color: CustomTheme.t1),
                top: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var reading in report.readings)
                    FlSpot((reading.timeElapsed / 1000).toDouble(),
                        reading.score.toDouble()),
                ],
                colors: [CustomTheme.accent],
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(
                  show: true,
                  colors: [
                    CustomTheme.accent,
                  ],
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                  showTitles: true,
                  interval: 400,
                  // margin: 20
                  reservedSize: 30.w),
              rightTitles: SideTitles(showTitles: false),
              topTitles: SideTitles(showTitles: false),
            ),
            axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: 'Score',
                textStyle: TextStyle(
                  fontSize: 18,
                  color: CustomTheme.t2,
                ),
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Time',
                margin: 15,
                textStyle: TextStyle(fontSize: 18, color: CustomTheme.t2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraph2(BuildContext context, SessionReport report) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding:
        EdgeInsets.only(top: 30.w, left: 10.w, right: 15.w, bottom: 15.w),
        // height: MediaQuery.of(context).size.height,
        height: 256.w,
        width: 366.w,
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
        child: LineChart(
          LineChartData(
            maxX: (report.totalDuration / 1000).toDouble(),
            minY: 0,
            maxY: 1200,
            gridData: FlGridData(
              drawHorizontalLine: false,
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(color: CustomTheme.t1),
                left: BorderSide(color: CustomTheme.t1),
                top: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var reading in report.peaks)
                    FlSpot((reading.timeElapsed / 1000).toDouble(),
                        reading.score.toDouble()),
                ],
                colors: [CustomTheme.accent],
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(
                  show: true,
                  colors: [
                    CustomTheme.accent,
                  ],
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                  showTitles: true,
                  interval: 400,
                  // margin: 20
                  reservedSize: 30.w),
              rightTitles: SideTitles(showTitles: false),
              topTitles: SideTitles(showTitles: false),
            ),
            axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                showTitle: true,
                titleText: 'Score',
                textStyle: TextStyle(
                  fontSize: 18,
                  color: CustomTheme.t2,
                ),
              ),
              bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Time',
                margin: 15,
                textStyle: TextStyle(fontSize: 18, color: CustomTheme.t2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String cardType, int value, String toolTip) {
    return Container(
      height: 114.w,
      width: 173.w,
      decoration: BoxDecoration(
        color: CustomTheme.card,
        boxShadow: [
          BoxShadow(
            color: CustomTheme.cardShadow,
            blurRadius: 15,
            offset: Offset(
              4.w,
              4.w,
            ),
          ),
        ],
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  child: Icon(
                    Icons.info,
                    size: 12.w,
                    color: CustomTheme.t2,
                  ),
                  message: toolTip,
                  showDuration: const Duration(seconds: 2),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  cardType,
                  style: TextStyle(
                    color: CustomTheme.t2,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 14.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: CustomTheme.t1,
                  fontWeight: FontWeight.w400,
                  fontSize: 29,
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Text(
                "/",
                style: TextStyle(
                  color: CustomTheme.accent,
                  fontWeight: FontWeight.w400,
                  fontSize: 21.5,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                "1200",
                style: TextStyle(
                  color: CustomTheme.t2,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
