import 'package:flutter/material.dart';

///
/// des:
///
abstract class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState<BaseWidget> createState() => getState();

  ///子类实现
  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T> {}
