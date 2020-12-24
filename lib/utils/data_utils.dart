import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/bean/login_info.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// des:
///
class DataUtils {
  /// 保存登录信息
  static saveLoginInfo(LoginInfo loginInfo) {
    SpUtil.putObject(Constants.LOGIN_INFO, loginInfo);
  }

  /// 获取登录信息
  static LoginInfo getLoginInfo() {
    LoginInfo loginInfo;
    loginInfo = SpUtil.getObj<LoginInfo>(Constants.LOGIN_INFO, (v) {
      return LoginInfo.fromJson(v);
    }, defValue: null);
    return loginInfo;
  }

  static saveToken(String token) {
    SpUtil.putString(Constants.TOKEN, token);
  }

  static clearToken() {
    saveToken('');
  }

  static String getToken() {
    return SpUtil.getString(Constants.TOKEN);
  }
}
