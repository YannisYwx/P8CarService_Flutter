
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:p8_inspection_flutter/http/api.dart';
import 'package:p8_inspection_flutter/http/response_interceptor.dart';
import 'package:p8_inspection_flutter/http/result_data.dart';

import 'code.dart';
import 'dio_log_interceptor.dart';

///
/// des:
///

class HttpManager {
  static HttpManager _instance = HttpManager._internal();
  Dio _dio;

  factory HttpManager() => _instance;

  HttpManager._internal({String baseUrl}) {
    if (_dio == null) {
      _dio = new Dio(new BaseOptions(baseUrl: baseUrl, connectTimeout: 15000));
      _dio.interceptors.add(new DioLogInterceptor());
      _dio.interceptors.add(new ResponseInterceptors());
    }
  }

  /// 用于指定特定域名
  HttpManager _baseUrl({String baseUrl}) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  static HttpManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl: baseUrl);
    }
  }

  /// 一般请求，默认域名
  HttpManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != API.HOST) {
        _dio.options.baseUrl = API.HOST;
      }
    }
    return this;
  }

  ///通用的GET请求
  get(api, {params, withLoading = true}) async {
    if (withLoading) {
      ///show
      await EasyLoading.show();
    }
    Response response;
    try {
      response = await _dio.get(api, queryParameters: params);
      if (withLoading) {
        ///dismiss
        await   EasyLoading.dismiss(animation: true);
      }
    } on DioError catch (e) {
      if (withLoading) {
        ///dismiss
        await  EasyLoading.dismiss(animation: true);
      }
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data['code']);
    }
    return response.data;
  }

  ///通用的POST请求
  post(api, {params, withLoading = true}) async {
    if (withLoading) {
      ///show
      await EasyLoading.show();
    }
    Response response;
    try {
      print('$params');
      response = await _dio.post(api, queryParameters: params);
      if (withLoading) {
        ///dismiss
        await  EasyLoading.dismiss(animation: true);
      }
    } on DioError catch (e) {
      print('DioError  ${e.toString()}');
      if (withLoading) {
        ///dismiss
        await  EasyLoading.dismiss(animation: true);
      }
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data['code']);
    }
    return response.data;
  }
}

ResultData resultError(DioError e) {
  Response errorResponse;
  if (e.response != null) {
    errorResponse = e.response;
  } else {
    errorResponse = new Response(statusCode: 666);
  }
  if (e.type == DioErrorType.CONNECT_TIMEOUT ||
      e.type == DioErrorType.RECEIVE_TIMEOUT) {
    errorResponse.statusCode = Code.NETWORK_TIMEOUT;
  }
  return new ResultData(
      errorResponse.statusMessage, '', false, errorResponse.statusCode);
}
