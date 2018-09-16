import 'package:flutter/material.dart';
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
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
        return [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text('subscription',
                style: TextStyle(color: Colors.white, fontFamily: 'Lobster')),
            centerTitle: true,
            backgroundColor: const Color(0xFF63CA6C),
            bottom: PreferredSize(
                child: Container(
                  height: 34.0,
                  child: new TabBar(
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey[100],
                    indicator: KaiyanIndictor(),
                    tabs: <Tab>[
                      new Tab(text: '作品'),
                      new Tab(text: '动态'),
                    ],
                    controller: _tabController,
                  ),
                ),
                preferredSize: Size(double.infinity, 34.0)),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          Works(),
          Dynamic(),
        ]),
    );
  }

}