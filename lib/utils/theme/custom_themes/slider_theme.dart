import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TSliderTheme {
  TSliderTheme._();

  static final lightSliderTheme = SliderThemeData(
    activeTrackColor: TColors.primary,
    inactiveTrackColor: TColors.secondary,
    thumbColor: TColors.secondary,
    trackHeight: 6,
    overlayColor: TColors.primary.withAlpha(32),
    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
    valueIndicatorColor: TColors.primary,
    showValueIndicator: ShowValueIndicator.always,
    valueIndicatorTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  );
}
