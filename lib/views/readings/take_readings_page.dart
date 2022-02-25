import 'package:breathe/main.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/themes/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TakeReadingPage extends StatefulWidget {
  const TakeReadingPage({Key? key}) : super(key: key);

  @override
  _TakeReadingPageState createState() => _TakeReadingPageState();
}

class _TakeReadingPageState extends State<TakeReadingPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: TakeReadingPageView(),
      ),
    );
  }
}

class TakeReadingPageView extends StatefulWidget {
  const TakeReadingPageView({Key? key}) : super(key: key);

  @override
  _TakeReadingPageViewState createState() => _TakeReadingPageViewState();
}

class _TakeReadingPageViewState extends State<TakeReadingPageView> with WidgetsBindingObserver {
  // Controller
  late CameraController controller;

  // true when inference is ongoing
  bool predicting = false;

  // // Instance of [Classifier]
  // Classifier classifier;

  // // Instance of [IsolateUtils]
  // IsolateUtils isolateUtils;

  bool recording = false;

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

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    controller =
        CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const LoadingPage();
    }
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
                  child: CameraPreview(controller),
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
                  padding: EdgeInsets.only(left: 20.w),
                  height: 85.h,
                  width: 414.w,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.fromLTRB(0, 9.w, 15.w, 9.w),
                    iconSize: 30.w,
                    color: CustomTheme.onAccent,
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
                      setState(() {
                        recording = !recording;
                      });
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
                            borderRadius:
                                BorderRadius.circular(recording ? 5.w : 40.w),
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
  }
}
