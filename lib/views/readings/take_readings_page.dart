import 'package:breathe/bloc/tensorflow_bloc/tensorflow_bloc_files.dart';
import 'package:breathe/main.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/tflite/classifier.dart';
import 'package:breathe/tflite/recognition.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/utils/camera_view_singleton.dart';
import 'package:breathe/utils/isolate_utils.dart';
import 'package:breathe/views/readings/box_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  // Instance of [Classifier]
  late Classifier classifier;

  // Instance of [IsolateUtils]
  late IsolateUtils isolateUtils;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance?.addObserver(this);

    controller =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils.start();

    // Camera initialization
    initializeCamera();

    // Create an instance of classifier to load model and labels
    classifier = Classifier();

    // Initially predicting = false
    predicting = false;
  }

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    controller.initialize().then((_) async {
      await controller.startImageStream(onLatestImageAvailable);
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (!mounted) {
      return;
    }
    if (classifier.interpreter != null && classifier.labels != null) {
      context.read<TensorFlowBloc>().add(PerformInference(
            image: cameraImage,
            isolateUtils: isolateUtils,
            classifier: classifier,
          ));
      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      Size? previewSize = controller.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize??const Size(640,640);

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = (screenSize.width / (previewSize?.height??640));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const LoadingPage();
    }
    return BlocBuilder<TensorFlowBloc, TensorFlowState>(
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
                          boundingBoxes(state.recognitions),
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
                          context
                              .read<TensorFlowBloc>()
                              .add(ChangeRecordingStatus());
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

  /// Returns Stack of bounding boxes
  Widget boundingBoxes(List<Recognition> results) {
    if (results.isEmpty) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
        result: e,
      )).toList(),
    );
  }

  Widget _buildTimeElapsed(String timeElapsed) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10.w),
          Container(
            width: 24.w,
            alignment: Alignment.centerRight,
            child: Text(
              timeElapsed.substring(3, 4),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.5.w),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Container(
            width: 25.w,
            alignment: Alignment.center,
            child: Text(
              timeElapsed.substring(5, 6),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: CustomTheme.onAccent,
              ),
            ),
          ),
          Container(
            width: 26.w,
            alignment: Alignment.center,
            child: Text(
              timeElapsed.substring(6, 7),
              style: TextStyle(
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
              style: TextStyle(
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
