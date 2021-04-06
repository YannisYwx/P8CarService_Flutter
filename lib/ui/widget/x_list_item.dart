import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';
import 'package:p8_inspection_flutter/constant/app_style.dart';

const double _lrSpace = 20.0;

typedef CallBack = void Function(dynamic tag);

///
/// des:
///
class XListItem extends StatelessWidget {
  final String title;
  final String routerName;
  final String leadingIconUrl;
  final String trailingIconUrl;
  final bool hasBottomLine;
  final double intent;
  final double endIntent;
  final bool dividerNoPadding;
  final CallBack callBack;
  final dynamic tag;

  XListItem(this.title, this.leadingIconUrl, this.trailingIconUrl,
      {this.routerName,
      this.hasBottomLine = true,
      this.dividerNoPadding = false,
      this.intent = 20,
      this.endIntent = 20,
      @required this.callBack,
      this.tag});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Colors.white,
      child: InkWell(
        focusColor: Colors.white,
        splashColor: Colors.blueAccent[100],
        child: Container(
          height: Adapt.px(72),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: Adapt.px(_lrSpace),
                child: Image.asset(
                  leadingIconUrl,
                  width: Adapt.px(35),
                  height: Adapt.px(35),
                ),
              ),
              Positioned(
                  left: Adapt.px(80),
                  child: Text(
                    title,
                    style: AppStyle.BlackLabelStyle,
                  )),
              Positioned(
                right: Adapt.px(_lrSpace * 0.6),
                child: Image.asset(
                  trailingIconUrl,
                  width: Adapt.px(35),
                  height: Adapt.px(35),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0,
                right: 0,
                child: Divider(
                  height: 0,
                  thickness: 0.68,
                  indent: Adapt.px(dividerNoPadding ? 0 : intent),
                  endIndent: Adapt.px(dividerNoPadding ? 0 : endIntent),
                  color: hasBottomLine ? Colors.grey[300] : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (callBack != null) {
            callBack(tag);
          }
        },
      ),
    );
  }
}
