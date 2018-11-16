import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:kaiyan_client/gsd/widget/my_tabs.dart';
import 'package:kaiyan_client/page/home/comont_tab_page.dart';
import 'package:kaiyan_client/page/home/dissertation.dart';
import 'package:kaiyan_client/page/home/found.dart';
import 'package:kaiyan_client/page/home/recommended.dart';
import 'package:kaiyan_client/page/home/search.dart';
import 'package:kaiyan_client/util/constant.dart';
import 'package:kaiyan_client/widget/kaiyan_indictor.dart';
import 'package:kaiyan_client/widget/route_animation.dart';

class HomeViewController extends StatefulWidget {
  HomeViewController({Key key}) : super(key: key);

  @override
  _HomeViewControllerState createState() => _HomeViewControllerState();
}

//用于使用到了一点点的动画效果，因此加入了SingleTickerProviderStateMixin
class _HomeViewControllerState extends State<HomeViewController> with SingleTickerProviderStateMixin{

  List<Tab> tabs = [];
  List<int> ids = [];
  List items = [];

  TabController _tabController;
  TabController _tempController;


  @override
  void initState() {
    //动画效果的异步处理
    ////需要控制的Tab页数量
    _tempController = new TabController(length: 0, vsync: this);
    super.initState();
    Dio().get('http://www.wanandroid.com/tools/mockapi/8977/kanyan_tag').then((res){
      tabs = Constant.tabs_name.map((it){
        return Tab(
          text: it,
        );
      }).toList();

//      List re = res.data;
//
//      for (var i = 0; i > re.length -1 ; i++) {
//        if(i < 4){
//          tabs.add(Tab(
//            text: res.data[i]['name'],
//          ));
//          ids.add(res.data[i]['id']);
//          items.add(res.data[i]);
//        }
//      }

        res.data.forEach((it, ){
        tabs.add(Tab(
          text: it['name'],
        ));
        ids.add(it['id']);
        items.add(it);

      });

      _tabController = new TabController(length: tabs.length, vsync: this);
      setState(() {});

      //跳转到第一个元素
      _tabController.animateTo(1);
    });
  }


  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    _tempController.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {

    Widget _getBody() {
      return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            buildTopBar(),
            Expanded(
              child: TabBarView(
                children: buildTabPage(),
                controller: tabs.length > 5 ? _tabController : _tempController,
              ),
            )
          ],
        ),
      );
    }

    return new Container(
        child: new Scaffold(
          appBar: new AppBar(
            leading: buildLiftItem(),
            title: new Text('资讯',
                style: new TextStyle(color: Colors.white, fontFamily: 'Lobster')),
            iconTheme: new IconThemeData(color: Colors.white),
            actions: <Widget>[
              buildRightItem()
            ],
          ),
          body:  _getBody(),
        )
    );

  }

  //左边按钮
  GestureDetector buildLiftItem(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, AnimationPageRoute(
            sildeTween: Tween(begin: Offset(0.0, 0.0), end: Offset.zero),
            builder: (c){
              return DissertationController();
            }
        ));
      },
      child: Icon(Icons.menu, size: 23.0),
    );
  }

  //右边搜索按钮
  GestureDetector buildRightItem(){
    return GestureDetector(
      child: Icon(Icons.search),
      onTap: (){
        Navigator.push(context, AnimationPageRoute(
            sildeTween: Tween(begin: Offset(0.0, - 1.0), end: Offset.zero),
          builder: (c){
              return Search();
          }
        ));
      },
    );
  }

  Expanded buildMiddleItem(){
    return Expanded(
      child: TabBar(
        tabs: tabs.length > 5 ? tabs : [],
        isScrollable: true,
        labelColor: Colors.red[300],
        unselectedLabelColor: Colors.green[400],
        indicator: KaiyanIndictor(),
        controller: tabs.length > 5 ? _tabController : _tempController,
      ),
    );
  }

  //自定义顶部bar widget
  Widget buildTopBar(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 100.0,
      child: Row(
        children: <Widget>[
//          buildLiftItem(),
//          SizedBox(width: 10.0,),
          buildMiddleItem(),
//          SizedBox(width: 10.0,),
//          buildRightItem()
        ],
      ),


    );
  }
  
  //定义主页面
  List<Widget> buildTabPage(){
    List<Widget> list = [];
    list.insert(0, Found());
    list.insert(1, Recommended());

    items.forEach((it){
      list.add(ComontTabPage(
        title: it["name"].toString(),
        id: it["id"].toString(),
      ));
    });

    return list;
  }

}