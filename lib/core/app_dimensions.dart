import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  static AppDimensionData of(BuildContext context) {
    return AppDimensionData(MediaQuery.of(context));
  }
}

class AppDimensionData {
  final MediaQueryData _mq;

  AppDimensionData(this._mq);

  double get screenWidth  => _mq.size.width;
  double get screenHeight => _mq.size.height;

  double get topPadding    => _mq.padding.top;
  double get bottomPadding => _mq.padding.bottom;

  double get scale => screenWidth / 390;

  double w(double val) => val * scale;
  double f(double val) => val * (scale.clamp(0.85, 1.25));
  double h(double val) => val * (screenHeight / 844);

  double get pagePadding    => w(24);
  double get cardPadding    => w(16);
  double get sectionSpacing => h(24);

  bool get isSmallPhone  => screenWidth < 360;
  bool get isNormalPhone => screenWidth >= 360 && screenWidth < 430;
  bool get isLargePhone  => screenWidth >= 430;
}