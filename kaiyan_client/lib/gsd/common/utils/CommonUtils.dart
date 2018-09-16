

import 'package:flutter/cupertino.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/redux/LocaleReducer.dart';
import 'package:kaiyan_client/gsd/common/style/GSYStringBase.dart';
import 'package:redux/redux.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';

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
}