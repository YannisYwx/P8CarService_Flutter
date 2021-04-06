import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/color_constant.dart';

const int duration = 400;

typedef OnHeaderSelect = void Function(int index);

///
/// 下拉菜单改变回调
///
typedef DropdownMenuChange = void Function(bool isShow, int index);

///
/// des: 下拉选择框
///
class DropdownSelectBox extends StatefulWidget {
  final List<HeaderItem> headerItems;
  final double headerHeight;
  final List<DropdownMenuBuilder> menus;

  final DropdownMenuChange dropdownMenuChange;

  final GlobalKey<DropdownBoxHeaderState> headerKey = GlobalKey();
  final GlobalKey<DropdownMenuState> menuKey = GlobalKey();

  DropdownSelectBox(Key key,
      {@required this.headerItems,
      this.headerHeight = 48,
      @required this.menus,
      this.dropdownMenuChange})
      : super(key: key);

  @override
  DropdownSelectBoxState createState() => DropdownSelectBoxState();
}

class DropdownSelectBoxState extends State<DropdownSelectBox> {
  int _currentSelectIndex;

  @override
  Widget build(BuildContext context) {
    print(
        '=================================================================================================DropdownSelectBoxState [build]');
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            left: 0.0,
            child: DropdownBoxHeader(widget.headerKey,
                headerHeight: widget.headerHeight,
                headerItems: widget.headerItems,
                menuKey: widget.menuKey, itemSelect: (index) {
              _currentSelectIndex = index;
            }),
          ),
          DropdownMenu(
            widget.menuKey,
            headerKey: widget.headerKey,
            dropdownMenuChanged: widget.dropdownMenuChange,
            headerHeight: widget.headerHeight,
            menus: widget.menus,
            selectItemIndex: _currentSelectIndex,
          ),
        ],
      ),
    );
  }

  void hide({@required int index, String hideLabel}) {
    widget.menuKey.currentState.hide(index);
    if (hideLabel != null && hideLabel.isNotEmpty) {
      widget.headerItems[index].title = hideLabel;
    }
  }

  void show({@required int index}) {
    widget.menuKey.currentState.show(index);
  }

  void hideToShow(
      {@required int hideIndex, @required int showIndex, String hideLabel}) {
    hide(index: hideIndex);
    if (hideLabel != null && hideLabel.isNotEmpty) {
      widget.headerItems[hideIndex].title = hideLabel;
    }
    Future.delayed(Duration(milliseconds: duration + 50), () {
      show(index: showIndex);
    });
  }
}

///
/// des: 下拉框头部
///
class DropdownBoxHeader extends StatefulWidget {
  final List<HeaderItem> headerItems;
  final double headerHeight;
  final OnHeaderSelect itemSelect;
  final GlobalKey<DropdownMenuState> menuKey;

  DropdownBoxHeader(Key key,
      {this.headerItems, this.itemSelect, this.headerHeight, this.menuKey})
      : super(key: key);

  @override
  DropdownBoxHeaderState createState() => DropdownBoxHeaderState();
}

class DropdownBoxHeaderState extends State<DropdownBoxHeader>
    with TickerProviderStateMixin {
  double _headerHeight;
  double _screenWidth;
  int _menuCount;

  @override
  void initState() {
    _headerHeight = widget.headerHeight;
    widget.headerItems.forEach((hi) {
      hi.setController(
          controller: AnimationController(
              duration: const Duration(milliseconds: 200), vsync: this));
    });
    super.initState();
  }

  ///
  /// 箭头向下
  ///
  arrowDown(int index, {String label}) {
    _resetHeaderItem(index, isUp: false, label: label);
  }

  ///
  /// 箭头向上
  ///
  arrowUp(int index, {String label}) {
    _resetHeaderItem(index, isUp: true, label: label);
  }

  _resetHeaderItem(int index, {@required bool isUp, String label}) {
    widget.headerItems[index].isFocus = isUp;
    widget.headerItems[index].needAnimation = true;
    widget.headerItems[index].iconStatus =
        isUp ? IconStatus.up : IconStatus.down;
    if (isUp) {
      widget.headerItems[index].controller.forward();
    } else {
      widget.headerItems[index].controller.reverse();
    }
    if (!(label == null || label.isEmpty)) {
      widget.headerItems[index].title = label;
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.headerItems.forEach((hi) {
      hi.controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _menuCount = widget.headerItems.length;
    var gridView = GridView.count(
      crossAxisCount: _menuCount,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: (_screenWidth / _menuCount) / _headerHeight,
      children: widget.headerItems.map((e) => _createHeader(e)).toList(),
    );
    return Container(
      height: _headerHeight,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: .51, color: Colors.grey[300]),
      )),
      child: gridView,
    );
  }

  /// 创建头部Item
  Widget _createHeader(HeaderItem headerItem) {
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(headerItem.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _itemStyle(headerItem)),
                ),
                SizedBox(
                  width: 5,
                ),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5)
                      .animate(headerItem.controller),
                  child: Icon(
                    headerItem.iconData,
                    size: _itemStyle(headerItem).fontSize * 1.5,
                    color: _itemStyle(headerItem).color,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -.05,
            child: Container(
              width: 0.68,
              height: _headerHeight * 0.5,
              color: widget.headerItems.indexOf(headerItem) ==
                      widget.headerItems.length - 1
                  ? Colors.transparent
                  : Colors.grey[300],
            ),
          )
        ],
      ),
      onTap: () => _onHeaderTap(headerItem),
    );
  }

  _onHeaderTap(HeaderItem headerItem) {
    int index = widget.headerItems.indexOf(headerItem);
    int menuIndex = widget.menuKey.currentState.currentMenuIndex;
    if (index == menuIndex) {
      // 点击当前的菜单
      if (widget.menuKey.currentState.isShowDropBox) {
        //当前的菜单内容是显示状态则关闭
        widget.menuKey.currentState.hide(index);
      } else {
        // 显示选中的菜单内容
        widget.menuKey.currentState.show(index);
      }
    } else {
      //点击其他的菜单
      if (widget.menuKey.currentState.isShowDropBox) {
        widget.menuKey.currentState.hideToShow(menuIndex, index);
      } else {
        widget.menuKey.currentState.show(index);
      }
    }
  }

  TextStyle _itemStyle(HeaderItem headerItem) {
    return headerItem.isFocus
        ? headerItem.dropdownStyle
        : headerItem.normalStyle;
  }
}

class DropdownMenu extends StatefulWidget {
  final double headerHeight;
  final List<DropdownMenuBuilder> menus;
  final int selectItemIndex;
  final Color maskColor;
  final DropdownMenuChange dropdownMenuChanged;
  final GlobalKey<DropdownBoxHeaderState> headerKey;

  DropdownMenu(
    Key key, {
    this.headerKey,
    this.headerHeight,
    this.menus,
    this.selectItemIndex,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownMenuChanged,
  }) : super(key: key);

  @override
  DropdownMenuState createState() => DropdownMenuState();
}

class DropdownMenuState extends State<DropdownMenu>
    with SingleTickerProviderStateMixin {
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double> _animation;
  AnimationController _controller;

  double _maskColorOpacity;

  double _dropDownHeight;

  int currentMenuIndex = 0;

  bool isShowDropBox = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
  }

  @override
  void dispose() {
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _controller?.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  show(int index) {
    _showOrHide(index, true);
  }

  hide(int index) {
    _showOrHide(index, false);
  }

  void hideToShow(int hideIndex, int showIndex) {
    hide(hideIndex);
    Future.delayed(Duration(milliseconds: duration + 50), () {
      show(showIndex);
    });
  }

  _showOrHide(int index, bool isShow) {
    if (index >= widget.menus.length || widget.menus[index] == null) {
      return;
    }
    isShowDropBox = isShow;
    if (isShowDropBox) {
      currentMenuIndex = index;
    }
    _dropDownHeight = widget.menus[currentMenuIndex].dropDownHeight; //更新当前的菜单高度
    if (!_isShowMask) {
      _isShowMask = true;
    }
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation =
        Tween<double>(begin: 0.0, end: _dropDownHeight).animate(_controller)
          ..addListener(_animationListener)
          ..addStatusListener(_animationStatusListener);
    if (_isControllerDisposed) return;
    if (isShow) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  ///
  /// 动画监听器 动画进行过程中回不停的调用该监听
  ///
  void _animationListener() {
    double heightScale = _animation.value / _dropDownHeight;
    _maskColorOpacity = widget.maskColor.opacity * heightScale;
    setState(() {}); //这行如果不写，没有动画效果
  }

  ///
  ///动画状态监听器
  ///
  _animationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _isShowMask = false;
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(false, currentMenuIndex);
        }
        break;
      case AnimationStatus.forward:
        widget.headerKey.currentState.arrowUp(currentMenuIndex);
        break;
      case AnimationStatus.reverse:
        widget.headerKey.currentState.arrowDown(currentMenuIndex);
        break;
      case AnimationStatus.completed:
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(true, currentMenuIndex);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      top: widget.headerHeight,
      left: 0.0,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: _animation == null ? 0 : _animation.value,
            child: widget.menus[currentMenuIndex].dropDownWidget,
          ),
          _mask(),
        ],
      ),
    );
  }

  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          hide(currentMenuIndex);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}

class DropdownMenuBuilder {
  final Widget dropDownWidget;
  final double dropDownHeight;

  DropdownMenuBuilder(
      {@required this.dropDownWidget, @required this.dropDownHeight});
}

class HeaderItem {
  static const FOCUS_STYLE = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: ColorConstants.textBlack); //标题字体样式

  static const NORMAL_STYLE = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: ColorConstants.textLightGray); //灰色字体样式

  String title;
  final Color focusColor;
  final Color normalColor;
  final IconData iconData;
  TextStyle dropdownStyle;
  TextStyle normalStyle;
  IconStatus iconStatus; //默认是向下
  bool needAnimation; //是否需要执行动画
  bool isFocus = false;

  AnimationController controller;

  HeaderItem(
    this.title, {
    this.controller,
    this.focusColor = Colors.blue,
    this.normalColor = Colors.black54,
    this.iconData = Icons.keyboard_arrow_down,
    this.dropdownStyle = FOCUS_STYLE,
    this.normalStyle = NORMAL_STYLE,
    this.iconStatus = IconStatus.up,
    this.needAnimation = false,
  });

  void setController({@required AnimationController controller}) {
    this.controller = controller;
  }

  void forward({double from}) {
    controller.forward(from: from);
  }

  void reverse({double from}) {
    controller.reverse(from: from);
  }

  @override
  String toString() {
    return 'HeaderItem{title: $title, focusColor: $focusColor, normalColor: $normalColor, iconData: $iconData, dropdownStyle: $dropdownStyle, normalStyle: $normalStyle}';
  }
}

enum IconStatus {
  up,
  down,
  none,
}