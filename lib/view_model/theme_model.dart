import 'package:flutter/material.dart';

///
/// des:
///
class ThemeModel with ChangeNotifier {

  /// 是否是
  bool _userDarkModel;

  get isDarkModel => _userDarkModel;

  /// 当前主题颜色
  MaterialColor _themeColor;
}
