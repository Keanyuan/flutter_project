
import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/page/HomePage.dart';
import 'package:kaiyan_client/gsd/page/LoginPage.dart';

class NavigatorUtils {
  static goHome(BuildContext context){
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  static goLogin(BuildContext context){
    Navigator.pushReplacementNamed(context, LoginPage.sName, result: false);
  }
}