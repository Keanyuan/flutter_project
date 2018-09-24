import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaiyan_client/gsd/common/config/Config.dart';
import 'package:kaiyan_client/gsd/common/dao/EventDao.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/model/Event.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/utils/EventUtils.dart';
import 'package:kaiyan_client/gsd/widget/EventItem.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';
import 'package:kaiyan_client/gsd/widget/GSYPullLoadWidgetControl.dart';
import 'package:redux/redux.dart';

/**
 * 主页动态tab页
 * Date: 2018-07-16
 */
class DynamicPage extends StatefulWidget {
  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends GSYListState<DynamicPage> with WidgetsBindingObserver {

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var result = await EventDao.getEventReceived(_getStore(), page: page, needDb: true);
    setState(() {
      pullLoadWidgetControl.needLoadMore = (result != null && result.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }


  @override
  Future<Null> onLoadMore() async{
    if(isLoading){
      return null;
    }

    isLoading = true;
    page++;
    var result = await EventDao.getEventReceived(_getStore(), page: page);
    setState(() {
      pullLoadWidgetControl.needLoadMore = (result != null);
    });
    isLoading = false;
    return null;
  }

  Store<GSYState> _getStore(){
    return StoreProvider.of(context);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  requestRefresh() {}

  @override
  requestLoadMore() {}

  @override
  bool get isRefreshFirst => false;

  @override
  void initState() {
    super.initState();
    //添加观察者
    WidgetsBinding.instance.addObserver(this);
    ReposDao.getNewsVersion(context, false);
  }

  @override
  void dispose() {
    //移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //改变依赖关系
  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = _getStore().state.eventList;
    //显示刷新样式
    if(pullLoadWidgetControl.dataList.length == 0){
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  //是否改变了应用的生命周期状态
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      if (pullLoadWidgetControl.dataList.length != 0) {
        showRefreshLoading();
      }
    }
  }

  _renderEventItem(Event e) {
    EventViewModel eventViewModel = EventViewModel.fromEventMap(e);
    return new EventItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, e, "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new StoreBuilder<GSYState>(
      builder: (context, store) {
        return GSYPullLoadWidget(
          pullLoadWidgetControl,
              (BuildContext context, int index) => _renderEventItem(pullLoadWidgetControl.dataList[index]),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
        );
      },
    );
  }
}


class ModelA {
  String name;
  String tag;

  ModelA(this.name, this.tag);

  ModelA.empty();

  ModelA.forName(this.name);

}