import 'package:breathe/app.dart';
import 'package:breathe/bloc/app_bloc_observer.dart';
import 'package:breathe/shared/error_screen.dart';
import 'package:breathe/shared/loading.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

// List of available cameras
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  BlocOverrides.runZoned(
    () => {},
    eventTransformer: sequential<dynamic>(),
    blocObserver: AppBlocObserver(),
  );
  runApp(const FlutterFireInit());
}


class FlutterFireInit extends StatefulWidget {
  const FlutterFireInit({Key? key}) : super(key: key);

  @override
  _FlutterFireInitState createState() => _FlutterFireInitState();
}

class _FlutterFireInitState extends State<FlutterFireInit> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(home: SomethingWentWrong());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const LoadingPage();
      },
    );
  }
}
