import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';

///
/// des:
///
class LoginButton extends StatefulWidget {
  static double width = Adapt.px(490);
  static double height = Adapt.px(64);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static double width = Adapt.px(490);
  static double height = Adapt.px(64);

  @override
  void initState() {
    _controller = AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    super.initState();
  }

  Future<Null> _playAnimation() async {
    print('======');
    try {
      await _controller.forward();
      await _controller.reverse();
    } on TickerCanceled {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller, builder: _builderAnimateWidget);
  }

  Widget _builderAnimateWidget(BuildContext context, Widget child) {
    double width = Adapt.px(490);
    double height = Adapt.px(64);
    return TweenAnimationBuilder(
      duration: Duration(microseconds: 300),
      tween: Tween(begin: width, end: height),
      builder: (context, value, child) {
        return InkWell(
          onTap: () {
            _playAnimation();
          },
          child: Container(
              width: width,
              height: LoginButton.height,
              child: value > height
                  ? RaisedButton(
                      onPressed: () {
                        // setState(() {
                        //   animationStatus = 1;
                        // });
                        // _playAnimation();
                      },
                      textColor: Colors.white,
                      hoverColor: Colors.blue,
                      color: Colors.blue,
                      splashColor: Colors.white12,
                      child:
                          Text('登录', style: TextStyle(fontSize: Adapt.px(25))),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.blueAccent, width: 1)))
                  : CircularProgressIndicator(
                      value: null,
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )),
        );
      },
    );
  }
}
