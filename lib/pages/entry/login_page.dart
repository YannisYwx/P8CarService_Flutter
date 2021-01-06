import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:p8_inspection_flutter/bean/entry_type.dart';
import 'package:p8_inspection_flutter/constant/color_constant.dart';
import 'package:p8_inspection_flutter/constant/constants.dart';
import 'package:p8_inspection_flutter/http/api.dart';
import 'package:p8_inspection_flutter/http/http_utils.dart';
import 'package:p8_inspection_flutter/router.dart';
import 'package:p8_inspection_flutter/utils/data_utils.dart';
import 'package:p8_inspection_flutter/utils/screen_adapter.dart';
import 'package:p8_inspection_flutter/utils/toast_util.dart';
import 'package:p8_inspection_flutter/widget/x_edit_text.dart';

class LoginPage extends StatefulWidget {
  final EntryType _entryType;

  LoginPage(this._entryType, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState(this._entryType);
  }
}

class _LoginState extends State<LoginPage> with TickerProviderStateMixin {
  EntryType _entryType;
  var animationStatus = 0;
  OutlineInputBorder enabledBorder, focusedBorder;

  String _account = '15919835035', _password = '456789';
  String _errorMsg = '';

  _LoginState(this._entryType) {
    enabledBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 0.5, color: Colors.grey));
    focusedBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.0, color: Colors.blue));
    _account = _entryType.type == UserType.AGENCY ? '15919835035' : "wzh";
    _password = _entryType.type == UserType.AGENCY ? '456789' : "123456";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool normalStyle = false;
    return Container(
      color: ColorConstants.backgroundColor,
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            color: Colors.white,
            height: Adapt.px(350),
            child: Padding(
                padding: EdgeInsets.only(
                    left: Adapt.px(103),
                    top: Adapt.px(128),
                    right: Adapt.px(103)),
                child: Column(children: [
                  Row(children: [
                    Image.asset(Constants.ASSETS_IMG + "logo.png",
                        width: Adapt.px(74 * 0.6),
                        height: Adapt.px(112 * 0.6)),
                    SizedBox(width: 5),
                    Text('欢迎使用P8车服',
                        style: TextStyle(
                            fontSize: Adapt.px(36),
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.textBlack))
                  ]),
                  SizedBox(height: Adapt.px(12)),
                  Text(
                    '专注运营互联网物联网智能停车管理平台',
                    style: TextStyle(
                        fontSize: Adapt.px(17),
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textLightGray),
                    maxLines: 1,
                  )
                ]))),
        Padding(
          padding: EdgeInsets.only(
              left: Adapt.px(34), right: Adapt.px(34), top: Adapt.px(20)),
          child: normalStyle
              ? TextField(
              decoration: InputDecoration(
                  icon: Text('账号：',
                      style: TextStyle(
                          color: ColorConstants.textLightBlack,
                          fontSize: Adapt.px(24),
                          fontWeight: FontWeight.w500)),
                  labelText: '账号',
                  hintText: '请输入您的账号（手机号码）'))
              : XTextField(
              text: _account,
              hintText: "请输入您的账号（手机号码）",
              labelText: '账号',
              leftWidget: Icon(Icons.person),
              isShowDeleteBtn: true,
              isDense: true,
              isPwd: false,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              inputCallBack: (val) => _account = val),
        ),
        Padding(
            padding: EdgeInsets.only(
                left: Adapt.px(34),
                right: Adapt.px(34),
                top: Adapt.px(20)),
            child: normalStyle
                ? TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Text('密码：',
                        style: TextStyle(
                            color: ColorConstants.textLightBlack,
                            fontSize: Adapt.px(24),
                            fontWeight: FontWeight.w500)),
                    hintText: '请输入您的密码',
                    labelText: '请输入六位有效数字或字母'))
                : XTextField(
                text: _password,
                hintText: "请输入六位有效数字或字母",
                labelText: '密码',
                leftWidget: Icon(Icons.lock),
                isShowDeleteBtn: true,
                isDense: true,
                isPwd: true,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                inputCallBack: (val) => _password = val)),
        Padding(
          padding: EdgeInsets.only(
              left: Adapt.px(34),
              right: Adapt.px(34),
              top: Adapt.px(15),
              bottom: Adapt.px(40)),
          child: Text(_errorMsg,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[400])),
        ),
        Center(
          child: Container(
              width: Adapt.px(490),
              height: Adapt.px(64),
              child: RaisedButton(
                  onPressed: () => _doLogin(),
                  textColor: Colors.white,
                  hoverColor: Colors.blue,
                  color: Colors.blue,
                  splashColor: Colors.white12,
                  child: Text('登录',
                      style: TextStyle(fontSize: Adapt.px(25))),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                          color: Colors.blueAccent, width: 1)))),
        ),
      ]),
    );
  }

  void _doLogin() {
    print('login [ $_account, $_password]');
    if (_account == null || _account.isEmpty) {
      ToastUtil.showAlertToast("账号不能为空");
      return;
    }
    if (_password == null || _password.isEmpty) {
      ToastUtil.showAlertToast("密码不能为空");
      return;
    }
    HttpUtils.login(
        loginName: _account,
        password: _password,
        loginPath: getLoginAPI(_entryType),
        success: (loginInfo, msg) async {
          if (loginInfo == null) {
            ToastUtil.showAlertToast(msg);
          }
          if (_errorMsg.isNotEmpty) {
            setState(() {
              _errorMsg = '';
            });
          }
          loginInfo.userType = _entryType.type;
          DataUtils.saveLoginInfo(loginInfo);
          await EasyLoading.showSuccess('登录成功!' ,maskType: EasyLoadingMaskType.black);
          Routers.push(context, Routers.homePage, loginInfo);
        },
        fail: (code, msg) {
          setState(() {
            _errorMsg = msg;
            ToastUtil.showAlertToast(_errorMsg);
          });
        });
  }


}
