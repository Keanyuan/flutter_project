import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'dart:async';

import 'package:kaiyan_client/gsd/page/drawer/HomeDrawer.dart';
import 'package:kaiyan_client/gsd/page/dynamic_page/DynamicPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/MyPage.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTabBarWidget.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTitleBar.dart';
import 'package:kaiyan_client/gsd/page/trend_page/TrendPage.dart';

/**
 * 主页
 */
class HomePage extends StatelessWidget {
  static final String sName = "home";

  //渲染tab
  _renderTab(icon, text){
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(icon, size: 16.0,),
          new Text(text),
//          new SizedBox(height: 30.0,)
        ],
      ),
    );
  }

  /// 单击提示退出
  Future<bool> _dialogExitApp(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text(CommonUtils.getLocale(context).app_back_tip),
        actions: <Widget>[
          new FlatButton(
              onPressed: (){
                Navigator.of(context).pop(false);
              },
              child: new Text(CommonUtils.getLocale(context).app_cancel),
          ),
          new FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
//                Navigator.of(context).pop(false);
              },
              child: new Text(CommonUtils.getLocale(context).app_ok))
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    
    //tab list
    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
      _renderTab(GSYICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
      _renderTab(GSYICons.MAIN_MY, CommonUtils.getLocale(context).home_my)
    ];


    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: new GSYTabBarWidget(
        drawer: new HomeDrawer(),
        type: GSYTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: [
          new DynamicPage(),
          new TrendPage(),
          new MyPage(),
        ],
        backgroundColor: GSYColors.primarySwatch,
        indicatorColor: Color(GSYColors.white),
        title: GSYTitleBar(
          GSYLocalizations.of(context).currentLocalized.app_name,
          iconData: GSYICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onPressed: () {
            NavigatorUtils.goSearchPage(context);
          },
        ),
      ),
    );




    return new Scaffold(
        appBar: new AppBar(
          title: new Text('我的主页'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Text('主页'),
        )
    );
    //监听左上角返回和实体返回
    return WillPopScope(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('我的主页'),
              centerTitle: true,
            ),
            body: new Center(
              child: new Text('主页'),
            )
        ),
        onWillPop: (){
          return _dialogExitApp(context);
        });
    

  }
}