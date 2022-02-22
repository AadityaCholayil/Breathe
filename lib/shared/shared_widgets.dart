import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
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
    contentPadding: EdgeInsets.fromLTRB(20.w, 15.w, 15.w, 15.w),
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
    labelStyle: const TextStyle(fontSize: 18),
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
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.fromLTRB(0, 9.w, 15.w, 9.w),
      iconSize: 32.w,
      color: CustomTheme.accent,
      icon: const Icon(Icons.arrow_back_ios_rounded),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
