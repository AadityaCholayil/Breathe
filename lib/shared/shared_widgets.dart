import 'package:breathe/bloc/doctor_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


InputDecoration customInputDecoration(
    {String labelText = '',
    bool isSearch = false}) {
  return InputDecoration(
    suffixIcon: isSearch
        ? Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Icon(
              Icons.search,
              size: 25.w,
            ),
          )
        : null,
    contentPadding: EdgeInsets.fromLTRB(20.w, 22.5.w, 22.5.w, 15.w),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
    fillColor: CustomTheme.card,
    labelText: labelText,
    labelStyle: TextStyle(fontSize: 17.w),
    alignLabelWithHint: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    helperStyle: const TextStyle(
      color: Color(0xdd000000),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: const TextStyle(
      color: Color(0xdd000000),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorStyle: const TextStyle(
      color: Color(0xffd32f2f),
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorMaxLines: null,
    isDense: false,
    isCollapsed: false,
    prefixStyle: const TextStyle(
      color: Color(0xdd000000),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: const TextStyle(
      color: Color(0xdd000000),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: const TextStyle(
      color: Color(0xdd000000),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: true,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xffd32f2f),
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: CustomTheme.accent,
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xffd32f2f),
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff000000),
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff000000),
        width: 2.w,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
    ),
  );
}

TextStyle formTextStyle() => TextStyle(
      fontSize: 18,
      color: CustomTheme.t1,
    );

TextStyle formTextStyle2() =>
    TextStyle(fontSize: 18, color: CustomTheme.t1);

class CustomTextFormField extends StatelessWidget {
  final Widget child;

  const CustomTextFormField({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: CustomTheme.cardShadow,
                blurRadius: 15,
                offset: Offset(4.w, 4.w),
              ),
            ],
            color: CustomTheme.card,
            borderRadius: BorderRadius.circular(20.w),
          ),
        ),
        child,
      ],
    );
  }
}


class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final int style;

  const CustomElevatedButton(
      {Key? key, this.onPressed, this.text = 'Submit', this.style = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        primary: style == 0 ? CustomTheme.accent : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.w),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        height: 55.w,
        child: Text(
          text,
          style: TextStyle(
              color: style == 0 ? CustomTheme.onAccent : Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w600),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final Color? color;

  const CustomBackButton({this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.fromLTRB(0, 9.w, 15.w, 9.w),
      iconSize: 32.w,
      color: color ?? CustomTheme.accent,
      icon: const Icon(Icons.arrow_back_ios_rounded),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

class PatientSignOutPrompt extends StatelessWidget {
  const PatientSignOutPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 160.w,
        width: 300.w,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.w),
          ),
          color: CustomTheme.bg,
          child: Container(
            padding: EdgeInsets.only(bottom: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 22.w),
                Text(
                  "Do you want to Sign out?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.t1,
                    fontSize: 20.w,
                  ),
                ),
                SizedBox(
                  height: 30.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomTheme.accent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: CustomTheme.onAccent,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    TextButton(
                      onPressed: () {
                        context.read<PatientAppBloc>().add(PatientLoggedOut());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12.w,
                              ),
                              side: BorderSide(color: CustomTheme.t1)),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CustomTheme.t1,
                          // backgroundColor: CustomTheme.brown,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorSignOutPrompt extends StatelessWidget {
  const DoctorSignOutPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 160.w,
        width: 300.w,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.w),
          ),
          color: CustomTheme.bg,
          child: Container(
            padding: EdgeInsets.only(bottom: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 22.w),
                Text(
                  "Do you want to Sign out?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CustomTheme.t1,
                    fontSize: 20.w,
                  ),
                ),
                SizedBox(
                  height: 30.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          CustomTheme.accent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: CustomTheme.onAccent,
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    TextButton(
                      onPressed: () {
                        context.read<DoctorAppBloc>().add(DoctorLoggedOut());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12.w,
                              ),
                              side: BorderSide(color: CustomTheme.t1)),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: CustomTheme.t1,
                          // backgroundColor: CustomTheme.brown,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

