import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';

typedef _OnActionClick = void Function();

///
/// des:
///
class XAppBar extends AppBar {
  final _OnActionClick onActionClick;

  XAppBar(BuildContext context, String titleName,
      {bool isCenterTitle = true, Widget action, bool hasBackIcon = true, this.onActionClick})
      : super(
      title: Text(titleName),
      toolbarHeight: Adapt.px(72),
      backgroundColor: Colors.blue[500],
      leading: Offstage(
        offstage: !hasBackIcon,
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      actions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            action == null ? Container():action,
          ],
        ),
      ],
      centerTitle: isCenterTitle);
}
