import 'package:breathe/bloc/patient_bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/main.dart';
import 'package:breathe/models/session_report.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/patient/readings/bounding_boxes.dart';
import 'package:breathe/views/patient/report_screens/session_report_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class TakeReadingPage extends StatefulWidget {
  const TakeReadingPage({Key? key}) : super(key: key);

  @override
  _TakeReadingPageState createState() => _TakeReadingPageState();
}

class _TakeReadingPageState extends State<TakeReadingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<TensorFlowBloc>(
          create: (context) => TensorFlowBloc(),
          child: const TakeReadingPageView(),
        ),
      ),
    );
  }
}

class TakeReadingPageView extends StatefulWidget {
  const TakeReadingPageView({Key? key}) : super(key: key);

  @override
  _TakeReadingPageViewState createState() => _TakeReadingPageViewState();
}

class _TakeReadingPageViewState extends State<TakeReadingPageView>
    with WidgetsBindingObserver {
  // Controller
  late CameraController controller;

  // true when inference is ongoing
  bool predicting = false;

  // // Instance of [Classifier]
  // Classifier classifier;

  // // Instance of [IsolateUtils]
  // IsolateUtils isolateUtils;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance?.addObserver(this);

    // // Spawn a new isolate
    // isolateUtils = IsolateUtils();
    // await isolateUtils.start();

    // Camera initialization
    initializeCamera();

    // // Create an instance of classifier to load model and labels
    // classifier = Classifier();
    //
    // // Initially predicting = false
    // predicting = false;
  }

  // Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    controller =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    controller.initialize().then((_) async {
      await controller.startImageStream((image) {
        if (!mounted) {
          return;
        }
        context.read<TensorFlowBloc>().add(PerformInference(image: image));
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const LoadingPage();
    }
    Size screen = MediaQuery.of(context).size;
    return BlocConsumer<TensorFlowBloc, TensorFlowState>(
      listener: (context, state) {
        if (state.processingDone) {
          SessionReport report = context.read<TensorFlowBloc>().report;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionReportPage(
                report: report,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        bool recording = state.recording;
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: 70.w),
                    const Spacer(flex: 1),
                    AspectRatio(
                      aspectRatio: 1 / controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          CameraPreview(
                            controller,
                            child: Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 20.w),
                              child: Container(
                                alignment: Alignment.center,
                                height: 70.w,
                                width: 130.w,
                                decoration: BoxDecoration(
                                  color: CustomTheme.card,
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Text(
                                  '${state.reading}',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600,
                                    color: CustomTheme.t1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          BndBox(
                              state.recognitions,
                              math.max(state.imageHeight, state.imageWidth),
                              math.min(state.imageHeight, state.imageWidth),
                              screen.height - 340,
                              screen.width),
                        ],
                      ),
                      // aspectRatio: 0.5625,
                      // child: Container(color: Colors.amber),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: CustomTheme.t1,
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      height: 85.h,
                      width: 414.w,
                      // alignment: Alignment.centerLeft,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.fromLTRB(0, 9.w, 15.w, 9.w),
                                iconSize: 30.w,
                                color: CustomTheme.onAccent,
                                icon: const Icon(Icons.arrow_back_ios_rounded),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          _buildTimeElapsed(state.timeElapsed.toString()),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 190.h,
                      color: CustomTheme.t1,
                      padding: EdgeInsets.only(top: 20.w),
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          if (!state.recording) {
                            context.read<TensorFlowBloc>().add(StartSession());
                          } else {
                            context.read<TensorFlowBloc>().add(EndSession());
                          }
                        },
                        child: Container(
                          height: 77.w,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: recording ? 68.w : 77.w,
                            width: recording ? 68.w : 77.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: recording ? 26.w : 65.w,
                              width: recording ? 26.w : 65.w,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                    recording ? 5.w : 40.w),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeElapsed(String timeElapsed) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.w),
          Container(
            width: 22.w,
            alignment: Alignment.centerRight,
            child: Text(
              timeElapsed.substring(3, 4),
              style: GoogleFonts.roboto(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.1.w),
            child: Text(
              ':',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Container(
            width: 21.w,
            alignment: Alignment.center,
            child: Text(
              timeElapsed.substring(5, 6),
              style: GoogleFonts.roboto(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Container(
            width: 21.w,
            alignment: Alignment.center,
            child: Text(
              timeElapsed.substring(6, 7),
              style: GoogleFonts.roboto(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 9.w),
            width: 37.w,
            child: Text(
              '${timeElapsed.substring(7, 9)}s',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
