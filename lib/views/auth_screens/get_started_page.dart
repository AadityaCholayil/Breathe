import 'dart:io';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/auth_screens/hospital_details_page.dart';
import 'package:breathe/views/auth_screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);


  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  String name = '';
  int age = 0;
  String gender = '';
  String doctorId = '';
  String hospital = '';
  File? _image;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.bg,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.w),
                    const CustomBackButton(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'Welcome to,',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: CustomTheme.t2,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            'Breathe',
                            style: TextStyle(
                              height: 1.25,
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Let's get started",
                            style: TextStyle(
                              height: 1.25.w,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          _buildProfile(context),
                          SizedBox(height: 20.w),
                          _buildName(),
                          SizedBox(height: 20.w),
                          _buildAge(),
                          SizedBox(height: 25.w),
                          _buildGender(),
                          // SizedBox(height: 20.w),
                          // _buildHospitalName(),
                          // SizedBox(height: 20.w),
                          // _buildDoctorID(),
                          SizedBox(height: 20.w),
                          CustomElevatedButton(
                            text: 'Next',
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState?.save();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HospitalDetailsPage(
                                    name: name,
                                    age: age,
                                    gender: gender,
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              TextButton(
                                child: Text(
                                  "Login!",
                                  style: TextStyle(
                                      fontSize: 16, color: CustomTheme.accent),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 116.w,
        width: 116.w,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: CustomTheme.accent, width: 3.6.w),
                borderRadius: BorderRadius.circular(58.w),
              ),
              padding: EdgeInsets.all(3.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(58.w),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.25),
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return _buildBottomCard();
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(55.w),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _image != null
                          ? SizedBox(
                              height: 110.w,
                              width: 110.w,
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              height: 110.w,
                              width: 110.w,
                              child: Image.network(
                                'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                      _image != null
                          ? const SizedBox.shrink()
                          : Container(
                              height: 40.w,
                              color: Colors.black45,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 25.w,
                                color: CustomTheme.card,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            _image != null
                ? Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 44.w,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: CustomTheme.card,
                        border:
                            Border.all(color: CustomTheme.accent, width: 2.5.w),
                        borderRadius: BorderRadius.circular(22.w),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 24.w,
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.25),
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return _buildBottomCard();
                            },
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  // choose image from camera
  Future<File?> _imageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      return image;
    } else {
      return null;
    }
  }

  // choose image from gallery
  Future<File?> _imageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      return image;
    } else {
      return null;
    }
  }

  Widget _buildBottomCard() {
    return Card(
      margin: EdgeInsets.all(15.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.camera_alt_outlined, color: CustomTheme.t1),
              title: Text(
                'Camera',
                style: TextStyle(fontSize: 17, color: CustomTheme.t1),
              ),
              onTap: () async {
                File? image = await _imageFromCamera();
                if (image != null) {
                  setState(() {
                    _image = image;
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            Divider(
              indent: 10.w,
              endIndent: 10.w,
              height: 8.w,
              thickness: 1.5.w,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.add_photo_alternate_outlined,
                  color: CustomTheme.t1),
              title: Text(
                'Gallery',
                style: TextStyle(fontSize: 17, color: CustomTheme.t1),
              ),
              onTap: () async {
                File? image = await _imageFromGallery();
                if (image != null) {
                  setState(() {
                    _image = image;
                  });
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
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
    );
  }

  Widget _buildAge() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
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
    );
  }

  Widget _buildGender() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
        decoration: customInputDecoration(labelText: 'Gender'),
        style: formTextStyle(),
        onSaved: (value) {
          gender = value ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildHospitalName() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
        decoration: customInputDecoration(labelText: 'Hospital Name'),
        style: formTextStyle(),
        onSaved: (value) {
          hospital = value ?? '';
          print(hospital);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Hospital Name";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDoctorID() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(15.w),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: TextFormField(
        decoration: customInputDecoration(labelText: 'Doctor Id'),
        style: formTextStyle(),
        onSaved: (value) {
          doctorId = value ?? '';
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Doctor's Id";
          }
          return null;
        },
      ),
    );
  }
}
