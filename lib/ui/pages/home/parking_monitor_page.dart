import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:p8_inspection_flutter/ui/widget/BerthStatusBox.dart';
import 'package:p8_inspection_flutter/ui/widget/dropdown_select_box.dart';
import 'package:p8_inspection_flutter/ui/widget/select_city_box.dart';
import 'package:p8_inspection_flutter/ui/widget/x_page.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';

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
  int selectProvinceIndex = -1;
  int selectCityIndex = -1;
  int selectAreaIndex = -1;
  int selectStreetIndex = -1;
  int focusLabelIndex = 0;

  StreetSetter _setter;
  List<HeaderItem> headerItems = [];
  List<Address> streets;

  BerthStatus _status;

  String _province, _city, _area, _street, _berthStatus;

  final TextStyle _carTypeStyle =
      TextStyle(fontSize: 21, fontWeight: FontWeight.w500);

  GlobalKey<DropdownSelectBoxState> _boxKey = GlobalKey();
  GlobalKey<BerthStatusBoxState> _statusKey = GlobalKey();

  @override
  void initState() {
    headerItems.clear();
    _setter = StreetSetter();
    dropdownStyle = TextStyle(
        fontSize: Adapt.px(24),
        color: Colors.blue,
        fontWeight: FontWeight.w500);
    normalStyle = TextStyle(
        fontSize: Adapt.px(24),
        color: Colors.black54,
        fontWeight: FontWeight.w300);
    headerItems.add(HeaderItem('泊位地址',
        dropdownStyle: dropdownStyle, normalStyle: normalStyle));
    headerItems.add(HeaderItem('泊位状态',
        dropdownStyle: dropdownStyle, normalStyle: normalStyle));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return XPage(
      context,
      hasBackIcon: true,
      title: '停车监控',
      body: DropdownSelectBox(
        _boxKey,
        dropdownMenuChange: (isShow, index) {
          print('菜单【$index】 ${isShow ? '显示' : '隐藏'}');
          if (index == 1 && isShow) {
            _statusKey.currentState.setBerthStatus(_status);
          }
        },
        headerHeight: Adapt.px(70),
        headerItems: headerItems,
        menus: [
          DropdownMenuBuilder(
              dropDownHeight: 430,
              dropDownWidget: SelectCityBox(
                callback: _callback,
                statusCallback: _onStatusNotify,
                streetSetter: _setter,
                needStreet: true,
                selectProvinceIndex: selectProvinceIndex,
                selectCityIndex: selectCityIndex,
                selectAreaIndex: selectAreaIndex,
                selectStreetIndex: selectStreetIndex,
                focusLabelIndex: focusLabelIndex,
              )),
          DropdownMenuBuilder(
              dropDownHeight: 100,
              dropDownWidget: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: BerthStatusBox(_statusKey, selectCallback: (status) {
                  _status = status;
                  _berthStatus = Constants.getBerthStatusLabel(status);
                  if (_street == null || _street.isEmpty) {
                    _boxKey.currentState.hideToShow(
                        hideIndex: 1, showIndex: 0, hideLabel: _berthStatus);
                  } else {
                    _boxKey.currentState
                        .hide(index: 1, hideLabel: _berthStatus);
                  }
                }),
              )),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: XAppBar(context, '停车监控'),
  //     body: DropdownSelectBox(
  //       _boxKey,
  //       dropdownMenuChange: (isShow, index) {
  //         print('菜单【$index】 ${isShow ? '显示' : '隐藏'}');
  //         if (index == 1 && isShow) {
  //           _statusKey.currentState.setBerthStatus(_status);
  //         }
  //       },
  //       headerHeight: Adapt.px(70),
  //       headerItems: headerItems,
  //       menus: [
  //         DropdownMenuBuilder(
  //             dropDownHeight: 430,
  //             dropDownWidget: SelectCityBox(
  //               callback: _callback,
  //               statusCallback: _onStatusNotify,
  //               streetSetter: _setter,
  //               needStreet: true,
  //               selectProvinceIndex: selectProvinceIndex,
  //               selectCityIndex: selectCityIndex,
  //               selectAreaIndex: selectAreaIndex,
  //               selectStreetIndex: selectStreetIndex,
  //               focusLabelIndex: focusLabelIndex,
  //             )),
  //         DropdownMenuBuilder(
  //             dropDownHeight: 100,
  //             dropDownWidget: SingleChildScrollView(
  //               physics: NeverScrollableScrollPhysics(),
  //               child: BerthStatusBox(_statusKey, selectCallback: (status) {
  //                 _status = status;
  //                 _berthStatus = Constants.getBerthStatusLabel(status);
  //                 if (_street == null || _street.isEmpty) {
  //                   _boxKey.currentState.hideToShow(
  //                       hideIndex: 1, showIndex: 0, hideLabel: _berthStatus);
  //                 } else {
  //                   _boxKey.currentState
  //                       .hide(index: 1, hideLabel: _berthStatus);
  //                 }
  //               }),
  //             )),
  //       ],
  //     ),
  //   );
  // }

  void _callback(String province, String city, String area, String street) {
    _province = province;
    _city = city;
    _area = area;
    _street = street;
    if (_street != null && _street.isNotEmpty) {
      if (_berthStatus != null && _berthStatus.isNotEmpty) {
        _boxKey.currentState.hide(index: 0, hideLabel: _street);
      } else {
        _boxKey.currentState
            .hideToShow(hideIndex: 0, showIndex: 1, hideLabel: _street);
      }
    }
    if (area != null && street == null) {
      streets = List();
      streets.add(Address(name: "测试路一"));
      streets.add(Address(name: "测试路二"));
      streets.add(Address(name: "测试路三"));
      streets.add(Address(name: "测试路四"));
      streets.add(Address(name: "测试路五"));
      streets.add(Address(name: "测试路六"));
      streets.add(Address(name: "测试路七"));
      Future.delayed(Duration(milliseconds: 1000), () {
        _setter.setStreet(data: streets);
      });
    }
  }

  void _onStatusNotify(int selectProvinceIndex, int selectCityIndex,
      int selectAreaIndex, int selectStreetIndex, int focusLabelIndex) {
    this.selectProvinceIndex = selectProvinceIndex;
    this.selectCityIndex = selectCityIndex;
    this.selectAreaIndex = selectAreaIndex;
    this.selectStreetIndex = selectStreetIndex;
    this.focusLabelIndex = focusLabelIndex;
  }
}
