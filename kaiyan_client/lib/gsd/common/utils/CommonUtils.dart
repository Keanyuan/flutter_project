import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/redux/LocaleReducer.dart';
import 'package:kaiyan_client/gsd/common/redux/ThemeRedux.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/style/GSYStringBase.dart';
import 'package:redux/redux.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/**
 * 通用逻辑
 */
class CommonUtils {

  static double sStaticBarHeight = 0.0;


  static void initStatusBarHeight(context) async {
    sStaticBarHeight = await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  /**
   * 获得语言环境
   */
  static GSYStringBase getLocale(BuildContext context) {
    return GSYLocalizations.of(context).currentLocalized;
  }

  /**
   * 切换本地语言
   */
  static changeLocale(Store<GSYState> store, int index){
    Locale locale = store.state.platformLocale;

    switch(index){
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
  }

  /*改变主题*/
  static pushTheme(Store store, int index){
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = new ThemeData(primarySwatch: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }
  static List<Color> getThemeListColor() {
    return [
      GSYColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }


  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(child: SpinKitCubeGrid(color: Color(GSYColors.white))),
                        new Container(height: 10.0),
                        new Container(child: new Text(CommonUtils.getLocale(context).loading_text, style: GSYConstant.normalTextWhite)),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

}