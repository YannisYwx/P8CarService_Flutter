import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:p8_inspection_flutter/ui/pages/entry/entry_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //防止热重载报错
  Provider.debugCheckInvalidValueType = null;
  await SpUtil.getInstance();
  // runApp(MyApp());\
  
  runApp(MultiProvider(
    providers: [

    ],
    child: MyApp(),
  ));
  configLoading();
  if (Platform.isAndroid) {
    //设置Android头部的导航栏透明
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

///
/// 初始化全局加载框
///
void configLoading() {
  EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1000)
        ..indicatorType = EasyLoadingIndicatorType.cubeGrid
        ..loadingStyle = EasyLoadingStyle.custom
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = Colors.blue
        ..backgroundColor = Colors.white
        ..indicatorColor = Colors.blue[500]
        ..textColor = Colors.black54
        ..maskColor = Colors.blue.withOpacity(0.5)
        ..userInteractions = true
        ..maskType = EasyLoadingMaskType.clear
        ..dismissOnTap = false
        ..animationStyle = EasyLoadingAnimationStyle.scale
      /*..customAnimation = CustomAnimation()*/;
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    double opacity = controller?.value ?? 0;
    return Opacity(
      opacity: opacity,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This ui.widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        theme: ThemeData(backgroundColor: Colors.white),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          //控制界面内容 body是否重新布局来避免底部被覆盖了，比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true
          body: EntryPager(),
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}

///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state = context.findAncestorStateOfType();
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
