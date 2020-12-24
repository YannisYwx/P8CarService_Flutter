import 'package:flutter/material.dart';

///
/// des:
///
class LoadingDialog extends Dialog {
  LoadingDialog({this.canceledOnTouchOutside = true}) : super();

  ///点击背景是否能够退出
  final bool canceledOnTouchOutside;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Center(
      child: new Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            children: <Widget>[
              GestureDetector(

                  ///点击事件
                  onTap: () {
                if (canceledOnTouchOutside) {
                  Navigator.pop(context);
                }
              }),
              _dialog()
            ],
          )),
    );
  }

  Widget _dialog() {
    return new Center(
      ///弹框大小
      child: new SizedBox(
        width: 120.0,
        height: 120.0,
        child: new Container(
          ///弹框背景和圆角
          decoration: ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: new Text(
                  "加载中",
                  style: new TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dismiss(){
    Navigator.pop(_context);
  }

  static show(context) {
    Navigator.push(context, DialogRouter(LoadingDialog()));
  }
}

class DialogRouter extends PageRouteBuilder {
  final Widget page;

  DialogRouter(this.page)
      : super(
          opaque: false,
          barrierColor: Colors.black54,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        );
}
