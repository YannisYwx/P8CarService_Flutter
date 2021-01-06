import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:p8_inspection_flutter/bean/entry_type.dart';
import 'package:p8_inspection_flutter/bean/login_info.dart';
import 'package:p8_inspection_flutter/constant/app_style.dart';
import 'package:p8_inspection_flutter/constant/color_constant.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:p8_inspection_flutter/router.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';
import 'package:p8_inspection_flutter/widget/x_avatar.dart';
import 'package:p8_inspection_flutter/widget/x_list_item.dart';
import 'package:p8_inspection_flutter/bean/user_menu.dart';
import 'package:p8_inspection_flutter/pages/home/parking_monitor_page.dart';

///
/// des: 主页
///
class HomePage extends StatelessWidget {
  final LoginInfo _loginInfo;
  final String url =
      "http://p8bucket.oss-cn-shenzhen.aliyuncs.com/img_1d38770488b74b32bf0af9a6919b36f6_1603789894569.jpg";
  final List<UserMenu> _menus;

  HomePage(this._loginInfo, {Key key})
      : _menus = UserMenu.getUserMenus(_loginInfo.userType),
        super(key: key);

  String getTitle() {
    if (_loginInfo == null) return '@_@';
    return EntryType.getEntryTypes()
        .singleWhere((element) => element.type == _loginInfo.userType,
            orElse: () => null)
        .label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: Adapt.px(72),
          centerTitle: true,
          title: Text(
            getTitle(),
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
      body: AnimationLimiter(
        child: Column(
          children: [
            _headView(),
            Divider(height: 0.0),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: XListItem(
                            _menus[index].menuLabel,
                            _menus[index].iconRes,
                            Constants.ASSETS_IMG + 'icon_grey_arrow.png',
                            dividerNoPadding: index == _menus.length - 1,
                            tag: _menus[index],
                            callBack: (tag) {
                              print('$tag ---- ');
                              pushToPage(context, tag);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _menus.length),
            ),
          ],
        ),
      ),
    );
  }

  pushToPage(BuildContext context, UserMenu userMenu) {
    switch (userMenu.userType) {
      case UserType.AGENCY:
        // TODO: Handle this case.
        break;
      case UserType.INSPECTION:
        // TODO: Handle this case.
        switch (userMenu.menuTye) {
          case MenuType.USER_CENTER:
            // TODO: Handle this case.
            break;
          case MenuType.PARKING_MONITOR:
            // TODO: Handle this case.
            Routers.pushNoParams(context, Routers.parkingMonitorPage);
            break;
          case MenuType.DEVICE_BINDING:
            // TODO: Handle this case.
            break;
          case MenuType.DEVICE_DEBUG:
            // TODO: Handle this case.
            break;
          case MenuType.WORK_ORDER_PROCESSING:
            // TODO: Handle this case.
            break;
          case MenuType.J_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.MOUNTINGS_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.FINANCE_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.LAND_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.NOTICE_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.ORDER_MANAGE:
            // TODO: Handle this case.
            break;
          case MenuType.MODIFY_PASSWORD:
            // TODO: Handle this case.
            break;
          case MenuType.APP_UPDATE:
            // TODO: Handle this case.
            break;
          case MenuType.SETTINGS:
            // TODO: Handle this case.
            break;
          case MenuType.MESSAGE_CENTER:
            // TODO: Handle this case.
            break;
          case MenuType.CLEAR_CACHE:
            // TODO: Handle this case.
            break;
          case MenuType.CLOCK:
            // TODO: Handle this case.
            break;
        }

        break;
      case UserType.LANDLORD:
        // TODO: Handle this case.
        break;
      case UserType.LITTLE_AGENCY:
        // TODO: Handle this case.
        break;
      case UserType.MASTER:
        // TODO: Handle this case.
        break;
      case UserType.MIDDLE_AGENCY:
        // TODO: Handle this case.
        break;
      case UserType.OWN:
        // TODO: Handle this case.
        break;
      case UserType.BUILDER:
        // TODO: Handle this case.
        break;
      case UserType.OTHER:
        // TODO: Handle this case.
        break;
    }
  }

  Widget _headView() {
    return SizedBox(
      width: double.infinity,
      height: Adapt.px(123 + 118),
      child: Container(
        color: ColorConstants.backgroundColor,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: Adapt.px(123),
              child: Image.asset(
                Constants.ASSETS_IMG + 'user_header_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              child: Padding(
                padding: EdgeInsets.all(Adapt.px(24.0)),
                child:
                    XAvatar(ValueKey(url), url, Adapt.px(141), Adapt.px(141)),
              ),
            ),
            Positioned(
              left: Adapt.px(24.0),
              bottom: Adapt.px(14.0),
              child: SizedBox(
                  width: Adapt.px(141),
                  child: SubLabelText('刘德华', '深圳市南山区', iconUrl: iconUrl)),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: Adapt.px(540 - 24.0 - 141),
                height: Adapt.px(118),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: SubLabelText('4', '地主'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: SubLabelText('31', '完成工单'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: SubLabelText('99+', '待审核'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String iconUrl = Constants.ASSETS_IMG + "icon_location_light_grey.png";
}

class SubLabelText extends StatelessWidget {
  final String label;
  final String subText;
  final String iconUrl;

  SubLabelText(this.label, this.subText, {this.iconUrl = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getViewList(iconUrl),
        ),
      ),
    );
  }

  List<Widget> _getViewList(String iconUrl) {
    List<Widget> list = List();
    Text tLabel = Text(label, style: AppStyle.BlackLabelStyle);
    list.add(tLabel);
    Text tSubText = Text(subText, style: AppStyle.GrayContextStyle);
    if (iconUrl == '') {
      list.add(tSubText);
    } else {
      Row row = Row(children: [
        Image.asset(iconUrl, width: 14, height: 14),
        Text(subText, style: AppStyle.GrayContextStyle)
      ]);
      list.add(row);
    }
    return list;
  }
}
