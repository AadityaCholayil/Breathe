import 'dart:async';
import 'package:breathe/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui' as ui;

class BackgroundImage extends StatelessWidget {
  final Widget child;

  const BackgroundImage({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}

class CustomTexture extends StatelessWidget {
  final Widget child;

  const CustomTexture({Key? key, required this.child}) : super(key: key);

  Future<ui.Image> loadImage() async {
    ImageProvider myImage = Image.asset(
      "assets/texture.png",
      fit: BoxFit.fitHeight,
    ).image;
    final completer = Completer<ui.Image>();
    final stream = myImage.resolve(const ImageConfiguration());
    stream.addListener(
        ImageStreamListener((info, _) => completer.complete(info.image)));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: loadImage(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ShaderMask(
                blendMode: BlendMode.overlay,
                shaderCallback: (bounds) => ImageShader(
                  snapshot.data!,
                  TileMode.mirror,
                  TileMode.mirror,
                  Matrix4.identity().storage,
                ),
                child: child,
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: BackgroundImage(
                  child: Center(
                    child: SpinKitCircle(
                      size: 100.w,
                      color: CustomTheme.brown,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.w,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          size: 32.w,
          color: CustomTheme.brown,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
