import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaiyan_client/gsd/common/event/HttpErrorEvent.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizationsDelegate.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/net/Code.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/page/HomePage.dart';
import 'package:kaiyan_client/gsd/page/LoginPage.dart';
import 'package:kaiyan_client/gsd/page/WelcomePage.dart';
import 'package:kaiyan_client/main_page.dart';
import 'package:kaiyan_client/page/home/home.dart';
import 'package:kaiyan_client/page/mine/mine.dart';
import 'package:kaiyan_client/page/subscription/subscription.dart';
import 'package:kaiyan_client/util/constant.dart';

import 'package:redux/redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new FlutterReduxApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '首页',
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      home: MainPage(),
    );
  }

}



class MainTabbarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTabbarState();
  }

}

class _MainTabbarState extends State<MainTabbarController> {

  int _tabIndex = 0;

  final tabTextStyleNormal = new TextStyle(color: Color(0xff969696));
  final tabTextStyleSelected  = new TextStyle(color: Color(0xff63ca6c));

  var tabImages;
  var _body;
  var appBarTitles = ['资讯', '订阅', '发现', '我的'];

  Image getTabImage(path){
    return new Image.asset(Constant.dir_image + path, width: 20.0, height: 20.0,);
  }

  void initData(){
    //tabbar图标
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('ic_nav_news_normal.png'),
          getTabImage('ic_nav_news_actived.png')
        ],
        [
          getTabImage('ic_nav_tweet_normal.png'),
          getTabImage('ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('ic_nav_discover_normal.png'),
          getTabImage('ic_nav_discover_actived.png')
        ],
        [
          getTabImage('ic_nav_my_normal.png'),
          getTabImage('ic_nav_my_pressed.png')
        ]
      ];
    }

    //主页面
    _body = new IndexedStack(
      children: <Widget>[
        HomeViewController(),
        SubscriptionController(),
        Text(appBarTitles[2]),
        MineController(),
      ],
      index: _tabIndex,
    );
  }


  //样式修改
  TextStyle getTabTextStyle(int curIndex) {
    if(curIndex == _tabIndex){
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  //修改图标
  Image getTabIcon(int curIndex){
    if(curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  //获取标题
  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: const Color(0xFF63CA6C)
      ),
      home: new Scaffold(
//        appBar: new AppBar(
//            title: new Text(appBarTitles[_tabIndex],
//                style: new TextStyle(color: Colors.white, fontFamily: 'Lobster')),
//            iconTheme: new IconThemeData(color: Colors.white)
//        ),
        body: _body,
        bottomNavigationBar: new CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0),
                title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1),
                title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2),
                title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3),
                title: getTabTitle(3)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            setState((){
              _tabIndex = index;
            });
          },
        ),
        //抽屉
//        drawer: new Drawer(),
      ),
    );
  }

}




class FlutterReduxApp extends StatelessWidget {
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<GSYState>(
    appReducer,
    ///初始化数据
    initialState: new GSYState(
        userInfo: User.empty(),
        eventList: new List(),
        trendList: new List(),
        themeData: new ThemeData(
            primarySwatch: GSYColors.primarySwatch,
            platform: TargetPlatform.iOS//滑动返回
        ),
        locale: Locale('zh', 'CH')),
  );

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<GSYState>(builder: (context, store) {
        return new MaterialApp(
          ///多语言实现代理
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GSYLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            theme: store.state.themeData,
            routes: {
              WelcomePage.sName: (context) {
                store.state.platformLocale = Localizations.localeOf(context);
                return WelcomePage();
              },
              HomePage.sName: (context) {
                ///通过 Localizations.override 包裹一层，
                return new GSYLocalizations(
                  child: new HomePage(),
                );
              },
              LoginPage.sName: (context) {
                return new GSYLocalizations(
                  child: new LoginPage(),
                );
              },
            });
      }),
    );
  }
}

class GSYLocalizations extends StatefulWidget {
  final Widget child;

  GSYLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<GSYLocalizations> createState() {
    return new _GSYLocalizations();
  }
}

class _GSYLocalizations extends State<GSYLocalizations> {


  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    stream =  Code.eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT:
      //超时
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).network_error_unknown + " " + message);
        break;
    }
  }
}
