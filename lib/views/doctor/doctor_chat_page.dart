import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc.dart';
import 'package:breathe/bloc/doctor_bloc/database_bloc/database_bloc_files.dart';
import 'package:breathe/models/helper_models.dart';
import 'package:breathe/models/message.dart';
import 'package:breathe/models/patient.dart';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorChatPage extends StatefulWidget {
  final Patient patient;

  const DoctorChatPage({Key? key, required this.patient}) : super(key: key);

  @override
  State<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends State<DoctorChatPage> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    context.read<DoctorDatabaseBloc>().add(GetMessages(patient: widget.patient));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorDatabaseBloc, DoctorDatabaseState>(
      listener: (context, state) {
        if (state is DoctorChatPageState) {
          if (state.pageState == PageState.success) {
            messages = state.messages;
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const DoctorSettingsPage()));
                  },
                ),
                SizedBox(width: 20.w),
              ],
            ),
            backgroundColor: CustomTheme.bg,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  for (Message message in messages)
                    _buildMessage(context, message),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, Message message){
    print(message);
    return Text(
      message.content
    );
  }
}
