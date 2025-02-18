import 'package:flutter/material.dart';
import 'package:to_do_app_flutter/core/theme/app_pallete.dart';

class Constants {
  //

  static const noInternetConnectionMessage = 'No internet connection';
}

final Shader textGradient = const LinearGradient(
  colors: <Color>[AppPallete.gradient1, AppPallete.gradient2],
).createShader(
  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
);
