import 'dart:ui';

import 'package:flutter/material.dart';

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topBarHeight = mediaQuery.padding.top;
  static double _bottomBarHeight = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static double _ratio;

  static const int DEFAULT_WIDTH = 540;

  static printDeviceScreenInfo() {
    print('screenWidth = ${Adapt.screenWidth()}');
    print('screenHeight = ${Adapt.screenHeight()}');
    print('padTopHeight = ${Adapt.padTopHeight()}');
    print('padBottomHeight = ${Adapt.padBottomHeight()}');
    print('onePx = ${Adapt.onePx()}');
    print('padBottomHeight = ${Adapt.padBottomHeight()}');
    print('_pixelRatio = ${Adapt.pixelRatio}');

    // 1.媒体查询信息
    final mediaQueryData = MediaQueryData.fromWindow(window);
    // 2.获取宽度和高度
    final dpr = window.devicePixelRatio;
    print("屏幕width:$_width , height:$_height");
    final physicalWidth = window.physicalSize.width;
    final physicalHeight = window.physicalSize.height;
    print("分辨率: $physicalWidth - $physicalHeight");
    print("dpr: $dpr");
    // 3.状态栏的高度
    // 有刘海的屏幕:44 没有刘海的屏幕为20
    final statusBarHeight = mediaQueryData.padding.top;
    // 有刘海的屏幕:34 没有刘海的屏幕0
    final bottomHeight = mediaQueryData.padding.bottom;
    print("状态栏height: $statusBarHeight , 底部高度:$bottomHeight");
  }

  static init(int number) {
    int uiWidth = number is int ? number : DEFAULT_WIDTH;
    _ratio = _width / uiWidth;
  }

  static double px(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(DEFAULT_WIDTH);
    }
    return number * _ratio;
  }

  static onePx() {
    return 1 / _pixelRatio;
  }

  static pixelRatio() {
    return _pixelRatio;
  }

  static screenWidth() {
    return _width;
  }

  static screenHeight() {
    return _height;
  }

  static padTopHeight() {
    return _topBarHeight;
  }

  static padBottomHeight() {
    return _bottomBarHeight;
  }
}
