import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// des:
///
class ImageHelper {
  ///assets目录下图片
  static String wrapAssets(String url) {
    return "assets/images/" + url;
  }

  /// 默认的占位图 iOS风格的活动指示器
  static Widget placeHolder({double width, double height}) => SizedBox(
      width: width,
      height: height,
      child: CupertinoActivityIndicator(radius: min(10.0, width / 3)));

  /// 默认的错误图片
  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.error_outline, size: size));
  }

}

class IconFonts {
  IconFonts._();

  /// iconfont:flutter base
  static const String fontFamily = 'iconfont';

  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  static const IconData pageNetworkError = IconData(0xe678, fontFamily: fontFamily);
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);
}