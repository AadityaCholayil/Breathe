import 'package:breathe/views/patient/exercise/timerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:breathe/themes/theme.dart';

import '../../../shared/shared_widgets.dart';

class Exercise1 extends StatelessWidget {
  const Exercise1({Key? key}) : super(key: key);

  // final CountDownController _controller= CountDownController();
  // bool _isPause= false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(height: 20.w),
                const CustomBackButton(),
                SizedBox(height: 20.w),
                SizedBox(
                  height: 150.w,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    'Exercise-1',
                    style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text('Deep Diaphragm Breathing',
                  style: TextStyle(
                    color: CustomTheme.t1,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            SizedBox(
              height: 20.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text('Instructions',
                  style: TextStyle(
                    color: CustomTheme.t1,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            SizedBox(
              height: 30.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: Text(
                  'Empty your lungs and stomach by exhaling and start inhaling-\n\n1. Fill up the belly\n2. Fill up the lower rib cage\n3. Fill up the upper rib cage\n4.Exhale smoothly and completely\n5. Repeat',
                  style: TextStyle(
                    color: CustomTheme.t1,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  )),
            ),
            SizedBox(
              height: 20.w,
            ),
            Center(
              child: ElevatedButton(
                child: Text('Go'),
                onPressed: () {
                  print("Button Pressed");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const timerPage()));
                },
                style: ElevatedButton.styleFrom(primary: CustomTheme.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
