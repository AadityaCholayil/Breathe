import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
enum dailyWeeklyWidget { daily, weekly }
var dailyWeeklyButtonColor = CustomTheme.accent;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  dailyWeeklyWidget selectedWidget = dailyWeeklyWidget.daily;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bg,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 24.w),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomBackButton(),
                  SizedBox(
                    height: 40.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      "Report",
                      style: TextStyle(
                        color: CustomTheme.t1,
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 42.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 64.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedWidget = dailyWeeklyWidget.daily;
                            });
                          },
                          child: _buildDailyWeeklyButton("Daily", (selectedWidget == dailyWeeklyWidget.daily) ? CustomTheme.accent : CustomTheme.card),
                        ),
                        const Spacer(),
                        InkWell(
                          child: _buildDailyWeeklyButton("Weekly", (selectedWidget == dailyWeeklyWidget.daily) ? CustomTheme.card : CustomTheme.accent ),
                          onTap: (){
                            setState(() {
                              selectedWidget = dailyWeeklyWidget.weekly;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.w,
                  ),
                  // _buildDailyStack(context),
                  dailyWeeklyChooser(context)
                ],
              ),
              // SizedBox(height: 30.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget dailyWeeklyChooser(BuildContext context){
    if(selectedWidget == dailyWeeklyWidget.daily) {
      return _buildDailyStack(context);
    } else {
      return _buildWeeklyStack(context);
    }
  }

  Widget _buildDailyStack(BuildContext context) {
    return Stack(
      children: [
        _buildStackBgCard(context),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24.w,
                ),
                _buildBackForwardButton(Icons.arrow_back),
                const Spacer(),
                const Text(
                  "02 Apr 2022",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    // fontFamily: "Montserrat"
                  ),
                ),
                const Spacer(),
                _buildBackForwardButton(Icons.arrow_forward),
                SizedBox(
                  width: 24.w,
                ),
              ],
            ),
            SizedBox(
              height: 25.w,
            ),
            _buildAverageCard(),
            SizedBox(
              height: 42.w,
            ),
            // _buildGraph(context, report)
            // SizedBox(
            //   height: 21.w,
            // ),
            // _buildGraph2(context, report)
          ],
        )
      ],
    );
  }

  Stack _buildWeeklyStack(BuildContext context) {
    return Stack(
      children: [
        _buildStackBgCard(context),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24.w,
                ),
                _buildBackForwardButton(Icons.arrow_back),
                const Spacer(),
                const Text(
                  "02 Apr 22- 09 Apr 22",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    // fontFamily: "Montserrat"
                  ),
                ),
                const Spacer(),
                _buildBackForwardButton(Icons.arrow_forward),
                SizedBox(
                  width: 24.w,
                ),
              ],
            ),
            SizedBox(
              height: 25.w,
            ),
            _buildAverageCard(),
            SizedBox(
              height: 42.w,
            ),
            // _buildGraph(context, report)
            // SizedBox(
            //   height: 21.w,
            // ),
            // _buildGraph2(context, report)
          ],
        )
      ],
    );
  }

  Widget _buildAverageCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 57.w),
      child: Container(
        height: 84.w,
        width: 301.w,
        decoration: BoxDecoration(
          color: CustomTheme.card,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(color: CustomTheme.accent),
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
        child: Column(
          children: [
            SizedBox(height: 14.w),
            Center(
              child: Text(
                "Average",
                style: TextStyle(
                  color: CustomTheme.t2,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 2.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "53",
                    style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    color: CustomTheme.t1,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackForwardButton(IconData buttonType) {
    return InkWell(
      child: Container(
          height: 70.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CustomTheme.card,
            border: Border.all(color: CustomTheme.accent),
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
          ),
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Icon(
              buttonType,
              size: 28.w,
            ),
          )),
      onTap: () {
        print("Button Pressed");
      },
    );
  }

  Container _buildStackBgCard(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: CustomTheme.card,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27.5.w),
            topRight: Radius.circular(27.5.w)),
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
    );
  }

  Widget _buildDailyWeeklyButton(String buttonType, Color buttonColor) {
    return Container(
      height: 44.w,
      width: 123.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.w),
        color: buttonColor,
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
      child: Center(
        child: Text(
          buttonType,
          style: TextStyle(
            color: CustomTheme.t1,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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