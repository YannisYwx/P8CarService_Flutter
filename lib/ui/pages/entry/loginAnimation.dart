import 'package:flutter/material.dart';
import 'dart:async';

import 'package:p8_inspection_flutter/utils/screen_adapter.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeAnimation;
  final Animation bottomZoomOut; ///

  static double width = Adapt.px(490);
  static double height = Adapt.px(64);

  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeAnimation = Tween(begin: width, end: height)
            .chain(CurveTween(curve: Interval(0.0, 0.150)))
            .animate(buttonController),
        bottomZoomOut = Tween(begin: height, end: 1000.0).animate(CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.550, 0.999, curve: Curves.bounceOut))),
        containerCircleAnimation = EdgeInsetsTween(
                begin: const EdgeInsets.only(bottom: 50.0),
                end: const EdgeInsets.only(bottom: 0.0))
            .chain(
                CurveTween(curve: Interval(0.500, 0.800, curve: Curves.ease)))
            .animate(buttonController),
        super(key: key);

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: bottomZoomOut.value == height
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: InkWell(
          onTap: () {
            _playAnimation();
          },
          child: Hero(
            tag: "fade",
            child: bottomZoomOut.value <= 300
                ? Container(
                    width: bottomZoomOut.value == height
                        ? buttonSqueezeAnimation.value
                        : bottomZoomOut.value,
                    height:
                        bottomZoomOut.value == height ? 60.0 : bottomZoomOut.value,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: bottomZoomOut.value < 400
                          ? BorderRadius.all(const Radius.circular(30.0))
                          : BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeAnimation.value > 75.0
                        ? Text(
                            "登录",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3),
                          )
                        : bottomZoomOut.value < 300.0
                            ? CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : null)
                : Container(
                    width: bottomZoomOut.value,
                    height: bottomZoomOut.value,
                    decoration: BoxDecoration(
                      shape: bottomZoomOut.value < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: Colors.blue,
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushNamed(context, "/home");
      }
    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
