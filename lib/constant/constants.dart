import 'package:flutter/material.dart';

///
/// des:
///
class Constants {
  static const String LOGIN_INFO = '_LoginInfo';
  static const String TOKEN = '_Token';
  static const String ASSETS_IMG = 'assets/images/';

  static String getBerthStatusLabel(BerthStatus status) {
    switch(status){
      case BerthStatus.haveCar:
        return '有车';
      case BerthStatus.noCar:
        return '无车';
      case BerthStatus.all:
        return '全部';
    }
    return '泊位状态';
  }
}


enum BerthStatus {
  haveCar,
  noCar,
  all,
}