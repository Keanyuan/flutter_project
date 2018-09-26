
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/page/HomePage.dart';
import 'package:kaiyan_client/gsd/page/LoginPage.dart';
import 'package:kaiyan_client/gsd/page/SearchPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/PersonPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/PhotoViewPage.dart';
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

  ///搜索
  static Future<Null> goSearchPage(BuildContext context) {
    return Navigator.push(context, new MaterialPageRoute(builder: (context) => new SearchPage()));
  }

  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new PhotoViewPage(url)));
  }

  ///个人中心
  static goPerson(BuildContext context, String userName){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new PersonPage(userName)));
  }
}