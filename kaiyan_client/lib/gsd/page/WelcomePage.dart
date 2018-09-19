import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/SqlManager.dart';
import 'package:kaiyan_client/gsd/common/dao/EventDao.dart';
import 'package:kaiyan_client/gsd/common/dao/UserDao.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/util/constant.dart';
import 'package:redux/redux.dart';


class WelcomePage extends StatefulWidget {
  static final String sName = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {

  bool hadInit = false;

  ///概念依赖关系
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(hadInit){
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<GSYState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    UserDao.clearAll(store);
    EventDao.clearEvent(store);
    SqlManager.close();
    new Future.delayed(const Duration(seconds: 2), (){
      UserDao.initUserInfo(store).then((res){
        if(res != null && res.result){
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });


  }

  @override
  Widget build(BuildContext context) {

    return StoreBuilder<GSYState>(builder: (context, store){
      return new Container(
        color: Color(GSYColors.white),
        child: new Center(
          child: new Image(image: new AssetImage(Constant.dir_image + 'gsy_welcome.png')),
        ),
      );
    });

  }

}

