import 'package:flutter/material.dart';
import '../../widget/x_appbar.dart';

import '../../widget/dropdown_select_box.dart';
import '../../widget/select_city_box.dart';
import '../../utils/screen_adapter.dart';
import '../../constant/color_constant.dart';

///
/// des: 停车监控
///
class ParkingMonitorPage extends StatefulWidget {
  @override
  _ParkingMonitorPageState createState() => _ParkingMonitorPageState();
}

class _ParkingMonitorPageState extends State<ParkingMonitorPage> {
  TextStyle dropdownStyle;
  TextStyle normalStyle;
   int selectProvinceIndex;
   int selectCityIndex;
   int selectAreaIndex;
   int selectStreetIndex;
   int focusLabelIndex = 0;
  @override
  void initState() {
    dropdownStyle = TextStyle(
        fontSize: Adapt.px(24),
        color: Colors.blue,
        fontWeight: FontWeight.w500);
    normalStyle = TextStyle(
        fontSize: Adapt.px(24),
        color: ColorConstants.textBlack,
        fontWeight: FontWeight.w300);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('****************************build*******************************');
    SelectCityBox selectCityBox = SelectCityBox(
      callback: _callback,
      statusCallback: _onStatusNotify,
    );
    return Scaffold(
      appBar: XAppBar(context, '停车监控'),
      body: DropdownSelectBox(
        dropdownMenuChange: (isShow, index) {
          print('菜单【$index】 ${isShow ? '显示' : '隐藏'}');
        },
        headerHeight: Adapt.px(70),
        headerItems: [
          HeaderItem('泊位地址',
              dropdownStyle: dropdownStyle, normalStyle: normalStyle),
          HeaderItem('车辆类型',
              dropdownStyle: dropdownStyle, normalStyle: normalStyle),
        ],
        menus: [
          DropdownMenuBuilder(
              dropDownHeight: 430, dropDownWidget: selectCityBox),
          DropdownMenuBuilder(
              dropDownHeight: 200,
              dropDownWidget: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  color: Colors.green,
                  height: 200,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text('有车'),
                      Text('无车'),
                      Text('全部'),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _callback(String province, String city, String area, String street) {
    print('------------$province : $city : $area : $street');
  }

  void _onStatusNotify(int selectProvinceIndex, int selectCityIndex,
      int selectAreaIndex, int selectStreetIndex, int focusLabelIndex) {
    this.selectProvinceIndex = selectProvinceIndex;
    this.selectCityIndex = selectCityIndex;
    this.selectAreaIndex = selectAreaIndex;
    this.selectStreetIndex = selectStreetIndex;
    this.focusLabelIndex = focusLabelIndex;
    print('_onStatusNotify------------$selectProvinceIndex : $selectCityIndex : $selectAreaIndex : $selectAreaIndex : $focusLabelIndex');
  }
}
