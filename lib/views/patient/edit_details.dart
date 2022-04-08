import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc.dart';
import 'package:breathe/bloc/patient_bloc/app_bloc/app_bloc_files.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/patient_bloc/app_bloc/app_states.dart';
import '../../shared/error_screen.dart';
import '../../shared/loading.dart';
import '../../themes/theme.dart';

class EditPatientProfilePage extends StatefulWidget {
  const EditPatientProfilePage({Key? key}) : super(key: key);

  @override
  State<EditPatientProfilePage> createState() => _EditPatientProfilePageState();
}

class _EditPatientProfilePageState extends State<EditPatientProfilePage> {
  String stateMessage = '';
  bool showPassword = false;
  String name = '';
  int age = 0;
  String gender = 'Male';
  String photoUrl = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Patient patient = context.read<PatientAppBloc>().patient;
    name = patient.name;
    gender = patient.gender;
    print(patient.gender);
    age = patient.age;
    // photoUrl = patient.profilePic ?? '';
    // File? _image;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientAppBloc, PatientAppState>(
      listener: (context, state) async {
        if (state is PatientLoginPageState) {
          if (state == PatientLoginPageState.loading) {
            showLoadingDialog(context);
          } else {
            showErrorSnackBar(context, state.message);
          }
        }
        if (state is AuthenticatedPatient) {
          stateMessage = 'Success!';
          Navigator.pop(context);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Navigating..');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: CustomTheme.bg,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                SizedBox(height: 40.w),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    "Edit Details",
                    style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.w),
                      _buildEditName(),
                      SizedBox(height: 40.w),
                      _buildEditAge(),
                      SizedBox(height: 40.w),
                      _buildEditGender(),
                      SizedBox(height: 40.w),
                      _buildUpdateProfileButton(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdateProfileButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomElevatedButton(
        text: 'Update Profile',
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState?.save();
          BlocProvider.of<PatientAppBloc>(context)
              .add(UpdatePatientData(gender: gender, name: name, age: age));
        },
      ),
    );
  }

  Widget _buildEditName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, bottom: 4.w),
          child: Text(
            'Name',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: CustomTheme.t2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomShadow(
            child: TextFormField(
              initialValue: name,
              decoration: customInputDecoration(labelText: 'Name'),
              style: formTextStyle(),
              onSaved: (value) {
                name = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, bottom: 4.w),
          child: Text(
            'Age',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: CustomTheme.t2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomShadow(
            child: TextFormField(
              initialValue: age.toString(),
              decoration: customInputDecoration(labelText: 'Age'),
              style: formTextStyle(),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                age = int.tryParse(value ?? '') ?? 18;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age!';
                }
                if (int.tryParse(value) == null) {
                  return "Invalid!";
                }
                if (int.tryParse(value)! > 100 || int.tryParse(value)! < 0) {
                  return "Please enter valid age!";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditGender() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          SizedBox(
            width: 15.w,
          ),
          Text(
            'Gender',
            style: TextStyle(
              color: CustomTheme.t1,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = 'Male';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                  border: Border.all(
                    width: 2.5.w,
                    color: gender == 'Male'
                        ? CustomTheme.accent
                        : Colors.transparent,
                  ),
                  color: CustomTheme.card,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Text(
                  'M',
                  style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = 'Female';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                  border: Border.all(
                    width: 2.5.w,
                    color: gender == 'Female'
                        ? CustomTheme.accent
                        : Colors.transparent,
                  ),
                  color: CustomTheme.card,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Text(
                  'F',
                  style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                setState(() {
                  gender = 'Others';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                  border: Border.all(
                    width: 2.5.w,
                    color: gender == 'Others'
                        ? CustomTheme.accent
                        : Colors.transparent,
                  ),
                  color: CustomTheme.card,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Text(
                  'Others',
                  style: TextStyle(
                      color: CustomTheme.t1,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
