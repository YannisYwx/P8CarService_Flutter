import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/bean/entry_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:p8_inspection_flutter/router.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';

class EntryPager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Adapt.printDeviceScreenInfo();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: Adapt.px(540),
          height: Adapt.px(300),
          color: Colors.blueAccent,
          child: Stack(
            children: [
              Image.asset(
                Constants.ASSETS_IMG + 'entry_header.png',
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment(0, 0.8),
                child: Text(
                  '欢迎登录P8车服',
                  style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          alignment: Alignment.center,
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: EntryType.getEntryTypes().length,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(3),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //横轴元素个数
              crossAxisCount: 3,
              //纵轴间距
              mainAxisSpacing: 3.0,
              //横轴间距
              crossAxisSpacing: 3.0,
              //子组件宽高长度比例
              childAspectRatio: 1.0),
          itemBuilder: (context, index) {
            EntryType et = EntryType.getEntryTypes()[index];
            return Ink(
              color: et.color,
              child: InkWell(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "${et.label}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM_LEFT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 12.0);
                  Routers.push(context, Routers.loginPage, et);
                },
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        et.label.substring(0, 1),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      alignment: Alignment(0, -0.2),
                    ),
                    Align(
                      child: Text(
                        et.label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      alignment: Alignment(0, 0.8),
                    ),
                  ],
                ),
                splashColor: Colors.cyan,
                hoverColor: Colors.red,
              ),
            );
          },
        ),
      ],
    );
  }
}
