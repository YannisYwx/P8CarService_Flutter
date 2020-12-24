import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';

import 'entry_type.dart';

///
/// des: 用户菜单
/// 根据不同的用户展示不同的菜单列表
///
class UserMenu {
  final UserType userType;
  final String menuLabel;
  final String iconRes;
  final MenuType menuTye;

  UserMenu(this.userType, this.menuLabel, this.iconRes, this.menuTye);


  @override
  String toString() {
    return 'UserMenu{userType: $userType, menuLabel: $menuLabel, iconRes: $iconRes, menuTye: $menuTye}';
  }

  /// 根据登入类型获取菜单选项
  /// @return 菜单集合
  static List<UserMenu> getUserMenus(UserType userType) {
    List<UserMenu> userMenus = [];
    switch (userType) {
      case UserType.AGENCY:
        {
          //大主菜单
          userMenus.add(new UserMenu(UserType.AGENCY, "个人中心",
              Constants.ASSETS_IMG + 'icon_user.png', MenuType.USER_CENTER));
          userMenus.add(new UserMenu(UserType.AGENCY, "J架管理",
              Constants.ASSETS_IMG + 'icon_settings.png', MenuType.J_MANAGE));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "配件管理",
              Constants.ASSETS_IMG + 'icon_device_settings.png',
              MenuType.MOUNTINGS_MANAGE));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "订单管理",
              Constants.ASSETS_IMG + 'icon_order_manage.png',
              MenuType.ORDER_MANAGE));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "财务管理",
              Constants.ASSETS_IMG + 'icon_money_chart.png',
              MenuType.FINANCE_MANAGE));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "地主管理",
              Constants.ASSETS_IMG + 'icon_user_manager.png',
              MenuType.LAND_MANAGE));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "工单处理",
              Constants.ASSETS_IMG + 'icon_order.png',
              MenuType.WORK_ORDER_PROCESSING));
          userMenus.add(new UserMenu(
              UserType.AGENCY,
              "公告管理",
              Constants.ASSETS_IMG + 'icon_notice.png',
              MenuType.NOTICE_MANAGE));
        }
        break;
      case UserType.INSPECTION:
        {
          userMenus.add(new UserMenu(UserType.INSPECTION, "个人中心",
              Constants.ASSETS_IMG + 'icon_user.png', MenuType.USER_CENTER));
          userMenus.add(new UserMenu(
              UserType.INSPECTION,
              "停车监控",
              Constants.ASSETS_IMG + 'icon_parking_moniter.png',
              MenuType.PARKING_MONITOR));
          userMenus.add(new UserMenu(
              UserType.INSPECTION,
              "设备绑定",
              Constants.ASSETS_IMG + 'icon_system_bug.png',
              MenuType.DEVICE_BINDING));
          userMenus.add(new UserMenu(
              UserType.INSPECTION,
              "设备调试",
              Constants.ASSETS_IMG + 'icon_device_settings.png',
              MenuType.DEVICE_DEBUG));
          userMenus.add(new UserMenu(
              UserType.INSPECTION,
              "工单处理",
              Constants.ASSETS_IMG + 'icon_order.png',
              MenuType.WORK_ORDER_PROCESSING));
          userMenus.add(new UserMenu(UserType.INSPECTION, "签到签出",
              Constants.ASSETS_IMG + 'icon_clock.png', MenuType.CLOCK));
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

    return userMenus;
  }
}

enum MenuType {
  /// 用户中心
  USER_CENTER,

  /// 停车监控
  PARKING_MONITOR,

  /// 设备绑定
  DEVICE_BINDING,

  /// 设备调试
  DEVICE_DEBUG,

  /// 工单处理
  WORK_ORDER_PROCESSING,

  /// J架管理
  J_MANAGE,

  /// 配件管理
  MOUNTINGS_MANAGE,

  /// 财务管理
  FINANCE_MANAGE,

  /// 地主管理
  LAND_MANAGE,

  /// 公告管理
  NOTICE_MANAGE,

  /// 订单管理
  ORDER_MANAGE,

  /// 修改密码
  MODIFY_PASSWORD,

  /// App更新
  APP_UPDATE,

  /// 设置
  SETTINGS,

  /// 消息中心
  MESSAGE_CENTER,

  /// 清理缓存
  CLEAR_CACHE,

  /// 签到签出
  CLOCK,
}
