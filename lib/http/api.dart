import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/bean/entry_type.dart';

///
/// des:
///
class API {
  static const String HOST = "http://service.p8.world";



}

//接口类型
enum APIType {
  ///大主登录
  AgencyLogin,

  /// 巡检登录
  InspectLogin,

}
const APITypeValues = {
  APIType.AgencyLogin: "/app_agency/login.html",
  APIType.InspectLogin: "/app_inspect/login.html",
};

class P8Code {
  static const int SUCCESS = 1;
  static const int FAILED = 0;
  static const int TOKEN_ERROR = 408;
}

APIType getLoginAPI(EntryType entryType){
  switch(entryType.type) {

    case UserType.AGENCY:
      return APIType.AgencyLogin;
    case UserType.INSPECTION:
      return APIType.InspectLogin;
      break;
    case UserType.LANDLORD:
      // TODO: Handle this case.
      break;
    case UserType.LITTLE_AGENCY:
      // TODO: Handle this case.
      break;
    case UserType.MASTER:
      // TODO: Handle this case.
      break;
    case UserType.MIDDLE_AGENCY:
      // TODO: Handle this case.
      break;
    case UserType.OWN:
      // TODO: Handle this case.
      break;
    case UserType.BUILDER:
      // TODO: Handle this case.
      break;
    case UserType.OTHER:
      // TODO: Handle this case.
      break;
  }
  return APIType.AgencyLogin;
}