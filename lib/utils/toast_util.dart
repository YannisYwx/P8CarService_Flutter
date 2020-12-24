import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// des:
///
class ToastUtil {
  static showToast(String msg, {Toast toastLength = Toast.LENGTH_SHORT}) {
    _show(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue[400]);
  }

  static showAlertToast(String msg, {Toast toastLength = Toast.LENGTH_SHORT}) {
    _show(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red[600]);
  }

  static showSuccessToast(String msg,
      {Toast toastLength = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.BOTTOM_LEFT}) {
    _show(
        msg: msg,
        gravity: gravity,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green[400]);
  }

  static _show({
    String msg,
    double fontSize = 12.0,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM_LEFT,
    Color backgroundColor,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }
}
