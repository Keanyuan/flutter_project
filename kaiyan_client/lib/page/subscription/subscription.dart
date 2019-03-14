import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/widget/my_tabs.dart';
import 'package:kaiyan_client/page/subscription/Dynamic.dart';
import 'package:kaiyan_client/page/subscription/works.dart';
import 'package:kaiyan_client/widget/kaiyan_indictor.dart';


class SubscriptionController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubscriptionController();
  }

}

class _SubscriptionController extends State<SubscriptionController> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[Works(), Dynamic()],
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text('subscription',
                style: TextStyle(color: Colors.black, fontFamily: 'Lobster')),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 34.0),
              child: Container(
                height: 34.0,
                child: new TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicator: KaiyanIndictor(),
                  tabs: <Tab>[
                    new Tab(
                      text: "作品",
                    ),
                    new Tab(
                      text: "动态",
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
          )
        ];
      },
    );
  }


//  @override
//  Widget build(BuildContext context) {
//    return NestedScrollView(
//      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
//        return [
//          SliverAppBar(
//            floating: true,
//            pinned: true,
//            title: Text('subscription',
//                style: TextStyle(color: Colors.white, fontFamily: 'Lobster')),
//            centerTitle: true,
//            backgroundColor: const Color(0xffff26c9),
//            bottom: PreferredSize(
//                child: Container(
//                  height: 150.0,
//                  child: new MyTabBar(
//                    labelColor: Colors.red,
//                    unselectedLabelColor: Colors.grey[100],
//                    indicator: KaiyanIndictor(w: 150.0, color: Colors.red),
//                    tabs: <MyTab>[
//                      new MyTab(
//                        child: Container(
//                          child: Center(child: Text("作品", style: TextStyle(fontSize: 40.0),)),
//                          decoration: new BoxDecoration(image: new DecorationImage(image: new ExactAssetImage(GSYICons.HOME_TOP_BG), fit: BoxFit.cover)),
//                        )),
//                      new MyTab(
//                          child: Container(
//                            child: Center(child: Text("动态", style: TextStyle(fontSize: 40.0))),
//                            decoration: new BoxDecoration(image: new DecorationImage(image: new ExactAssetImage(GSYICons.HOME_TOP_BG), fit: BoxFit.cover)),
//                          )),
//                    ],
//                    controller: _tabController,
//                  ),
//                ),
//                preferredSize: Size(double.infinity,175.0)
//            ),
//          )
//        ];
//      },
//      body: TabBarView(
//        controller: _tabController,
//        children: [
//          Works(),
//          Dynamic(),
//        ]),
//    );
//  }

}