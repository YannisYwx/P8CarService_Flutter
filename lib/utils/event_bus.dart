import 'package:flutter/material.dart';

///
/// des: eventBus 事件总线
///

/// 订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  ///私有构造函数
  EventBus._internal();

  static EventBus get instance => _getInstance();
  static EventBus _instance;

  ///将共有构造函数定义为factory
  ///factory标识的构造函数可以有返回值 所以此时所有的实例化都只会返回静态的私有实例_instance
  factory EventBus() => _instance;

  static EventBus _getInstance() {
    if (_instance == null) {
      _instance = EventBus._internal();
    }
    return _instance;
  }

  var _eventMap = Map<Object, List<EventCallback>>();

  //注册订阅者
  void on(eventName, EventCallback callback) {
    if (eventName == null || callback == null) return;
    _eventMap[eventName] ??= List<EventCallback>();
    _eventMap[eventName].add(callback);
  }

  //移除订阅者
  void off(eventName, EventCallback callback) {
    var list = _eventMap[eventName];
    if (eventName == null || list == null) return;
    if (callback == null) {
      _eventMap[eventName] = null;
    } else {
      list.remove(callback);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _eventMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

//定义一个top-level变量，页面引入该文件后可以直接使用bus
var bus = new EventBus();