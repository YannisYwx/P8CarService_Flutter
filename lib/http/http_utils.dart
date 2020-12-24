import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:p8_inspection_flutter/bean/login_info.dart';
import 'package:p8_inspection_flutter/http/api.dart';
import 'package:p8_inspection_flutter/http/http_manager.dart';
import 'package:p8_inspection_flutter/http/result_data.dart';

typedef Success<T> = Function(T data, String msg);
typedef Fail = Function(int code, String msg);

///
/// des: 网络操作
///
class HttpUtils {
  /// 账号登录
  static login (
      {@required String loginName,
      @required String password,
      @required APIType loginPath,
      Success<LoginInfo> success,
      Fail fail}) async {
    var params = Map<String, String>();
    params['loginName'] = loginName;
    params['password'] = password;
    ResultData res = await HttpManager.getInstance()
        .post(APITypeValues[loginPath], withLoading: true, params: params);
    if (res.isSuccess) {
      if (success != null) {
        success(LoginInfo.fromJson(res.data), res.msg);
      }
    } else {
      if (fail != null) {
        print('${res.data} , code = ${res.code}, ${res.headers.toString()}');
        fail(res.code, res.msg);
      }
    }
  }
}
