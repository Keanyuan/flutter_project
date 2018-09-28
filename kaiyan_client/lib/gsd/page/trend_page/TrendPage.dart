import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYCardItem.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';
import 'package:kaiyan_client/gsd/widget/GSYPullLoadWidgetControl.dart';
import 'package:kaiyan_client/gsd/widget/ReposItem.dart';
import 'package:redux/redux.dart';

/**
 * 主页趋势tab页
 * Date: 2018-07-16
 */
class TrendPage extends StatefulWidget {
  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends GSYListState<TrendPage> {
  static TrendTypeModel selectTime = null;

  static TrendTypeModel selectType = null;

  //渲染项目
  _renderItem(e) {
    ReposViewModel reposViewModel = ReposViewModel.fromTrendMap( e );
    return new ReposItem( reposViewModel, onPressed: () {
      NavigatorUtils.goReposDetail(
          context, reposViewModel.ownerName, reposViewModel.repositoryName );
    } );
  }

  //渲染头部
  _renderHeader(Store<GSYState> store) {
    if (selectType == null && selectType == null) {
      return Container( );
    }

    return new GSYCardItem(
      color: store.state.themeData.primaryColor,
      margin: EdgeInsets.all( 10.0 ),
      //形状
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.all( Radius.circular( 4.0 ) ),
      ),
      child: new Padding(
        padding: new EdgeInsets.only(
            left: 0.0, top: 5.0, right: 0.0, bottom: 5.0 ),
        child: new Row(
          children: <Widget>[
            _renderHeaderPopItem(
                selectTime.name, trendTime( context ), (TrendTypeModel result) {
              if (isLoading) {
                Fluttertoast.showToast( msg: CommonUtils
                    .getLocale( context )
                    .loading_text );
                return;
              }
              setState( () {
                selectTime = result;
              } );
              showRefreshLoading( );
            } ),
            new Container(
                height: 10.0, width: 0.5, color: Color( GSYColors.white ) ),
            _renderHeaderPopItem(
                selectType.name, trendType( context ), (TrendTypeModel result) {
              if (isLoading) {
                Fluttertoast.showToast( msg: CommonUtils
                    .getLocale( context )
                    .loading_text );
                return;
              }
              setState( () {
                selectType = result;
              } );
              showRefreshLoading( );
            } ),
          ],
        ),
      ),
    );
  }


  //渲染头部弹框按钮
  _renderHeaderPopItem(String data, List<TrendTypeModel> list, PopupMenuItemSelected<TrendTypeModel> onSelected) {
    return new Expanded(
      child: new PopupMenuButton<TrendTypeModel>(
        child: new Center(child: new Text(data, style: GSYConstant.middleTextWhite)),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return _renderHeaderPopItemChild(list);
        },
      ),
    );
  }

  //渲染弹框子item
  _renderHeaderPopItemChild(List<TrendTypeModel> data){
    List<PopupMenuEntry<TrendTypeModel>> list = new List();
    for (TrendTypeModel item in data) {
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }

  @override
  Future<Null> handleRefresh() async{
    if (isLoading) {
    return null;
    }
    isLoading = true;
    page = 1;
    await ReposDao.getTrendDao(_getStore(), since: selectTime.value, languageType: selectType.value);
    setState(() {
    pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;
    return null;
  }

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  bool get isRefreshFirst => false;

  @override
  void didChangeDependencies() {
    print("开始------------------");
    pullLoadWidgetControl.dataList = _getStore().state.trendList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      setState(() {
        selectTime = trendTime(context)[0];
        selectType = trendType(context)[0];
      });
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  Store<GSYState> _getStore() {
    return StoreProvider.of(context);
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return new StoreBuilder<GSYState>(
      builder: (context, store) {
        return new Scaffold(
          backgroundColor: Color(GSYColors.mainBackgroundColor),
          appBar: new AppBar(
            flexibleSpace: _renderHeader(store),
            backgroundColor: Color(GSYColors.mainBackgroundColor),
            leading: new Container(),
            elevation: 0.0,
          ),
          body: GSYPullLoadWidget(
            pullLoadWidgetControl,
                (BuildContext context, int index) => _renderItem(pullLoadWidgetControl.dataList[index]),
            handleRefresh,
            onLoadMore,
            refreshKey: refreshIndicatorKey,
          ),
        );
      },
    );
  }
}



class TrendTypeModel {
  final String name;
  final String value;

  TrendTypeModel(this.name, this.value);
}


//日期
trendTime(BuildContext context) {
  return [
    new TrendTypeModel(CommonUtils.getLocale(context).trend_day, "daily"),
    new TrendTypeModel(CommonUtils.getLocale(context).trend_week, "weekly"),
    new TrendTypeModel(CommonUtils.getLocale(context).trend_month, "monthly"),
  ];
}

//语言
trendType(BuildContext context) {
  return [
    TrendTypeModel(CommonUtils.getLocale(context).trend_all, null),
    TrendTypeModel("Java", "Java"),
    TrendTypeModel("Kotlin", "Kotlin"),
    TrendTypeModel("Dart", "Dart"),
    TrendTypeModel("Objective-C", "Objective-C"),
    TrendTypeModel("Swift", "Swift"),
    TrendTypeModel("JavaScript", "JavaScript"),
    TrendTypeModel("PHP", "PHP"),
    TrendTypeModel("Go", "Go"),
    TrendTypeModel("C++", "C++"),
    TrendTypeModel("C", "C"),
    TrendTypeModel("HTML", "HTML"),
    TrendTypeModel("CSS", "CSS"),
  ];
}