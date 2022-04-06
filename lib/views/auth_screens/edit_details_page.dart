import 'package:breathe/bloc/app_bloc/app_bloc_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/error_screen.dart';
import '../../shared/loading.dart';
import '../../themes/theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String email = 'aadi@gmail.com';
  String password = 'aadi123';
  String stateMessage = '';
  bool showPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) async {
        if (state is LoginPageState) {
          if (state == LoginPageState.loading) {
            showLoadingDialog(context);
          } else {
            showErrorSnackBar(context, state.message);
          }
        }
        if (state is Authenticated) {
          stateMessage = 'Success!';
          Navigator.pop(context);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Navigating..');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      builder: (context, state) {
        return Container(
          color: CustomTheme.bg,
        );
      },
    );
  }

}