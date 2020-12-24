///
/// des: 网络返回数据封装
///
class ResultData {
  ///目标数据
  var data;

  /// 消息
  String msg;

  ///是否成功
  bool isSuccess;

  /// 返回码
  int code;

  /// 请求头
  var headers;

  ResultData(this.data, this.msg, this.isSuccess, this.code, {this.headers});
}
