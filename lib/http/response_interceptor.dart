import 'package:dio/dio.dart';
import 'package:p8_inspection_flutter/http/api.dart';
import 'package:p8_inspection_flutter/http/result_data.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    print('data ${option.data}');
    print('contentType ${option.contentType}');
    print('path ${option.path}');
    print('queryParameters ${option.queryParameters}');
    print('statusCode ${response.statusCode}');
    try {
      if (option.contentType != null && option.contentType.contains("text")) {
        return ResultData(response.data, 'success', true, 200);
      }

      ///一般只需要处理200的情况，300、400、500保留错误信息，外层为http协议定义的响应码
      if (response.statusCode == 200 || response.statusCode == 201) {
        ///内层需要根据公司实际返回结构解析，一般会有code，data，msg字段
        int code = response.data["code"];
        print('ResponseInterceptors[onResponse]  code   $code');
        String msg = response.data['msg'];
        print('ResponseInterceptors[onResponse]  $msg');
        new Map<String, dynamic>.from(response.data);
        var data = response.data['data'];
        print('ResponseInterceptors[onResponse]  data   $data');
        print('拦截相应 $code , $msg , $data');

        return ResultData(data, msg, code == P8Code.SUCCESS, code,
            headers: response.headers);
        if (code == P8Code.SUCCESS) {
          return new ResultData(data, msg, true, 200,
              headers: response.headers);
        } else if (code == P8Code.FAILED) {
          return new ResultData(data, msg, true, 200,
              headers: response.headers);
        } else if (code == P8Code.TOKEN_ERROR) {
          return new ResultData(data, msg, true, 200,
              headers: response.headers);
        }
      }
    } catch (e) {
      print(e.toString() + option.path);
      return ResultData(response.data, '', false, response.statusCode,
          headers: response.headers);
    }
    return ResultData(response.data, '', false, response.statusCode,
        headers: response.headers);
  }
}
