import 'package:flutter/material.dart';
import '../widget/x_appbar.dart';
import '../android_back_desktop.dart';

///
/// des:
///

class XPage extends WillPopScope {
  final Widget body;
  final String title;

  XPage(BuildContext context,{ this.body, this.title, bool hasBackIcon = true})
      : super(
            onWillPop: () {
              print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
              // Navigator.pop(context);
              // AndroidBackDesktop.backToDesktop();
              return Future.value(true);
            },
            child: Scaffold(
              appBar: XAppBar(
                context,
                title,
                hasBackIcon: hasBackIcon,
              ),
              body: body,
            ));
}
