import 'package:flutter/material.dart';
import 'package:p8_inspection_flutter/bean/entry_type.dart';

///
/// des:
///
class LoginInfo{
   String id;
   String name;
   String phone;
   String token;
   String loginName;
   String facadeImg;
   String password;
   UserType userType;
//         "phone": "18599632256",  //手机号
//         "loginName": "18599632256", //登录名
//         "name": "王总", //姓名
//         "id": "1", //id
//         "facadeImg": null,  //头像地址
//         "token": "7c25a85900344514b3bb317f3319d1ad"
   LoginInfo.fromJson(Map<String,dynamic> json) {
     id = json['id'];
     name = json['name'];
     phone = json['phone'];
     token = json['token'];
     loginName = json['loginName'];
     facadeImg = json['facadeImg'];
   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['token'] = this.token;
    data['loginName'] = this.loginName;
    data['facadeImg'] = this.facadeImg;
    String str = "";
    return data;
  }

  @override
  String toString() {
    return 'LoginInfo{id: $id, name: $name, phone: $phone, token: $token, loginName: $loginName, facadeImg: $facadeImg, password: $password, userType: $userType}';
  }

}