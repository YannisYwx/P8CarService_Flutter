import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:flutter/cupertino.dart';

///
/// des:
///

final TextStyle _carTypeStyle =
    TextStyle(fontSize: 21, fontWeight: FontWeight.w500);

typedef BerthStatusSelectCallback = void Function(BerthStatus status);

class BerthStatusBox extends StatefulWidget {
  final BerthStatusSelectCallback selectCallback;

  BerthStatusBox(Key key, {this.selectCallback}) : super(key: key);

  @override
  BerthStatusBoxState createState() => BerthStatusBoxState();
}

class BerthStatusBoxState extends State<BerthStatusBox> {
  BerthStatus _status;

  setBerthStatus(BerthStatus status) => setState(() {
        _status = status;
      });

  @override
  void initState() {
    // TODO: implement initState
    print('======================_BerthStatusBoxState  [initState]');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('======================_BerthStatusBoxState  [build]');
    return Container(
      color: Colors.white,
      height: 100,
      child: Center(
        child: CupertinoSegmentedControl<BerthStatus>(
          children: {
            BerthStatus.haveCar: _carTypeTable(
                Constants.getBerthStatusLabel(BerthStatus.haveCar)),
            BerthStatus.noCar:
                _carTypeTable(Constants.getBerthStatusLabel(BerthStatus.noCar)),
            BerthStatus.all:
                _carTypeTable(Constants.getBerthStatusLabel(BerthStatus.all)),
          },
          groupValue: _status,
          onValueChanged: (value) {
            setState(() {
              _status = value;
            });

            if (widget.selectCallback != null) {
              widget.selectCallback(value);
            }
          },
        ),
      ),
    );
  }

  _carTypeTable(String value) {
    return Container(
        child: Text(value, style: _carTypeStyle),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20));
  }
}
