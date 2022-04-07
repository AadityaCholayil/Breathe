import 'package:breathe/bloc/app_bloc_observer.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/loading.dart';
import 'package:breathe/themes/theme.dart';
import 'package:breathe/views/user_wrapper.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';

// List of available cameras
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  cameras = await availableCameras();
  String? res = await Tflite.loadModel(
    model: "assets/tensorflow/model1-full.tflite",
    labels: "assets/tensorflow/labels.txt",
    numThreads: 1,
    // defaults to 1
    isAsset: true,
    // defaults to true, set to false to load resources outside assets
    useGpuDelegate: false, // defaults to false, set to true to use GPU delegate
  );
  BlocOverrides.runZoned(
    () => {
      runApp(const FlutterFireInit()),
    },
    eventTransformer: sequential<dynamic>(),
    blocObserver: AppBlocObserver(),
  );
}

class FlutterFireInit extends StatefulWidget {
  const FlutterFireInit({Key? key}) : super(key: key);

  @override
  _FlutterFireInitState createState() => _FlutterFireInitState();
}

class _FlutterFireInitState extends State<FlutterFireInit> {
  bool? isDoctor;

  Future<FirebaseApp> _initialization() async {
    final prefs = await SharedPreferences.getInstance();
    isDoctor ??= prefs.getBool('isDoctor');
    return await Firebase.initializeApp();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(home: SomethingWentWrong());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenUtilInit(
            designSize: const Size(414, 896),
            builder: () {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: CustomTheme.getTheme(context),
                home: const UserWrapper(),
                builder: (context, child) {
                  int width = MediaQuery.of(context).size.width.toInt();
                  return MediaQuery(
                    data:
                    MediaQuery.of(context).copyWith(textScaleFactor: width / 414),
                    child: child ?? const SomethingWentWrong(),
                  );
                },
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const LoadingPage();
      },
    );
  }
}
