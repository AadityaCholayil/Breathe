import 'package:breathe/bloc/patient_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/doctor.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/shared/shared_widgets.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientChatPage extends StatefulWidget {
  const PatientChatPage({Key? key}) : super(key: key);

  @override
  State<PatientChatPage> createState() => _PatientChatPageState();
}

class _PatientChatPageState extends State<PatientChatPage> {
  List<Message> messages = [];
  String message = '';
  Patient patient = Patient.empty;
  Doctor doctor = Doctor.empty;
  final TextEditingController _chatController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    patient = context.read<PatientDatabaseBloc>().patient;
    doctor = context.read<PatientDatabaseBloc>().doctor;
    context.read<PatientDatabaseBloc>().add(const GetMessages());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientDatabaseBloc, PatientDatabaseState>(
      listener: (context, state) {
        if (state is PatientChatPageState) {
          if (state.pageState == PageState.success) {
            messages = state.messages;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CustomTheme.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: CustomTheme.card,
                    boxShadow: customBoxShadow,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      InkWell(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 22.w,
                          color: CustomTheme.t1,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: 42.w,
                        width: 42.w,
                        child: Image.network(
                          doctor.profilePic,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 21.w),
                      Text(
                        doctor.name,
                        style: TextStyle(
                          color: CustomTheme.t1,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        child: Icon(
                          Icons.more_vert,
                          size: 26,
                          color: CustomTheme.t1,
                        ),
                        onTap: () {
                          print("Settings button pressed");
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const DoctorSettingsPage()));
                        },
                      ),
                      SizedBox(width: 20.w),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessage(context, messages[index]);
                    },
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(19.w, 10.w, 19.w, 20.w),
                    child: Stack(
                      children: [
                        Container(
                          height: 60.w,
                          margin: EdgeInsets.only(right: 70.w),
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
                            borderRadius: BorderRadius.circular(90.w),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 70.w),
                          child: TextFormField(
                            controller: _chatController,
                            decoration:
                                customInputDecorationChat(labelText: 'Message'),
                            style: formTextStyle(),
                            onSaved: (value) {
                              message = value ?? '';
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              _formKey.currentState?.save();
                              if (message != '') {
                                context
                                    .read<PatientDatabaseBloc>()
                                    .add(SendMessage(message: message));
                                _chatController.clear();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: CustomTheme.accent,
                                shape: BoxShape.circle,
                                boxShadow: customBoxShadow,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              height: 60.w,
                              width: 60.w,
                              child: Icon(
                                Icons.send,
                                color: CustomTheme.onAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // for (Message message in messages)
                //   _buildMessage(context, message),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, Message message) {
    if (message.isSpecial && !message.isReport) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 16.w),
          padding: EdgeInsets.symmetric(vertical: 6.5.w, horizontal: 11.w),
          decoration: BoxDecoration(
            color: CustomTheme.card,
            boxShadow: customBoxShadow,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    } else if (message.isReport) {
      return Container(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.w, right: 15.w),
          padding: EdgeInsets.fromLTRB(5.w, 5.w, 5.w, 4.w),
          decoration: BoxDecoration(
            color: CustomTheme.accent,
            boxShadow: customBoxShadow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.w),
              topRight: Radius.circular(4.w),
              bottomLeft: Radius.circular(15.w),
              bottomRight: Radius.circular(15.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                decoration: BoxDecoration(
                    color: CustomTheme.onAccent.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10.w)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 40.w, left: 40.w),
                      child: Text(
                        'Sent a report',
                        style: TextStyle(fontSize: 15, color: CustomTheme.t1),
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      'Open',
                      style: TextStyle(
                          fontSize: 16,
                          color: CustomTheme.accent,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5.w),
                  ],
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                message.timestamp.toDate().toString().substring(11, 16),
                style: TextStyle(fontSize: 10, color: CustomTheme.onAccent),
              ),
            ],
          ),
        ),
      );
    } else if (!message.sentByDoctor) {
      return Container(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.w, right: 15.w),
          padding: EdgeInsets.fromLTRB(13.w, 13.w, 9.w, 4.w),
          decoration: BoxDecoration(
            color: CustomTheme.accent,
            boxShadow: customBoxShadow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.w),
              topRight: Radius.circular(4.w),
              bottomLeft: Radius.circular(15.w),
              bottomRight: Radius.circular(15.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Text(
                  message.content,
                  style: TextStyle(fontSize: 15, color: CustomTheme.onAccent),
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                message.timestamp.toDate().toString().substring(11, 16),
                style: TextStyle(fontSize: 10, color: CustomTheme.onAccent),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.w, left: 15.w),
          padding: EdgeInsets.fromLTRB(13.w, 13.w, 9.w, 4.w),
          decoration: BoxDecoration(
            color: CustomTheme.card,
            boxShadow: customBoxShadow,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.w),
              topRight: Radius.circular(15.w),
              bottomLeft: Radius.circular(15.w),
              bottomRight: Radius.circular(15.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Text(
                  message.content,
                  style: TextStyle(fontSize: 15, color: CustomTheme.t1),
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                message.timestamp.toDate().toString().substring(11, 16),
                style: TextStyle(fontSize: 10, color: CustomTheme.t2),
              ),
            ],
          ),
        ),
      );
    }
    return Text(message.content);
  }
}
