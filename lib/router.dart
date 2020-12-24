import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/pages/entry/entry_page.dart';
import 'package:p8_inspection_flutter/pages/entry/login_page.dart';
import 'package:p8_inspection_flutter/pages/home/home_page.dart';
import 'package:p8_inspection_flutter/pages/home/parking_monitor_page.dart';
import 'package:p8_inspection_flutter/pages/webview_page.dart';

class Routers extends PageRouteBuilder {
  static const entryPage = "app://";
  static const loginPage = "app://LoginPage";
  static const homePage = "app://HomePage";
  static const parkingMonitorPage = "app://ParkingMonitorPage";

  final Widget widget;

  Routers(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return widget;
            });

  static Widget _getPage(String url, dynamic params) {
    if (url.startsWith('https://') || url.startsWith('http://')) {
      return WebViewPage(url);
    } else {
      switch (url) {
        case entryPage:
          return EntryPager();
        case loginPage:
          return LoginPage(params);
        case homePage:
          return HomePage(params);
        case parkingMonitorPage:
          return ParkingMonitorPage();
      }
    }
    return null;
  }

  static pushNoParams(BuildContext context, String url) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return _getPage(url, null);
    // }));
    Navigator.push(context, Routers(_getPage(url, null)));
  }

  static push(BuildContext context, String url, dynamic params) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return _getPage(url, params);
    // }));
    Navigator.push(context, Routers(_getPage(url, params)));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    // 渐变效果
    // return FadeTransition(
    //   opacity: Tween(begin: 0.0,end: 1).animate(CurvedAnimation(
    //     parent: animation,
    //     curve: Curves.fastLinearToSlowEaseIn,
    //   )),
    //   child: child,
    // );
    // 缩放效果
    // return ScaleTransition(
    //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
    //     parent: animation,
    //     curve: Curves.fastOutSlowIn,
    //   )),
    //   child: child,
    // );
    // 旋转+缩放
    //   return RotationTransition(
    //     turns: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
    //       parent: animation,
    //       curve:Curves.fastOutSlowIn
    //     )),
    //     child: ScaleTransition(
    //     scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
    //       parent: animation,
    //       curve: Curves.fastOutSlowIn,
    //     )),
    //     child: child,
    //   ),
    //   );
    // 左右滑动动画
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0),
        end: Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: child,
    );
  }
}
