import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import '../bean/province_city_area.dart';

typedef SelectCallback = void Function(
    String province, String city, String area, String street);

typedef StatusCallback = void Function(
    int selectProvinceIndex,
    int selectCityIndex,
    int selectAreaIndex,
    int selectStreetIndex,
    int focusLabelIndex);

///
/// des: 地址选择控件
///
// ignore: must_be_immutable
class SelectCityBox extends StatefulWidget {
  static const INDEX_PROVINCE = 0;
  static const INDEX_CITY = 1;
  static const INDEX_AREA = 2;
  static const INDEX_STREET = 3;

  final SelectCallback callback;
  final StatusCallback statusCallback;

  final double fontSize;
  final Color focusColor;
  final Color textColor;
  final Color indicatorColor;
  final Decoration decoration;
  final bool needStreet; //是否需要显示街道 默认不显示。一般来说按照业务需求，需要的街道都是从后台获取的
  StreetSetter streetSetter; //设置街道
  int selectProvinceIndex = -1;
  int selectCityIndex = -1;
  int selectAreaIndex = -1;
  int selectStreetIndex = -1;
  int focusLabelIndex = INDEX_PROVINCE;

  final Widget emptyView;

  SelectCityBox(
      {@required this.callback,
      this.fontSize = 18.0,
      this.focusColor,
      this.textColor,
      this.indicatorColor,
      this.decoration,
      this.needStreet = true,
      this.statusCallback,
      this.streetSetter,
      this.selectProvinceIndex = -1,
      this.selectCityIndex = -1,
      this.selectAreaIndex = -1,
      this.selectStreetIndex = -1,
      this.focusLabelIndex = INDEX_PROVINCE,
      this.emptyView});

  @override
  _SelectCityBoxState createState() => _SelectCityBoxState();
}

class _SelectCityBoxState extends State<SelectCityBox>
    with SingleTickerProviderStateMixin {
  static const String toSelect = '请选择';
  static const double PAD = 8.0; //标题和指示器的间距

  List<AddressLabel> als;

  List<Address> provinces;
  List<Address> cities;
  List<Address> areas;
  List<Address> streets;

  String selectProvince; //当前选中的省
  String selectCity; //当前选中的城市
  String selectArea; //当前选中的区域
  String selectStreet; //当前选中的街道

  List<Province> provinceData;
  Province _province;
  City _city;

  AnimationController _controller;
  Animation _animation;
  double _startX, _stopX, _indicatorWidth = 54;
  GlobalKey _provinceKey = GlobalKey();
  GlobalKey _cityKey = GlobalKey();
  GlobalKey _areaKey = GlobalKey();
  GlobalKey _streetKey = GlobalKey();
  int currentIndex = SelectCityBox.INDEX_PROVINCE;

  BoxDecoration _decoration;
  double _fontSize;
  Color _focusColor;
  Color _textColor;
  Color _indicatorColor;

  bool isEmpty = true;

  initAddressData(int selectProvinceIndex, int selectCityIndex,
      int selectAreaIndex, int selectStreetIndex, int focusLabelIndex) {}

  @override
  void initState() {
    print('=================================================SelectCityBox=============initState');
    _initData();
    super.initState();
  }

  _initStyle(BuildContext context) {
    _fontSize = widget.fontSize == null ? 18.0 : widget.fontSize;
    _indicatorColor = widget.indicatorColor == null
        ? Theme.of(context).primaryColor
        : widget.indicatorColor;
    _focusColor = widget.focusColor == null
        ? Theme.of(context).primaryColor
        : widget.focusColor;
    _textColor = widget.textColor == null ? Colors.black54 : widget.textColor;

    if (widget.streetSetter == null) {
      widget.streetSetter = StreetSetter();
    }

    _decoration = widget.decoration == null
        ? BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 1.5, spreadRadius: 1.0)
            ],
            border: Border.all(color: Colors.white)) //默认背景
        : widget.decoration;
  }

  _initData() {
    if (widget.streetSetter == null) {
      widget.streetSetter = StreetSetter();
    }
    selectProvince = toSelect;
    selectCity = toSelect;
    selectArea = toSelect;
    selectStreet = toSelect;
    currentIndex = widget.focusLabelIndex;
    _fontSize = widget.fontSize == null ? 18.0 : widget.fontSize;

    provinceData = ProvinceData.getProvinces();
    _fillProvinces(selectIndex: widget.selectProvinceIndex);
    _fillCities(selectIndex: widget.selectCityIndex);
    _fillAreas(selectIndex: widget.selectAreaIndex);
    streets = widget.streetSetter.data == null ? List() : widget.streetSetter.data;
    initAddressLabels(widget.focusLabelIndex,
        isCityVisible: widget.selectCityIndex != -1,
        isAreaVisible: widget.selectAreaIndex != -1,
        isStreetVisible: widget.selectStreetIndex != -1); //默认第一个高亮
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    widget.streetSetter?.addListener(_streetDataChanged);
  }

  _streetDataChanged() {
    streets = widget.streetSetter.data;
    setState(() {});
  }

  _fillProvinces({int selectIndex = -1}) {
    if (provinces != null) {
      provinces.clear();
      provinces = null;
    }
    provinces = provinceData
        .map((e) => Address(name: e.name, isSelect: false))
        .toList();
    if (selectIndex != -1) {
      _province = provinceData[selectIndex];
      provinces[selectIndex].isSelect = true;
      selectProvince = provinces[selectIndex].name;
    }
  }

  _fillCities({int selectIndex = -1}) {
    if (_province != null) {
      if (cities != null) {
        cities.clear();
        cities = null;
      }
      cities = _province.cities
          .map((e) => Address(name: e.name, isSelect: false))
          .toList();
      if (selectIndex != -1) {
        _city = _province.cities[selectIndex];
        cities[selectIndex].isSelect = true;
        selectCity = cities[selectIndex].name;
      }
    }
  }

  _fillAreas({int selectIndex = -1}) {
    if (_city != null) {
      areas = _city.area.map((e) => Address(name: e, isSelect: false)).toList();
    }
    if (selectIndex != -1 && areas != null) {
      areas[selectIndex].isSelect = true;
      selectArea = areas[selectIndex].name;
    }
  }

  List<Address> _currentListData() {
    switch (widget.focusLabelIndex) {
      case SelectCityBox.INDEX_PROVINCE:
        return provinces;
      case SelectCityBox.INDEX_CITY:
        return cities;
      case SelectCityBox.INDEX_AREA:
        return areas;
      default:
        return streets;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.streetSetter?.removeListener(_streetDataChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initStyle(context);
    isEmpty = _currentListData().isEmpty && widget.streetSetter.isEmpty;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 530,
        decoration: widget.decoration == null ? _decoration : widget.decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        als.map((als) => _createLabelView(als)).toList())),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 5,
              color: Colors.white,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Divider(
                      thickness: 0.8,
                      height: 0,
                      color: Colors.grey[300],
                    ),
                  ),
                  _createIndicator(),
                ],
              ),
            ),
            SizedBox(
              height: 380,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Address address = _currentListData()[index];
                        return InkWell(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              alignment: Alignment.centerLeft,
                              color: address.isSelect
                                  ? Colors.black12
                                  : Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: PAD),
                                child: Text(_currentListData()[index].name,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: _fontSize,
                                        fontWeight: FontWeight.w400,
                                        color: address.isSelect
                                            ? _focusColor
                                            : _textColor)),
                              )),
                          onTap: () => _onItemClick(context, index),
                        );
                      },
                      itemCount: _currentListData().length,
                    ),
                  ),
                  _emptyView(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _emptyView() {
    return Offstage(
      offstage: !isEmpty,
      child: widget.emptyView == null
          ? Column(
              children: [
                SizedBox(height: 40),
                SizedBox(
                  width: 350 * 0.3,
                  height: 420 * 0.3,
                  child: AspectRatio(
                    aspectRatio: 42 / 35,
                    child: Image.asset(
                      Constants.ASSETS_IMG + "pic_no_data.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '暂时没找到数据~',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 18),
                ),
              ],
            )
          : widget.emptyView,
    );
  }

  ///
  /// 点击列表选中当前的地址
  ///
  _onItemClick(BuildContext context, int index) {
    widget.streetSetter.isEmpty = false;
    Address address = _currentListData()[index];
    _currentListData().forEach((element) {
      element.isSelect = (element == address);
    });

    currentIndex++;
    int focusIndex = currentIndex - 1;

    //不需要显示街道
    if (currentIndex == SelectCityBox.INDEX_STREET && !widget.needStreet) {
      currentIndex = SelectCityBox.INDEX_AREA;
      selectArea = address.name;
      focusIndex = SelectCityBox.INDEX_AREA;
    } else if (currentIndex > SelectCityBox.INDEX_STREET) {
      //原本就是街道
      focusIndex = SelectCityBox.INDEX_STREET;
      currentIndex = SelectCityBox.INDEX_STREET;
      selectStreet = address.name;
      if (widget.callback != null) {
        widget.callback(selectProvince, selectCity, selectArea, selectStreet);
      }
    } else if (currentIndex == SelectCityBox.INDEX_STREET) {
      selectStreet = toSelect;
      selectArea = address.name;
      if (streets.isEmpty) {
        if (widget.callback != null) {
          widget.callback(selectProvince, selectCity, selectArea, null);
        }
      }
    } else if (currentIndex == SelectCityBox.INDEX_CITY) {
      _province = provinceData[index];
      selectProvince = _province.name;
      selectCity = toSelect;
      selectArea = toSelect;
      selectStreet = toSelect;
      _fillCities(selectIndex: widget.selectCityIndex);
    } else if (currentIndex == SelectCityBox.INDEX_AREA) {
      _city = _province.cities.firstWhere((city) => city.name == address.name);
      selectCity = _city.name;
      selectArea = toSelect;
      selectStreet = toSelect;
      _fillAreas(selectIndex: widget.selectAreaIndex);
    }

    initAddressLabels(focusIndex,
        isCityVisible: currentIndex >= SelectCityBox.INDEX_CITY,
        isAreaVisible: currentIndex >= SelectCityBox.INDEX_AREA,
        isStreetVisible:
            currentIndex == SelectCityBox.INDEX_STREET && widget.needStreet);
    _moveIndicator(currentIndex);

    if (widget.callback != null) {
      widget.callback(
          selectProvince == toSelect ? '' : selectProvince,
          selectCity == toSelect ? '' : selectCity,
          selectArea == toSelect ? '' : selectArea,
          selectStreet == toSelect ? '' : selectStreet);
    }
    _notifyStatus();
    setState(() {});
  }

  _notifyStatus() {
    widget.selectProvinceIndex = -1;
    widget.selectCityIndex = -1;
    widget.selectAreaIndex = -1;
    widget.selectAreaIndex = -1;
    widget.focusLabelIndex = currentIndex;

    if (selectProvince != toSelect) {
      widget.selectProvinceIndex =
          provinceData.indexWhere((p) => p.name == selectProvince);
    }
    if (selectCity != toSelect) {
      widget.selectCityIndex = cities.indexWhere((c) => c.name == selectCity);
    }
    if (selectArea != toSelect) {
      widget.selectAreaIndex = areas.indexWhere((c) => c.name == selectArea);
    }
    if (streets != null && selectStreet != toSelect) {
      widget.selectStreetIndex =
          streets.indexWhere((c) => c.name == selectStreet);
    }

    if (widget.statusCallback != null) {
      widget.statusCallback(
          widget.selectProvinceIndex,
          widget.selectCityIndex,
          widget.selectAreaIndex,
          widget.selectStreetIndex,
          widget.focusLabelIndex);
    }
  }

  ///
  /// 初始化头部
  ///
  List<AddressLabel> initAddressLabels(int focusIndex,
      {bool isCityVisible = false,
      bool isAreaVisible = false,
      bool isStreetVisible = false}) {
    if (als != null) {
      als.clear();
      als = null;
    }
    als = List<AddressLabel>();
    als.add(AddressLabel(_provinceKey,
        isFocus: focusIndex == SelectCityBox.INDEX_PROVINCE,
        value: selectProvince,
        isVisible: true));
    als.add(AddressLabel(_cityKey,
        isFocus: focusIndex == SelectCityBox.INDEX_CITY,
        value: selectCity,
        isVisible: isCityVisible));
    als.add(AddressLabel(_areaKey,
        isFocus: focusIndex == SelectCityBox.INDEX_AREA,
        value: selectArea,
        isVisible: isAreaVisible));
    als.add(AddressLabel(_streetKey,
        isFocus: focusIndex == SelectCityBox.INDEX_STREET,
        value: selectStreet,
        isVisible: isStreetVisible));

    _indicatorWidth =
        als.firstWhere((al) => al.isFocus).value.length * _fontSize;
    return als;
  }

  _animationListener() {
    setState(() {}); //更新数据
  }

  _animationStatusListener(AnimationStatus status) {}

  ///
  /// 移动指示器
  ///
  void _moveIndicator(int index) {
    if (currentIndex == SelectCityBox.INDEX_STREET && !widget.needStreet) {
      return;
    }
    currentIndex = index;
    _notifyStatus();
    int focusIndex = als.indexWhere((element) => element.isFocus);
    if (index == focusIndex) return;
    als[index].isFocus = true;
    als[focusIndex].isFocus = false;

    // GlobalKey currentKey = als[focusIndex].key;
    // RenderBox renderBoxStart = currentKey.currentContext.findRenderObject();
    // Size currentSize = renderBoxStart.size; //大小
    // Offset currentOffset = renderBoxStart.localToGlobal(Offset.zero);
    // _startX = currentOffset.dx;
    //
    // GlobalKey toKey = als[index].key;
    // RenderBox renderBoxStop = toKey.currentContext.findRenderObject();
    // Size toSize = renderBoxStop.size; //大小
    // Offset toOffset = renderBoxStop.localToGlobal(Offset.zero);
    // _stopX = toOffset.dx;

    _startX = PAD;
    for (int i = 0; i < focusIndex; i++) {
      _startX = _startX + als[i].value.length * _fontSize + PAD;
    }

    _stopX = PAD;
    for (int i = 0; i < index; i++) {
      _stopX = _stopX + als[i].value.length * _fontSize + PAD;
    }
    _indicatorWidth = als[index].value.length * _fontSize;
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation =
        new Tween<double>(begin: _startX, end: _stopX).animate(_controller)
          ..addListener(_animationListener)
          ..addStatusListener(_animationStatusListener);
    _controller.forward(from: 0);
  }

  double _defaultPad() {
    double left = PAD;
    for (int i = 0; i < widget.focusLabelIndex; i++) {
      left = left + PAD + als[i].value.length * _fontSize;
    }
    return left;
  }

  Widget _createIndicator() {
    return Positioned(
        left: _animation == null ? _defaultPad() : _animation.value,
        child: Container(
            width: _indicatorWidth, height: 4, color: _indicatorColor));
  }

  Widget _createLabelView(AddressLabel label) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: PAD, top: PAD, bottom: PAD),
        child: Offstage(
          offstage: !(label.isFocus || label.isVisible),
          child: Text(
            label.value,
            key: label.key,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _fontSize,
                color: label.isFocus ? _focusColor : _textColor),
          ),
        ),
      ),
      onTap: () => _moveIndicator(als.indexOf(label)),
    );
  }
}

class AddressLabel {
  static const TextStyle FS =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue);
  static const TextStyle NS = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey);

  final String value;
  final bool isVisible;

  bool isFocus;
  final GlobalKey key;

  AddressLabel(
    this.key, {
    @required this.value,
    this.isFocus = false,
    this.isVisible = false,
  });

  @override
  String toString() {
    return 'AddressLabel{value: $value, isVisible: $isVisible, isFocus: $isFocus}';
  }
}

class Address {
  final String name;
  bool isSelect;

  Address({this.name, this.isSelect = false});
}

///
/// 街道数据填充
///
class StreetSetter extends ChangeNotifier {
  List<Address> data;
  bool isEmpty = false;

  setStreet({@required List<Address> data, bool isEmpty}) {
    this.data = (data == null ? List() : data);
    if (isEmpty != null) {
      this.isEmpty = isEmpty;
    } else {
      this.isEmpty = this.data == null || this.data.isEmpty;
    }
    notifyListeners();
  }
}
