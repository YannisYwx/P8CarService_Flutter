import 'package:flutter/material.dart';
import '../constant/color_constant.dart';
import '../constant/app_style.dart';

const int duration = 400;

typedef OnHeaderSelect = void Function(int index);

///
/// 下拉菜单改变回调
///
typedef DropdownMenuChange = void Function(bool isShow, int index);

///
/// des: 下拉选择框
///
class DropdownSelectBox extends StatelessWidget {
  final List<HeaderItem> headerItems;
  final double headerHeight;
  final List<DropdownMenuBuilder> menus;

  final DropdownMenuChange dropdownMenuChange;

  int _currentSelectIndex;

  DropdownNotifier _notifier;

  DropdownSelectBox(
      {@required this.headerItems,
      this.headerHeight = 48,
      @required this.menus,
      this.dropdownMenuChange}) :
    _notifier = DropdownNotifier();



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            left: 0.0,
            child: DropdownBoxHeader(headerItems, (index) {
              // setState(() {
                _currentSelectIndex = index;
              // });
            }, headerHeight, _notifier),
          ),
          DropdownMenu(
            dropdownMenuChanged: dropdownMenuChange,
            headerHeight: headerHeight,
            menus: menus,
            selectItemIndex: _currentSelectIndex,
            notifier: _notifier,
          ),
        ],
      ),
    );
  }
}

// class _DropdownSelectBoxState extends State<DropdownSelectBox>
//     with SingleTickerProviderStateMixin {
//
//   int _currentSelectIndex;
//
//   DropdownNotifier _notifier;
//
//   @override
//   void initState() {
//     print(
//         '+++++++++++++++++++++++++++++++++++++++++++_DropdownSelectBoxState ========initState');
//     _notifier = DropdownNotifier();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(
//         '+++++++++++++++++++++++++++++++++++++++++++_DropdownSelectBoxState ========build');
//     return Container(
//       color: Colors.white,
//       child: Stack(
//         children: [
//           Positioned(
//             width: MediaQuery.of(context).size.width,
//             top: 0.0,
//             left: 0.0,
//             child: DropdownBoxHeader(widget.headerItems, (index) {
//               setState(() {
//                 _currentSelectIndex = index;
//               });
//             }, widget.headerHeight, _notifier),
//           ),
//           DropdownMenu(
//             dropdownMenuChanged: widget.dropdownMenuChange,
//             headerHeight: widget.headerHeight,
//             menus: widget.menus,
//             selectItemIndex: _currentSelectIndex,
//             notifier: _notifier,
//           ),
//         ],
//       ),
//     );
//   }
// }

///
/// des: 下拉框头部
///
class DropdownBoxHeader extends StatefulWidget {
  final List<HeaderItem> headerItems;
  final double headerHeight;
  final OnHeaderSelect itemSelect;
  final DropdownNotifier notifier;

  DropdownBoxHeader(
      this.headerItems, this.itemSelect, this.headerHeight, this.notifier);

  @override
  _DropdownBoxHeaderState createState() => _DropdownBoxHeaderState();
}

class _DropdownBoxHeaderState extends State<DropdownBoxHeader>
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
              height: _headerHeight * 0.6,
              color: widget.headerItems.indexOf(headerItem) ==
                      widget.headerItems.length - 1
                  ? Colors.transparent
                  : Colors.grey[400],
            ),
          )
        ],
      ),
      onTap: () {
        int index = widget.headerItems.indexOf(headerItem);
        int menuIndex = widget.notifier.menuIndex;

        widget.headerItems[index].needAnimation = true;

        for (int i = 0; i < widget.headerItems.length; i++) {
          widget.headerItems[i].needAnimation =
              (i == index || (i == menuIndex && widget.notifier.isShow));
          widget.headerItems[i].iconStatus = IconStatus.down;
        }

        print('onTap  index = $index menuIndex = $menuIndex');

        if (index == menuIndex) {
          // 点击当前的菜单
          if (widget.notifier.isShow) {
            //当前的菜单内容是显示状态则关闭
            print('onTap 点击当前的菜单 【点击index = $index 】 隐藏');
            widget.notifier.hide();
            widget.headerItems[index].iconStatus = IconStatus.down;
            widget.headerItems[index].isFocus = false;
          } else {
            // 显示选中的菜单内容
            print('onTap 点击当前的菜单 【点击index = $index 】 显示');
            widget.notifier.show(index);
            widget.headerItems[index].iconStatus = IconStatus.up;
            widget.headerItems[index].isFocus = true;
          }
        } else {
          //点击其他的菜单
          widget.notifier.isFirstHideThenShow = widget.notifier.isShow;
          if (widget.notifier.isShow) {
            print('onTap 【点击index = $index 】 hideToShow');
            widget.notifier.hideToShow(index);
            widget.headerItems[menuIndex].iconStatus = IconStatus.down;
            widget.headerItems[menuIndex].isFocus = false;
          } else {
            print('onTap 【点击index = $index 】 show');
            widget.notifier.show(index);
          }
          widget.headerItems[index].iconStatus = IconStatus.up;
          widget.headerItems[index].isFocus = true;
        }
        setState(() {});
        if (widget.itemSelect != null) {
          widget.itemSelect(widget.headerItems.indexOf(headerItem));
        }

        widget.headerItems.forEach((hi) {
          if (hi.needAnimation) {
            if (hi.iconStatus == IconStatus.down) {
              hi.reverse();
            } else {
              hi.forward();
            }
          }
        });
      },
    );
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
  final DropdownNotifier notifier;
  final Color maskColor;
  final DropdownMenuChange dropdownMenuChanged;

  DropdownMenu({
    this.headerHeight,
    this.menus,
    this.selectItemIndex,
    this.notifier,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.dropdownMenuChanged,
  });

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu>
    with SingleTickerProviderStateMixin {
  bool _isShowDropDownItemWidget = false; //是否显示下拉菜单
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double> _animation;
  AnimationController _controller;

  double _maskColorOpacity;

  double _dropDownHeight;

  int _currentMenuIndex;

  bool _isShowDropBox = false;

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_showDropDownItemWidget);
    _controller = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
  }

  @override
  void dispose() {
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    widget.notifier?.removeListener(_showDropDownItemWidget);
    _controller?.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }

  /// 显示下拉框
  _showDropDownItemWidget() {
    _currentMenuIndex = widget.notifier.menuIndex;
    _dropDownHeight =
        widget.menus[_currentMenuIndex].dropDownHeight; //更新当前的菜单高度
    if (_currentMenuIndex >= widget.menus.length ||
        widget.menus[_currentMenuIndex] == null) {
      return;
    }

    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    // if (widget.dropdownMenuChanging != null) {
    //   widget.dropdownMenuChanging(_isShowDropDownItemWidget, _currentMenuIndex);
    // }
    if (!_isShowMask) {
      _isShowMask = true;
    }
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation =
        new Tween<double>(begin: 0.0, end: _dropDownHeight).animate(_controller)
          ..addListener(_animationListener)
          ..addStatusListener(_animationStatusListener);

    if (_isControllerDisposed) return;
    if (widget.notifier.isShow) {
      _controller.forward();
    } else if (widget.notifier.isShowHideAnimation) {
      _controller.reverse();
    } else {
      _controller.value = 0;
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
        if (widget.notifier.isFirstHideThenShow) {
          widget.notifier.showNext();
        }
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(false, _currentMenuIndex);
        }
        break;
      case AnimationStatus.forward:
        // TODO: Handle this case.
        break;
      case AnimationStatus.reverse:
        // TODO: Handle this case.
        break;
      case AnimationStatus.completed:
        if (widget.dropdownMenuChanged != null) {
          widget.dropdownMenuChanged(true, _currentMenuIndex);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    int menuIndex = widget.notifier.menuIndex;
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
            child: widget.menus[menuIndex].dropDownWidget,
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
          widget.notifier.hide();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
//          color: widget.maskColor,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  /// 灰色蒙层
  Widget _createMask() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: duration),
      tween: Tween<double>(
          begin: _isShowDropBox ? 0.0 : 0.3, end: _isShowDropBox ? 0.3 : 0.0),
      builder: (BuildContext context, double value, Widget child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(0, 0, 0, value),
        );
      },
    );
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

  final String title;
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

  void forward() {
    controller.forward();
  }

  void reverse() {
    controller.reverse();
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

class DropdownNotifier extends ChangeNotifier {
  double dropDownHeaderHeight;

  int menuIndex = 0; //当前显示的菜单

  bool isShow = false; //是否显示中

  bool isShowHideAnimation = false;

  bool isFirstHideThenShow = false; //先隐藏再显示

  int thenShowIndex = 0;

  void show(int index) {
    isShow = true;
    menuIndex = index;
    notifyListeners();
  }

  void hide({bool isShowHideAnimation = true}) {
    this.isShowHideAnimation = isShowHideAnimation;
    isShow = false;
    notifyListeners();
  }

  void hideToShow(int index) {
    isFirstHideThenShow = true;
    isShowHideAnimation = true;
    thenShowIndex = index;
    isShow = false;
    notifyListeners();
  }

  void showNext() {
    Future.delayed(Duration(milliseconds: 50), () {
      print('_____showNext');
      isFirstHideThenShow = false;
      isShow = true;
      menuIndex = thenShowIndex;
      notifyListeners();
    });
  }
}
