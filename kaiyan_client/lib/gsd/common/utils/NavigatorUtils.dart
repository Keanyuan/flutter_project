
import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/page/HomePage.dart';
import 'package:kaiyan_client/gsd/page/LoginPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/UserProfileInfo.dart';
import 'package:kaiyan_client/gsd/page/tool_page/CommonListPage.dart';

class NavigatorUtils {
  //首页
  static goHome(BuildContext context){
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  //登录
  static goLogin(BuildContext context){
    Navigator.pushReplacementNamed(context, LoginPage.sName, result: false);
  }

  //个人信息
  static gotoUserProfileInfo(BuildContext context){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new UserProfileInfo()));
  }

  ///阅读历史列表
  static gotoCommonList(BuildContext context, String title, String showType, String dataType, {String userName, String reposName}) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new CommonListPage(
              title,
              showType,
              dataType,
              userName: userName,
              reposName: reposName,
            )));
  }

}