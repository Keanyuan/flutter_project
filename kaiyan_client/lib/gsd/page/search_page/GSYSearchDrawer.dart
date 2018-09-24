import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';

/**
 * 搜索drawer
 */
typedef void SearchSelectItemChanged<String>(String value);

class GSYSearchDrawer extends StatefulWidget {
  final SearchSelectItemChanged<String> typeCallback;
  final SearchSelectItemChanged<String> sortCallback;
  final SearchSelectItemChanged<String> languageCallback;
  GSYSearchDrawer(this.typeCallback, this.sortCallback, this.languageCallback);
  @override
  State<StatefulWidget> createState() {
    return _GSYSearchDrawerState();
  }

}

class _GSYSearchDrawerState extends State<GSYSearchDrawer> {
  _GSYSearchDrawerState();
  final double itemWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: CommonUtils.sStaticBarHeight),
      child: Container(
        color: Color(GSYColors.white),
        child: new SingleChildScrollView(
          child: new Column(
            children: _renderList(),
          ),
        ),
      ),
    );
  }
  _renderList() {
    List<Widget> list = new List();
    //添加一个空的宽度部件
    list.add(new Container(
      width: itemWidth,
    ));
    //搜索筛选类型标题
    list.add(_renderTitle(CommonUtils.getLocale(context).search_type));
    //搜索筛选类型
    for (int i = 0; i < searchFilterType.length; i++) {
      FilterModel model = searchFilterType[i];
      list.add(_renderItem(model, searchFilterType, i, widget.typeCallback));
      list.add(_renderDivider());
    }
    //类型标题
    list.add(_renderTitle(CommonUtils.getLocale(context).search_type));
    for (int i = 0; i < sortType.length; i++) {
      FilterModel model = sortType[i];
      list.add(_renderItem(model, sortType, i, widget.sortCallback));
      list.add(_renderDivider());
    }
    //语言类型标题
    list.add(_renderTitle(CommonUtils.getLocale(context).search_language));
    for (int i = 0; i < searchLanguageType.length; i++) {
      FilterModel model = searchLanguageType[i];
      list.add(_renderItem(model, searchLanguageType, i, widget.languageCallback));
      list.add(_renderDivider());
    }
    return list;

  }

  //底部线框
  _renderDivider() {
    return Container(
      color: Color(GSYColors.subTextColor),
      width: itemWidth,
      height: 0.3,
    );
  }
  _renderTitle(String title){
    return new Container(
      color: Theme.of(context).primaryColor,
      width: itemWidth + 50,
      height: 50.0,
      child: new Center(
        child: new Text(
          title,
          style: GSYConstant.middleTextWhite,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  _renderItem(FilterModel model, List<FilterModel> list, int index, SearchSelectItemChanged<String> select) {
    return new Stack(
      //底部选择框和标题 上部 按钮
      children: <Widget>[
        new Container(
          height: 50.0,
          child: new Container(
            width: itemWidth,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Checkbox 选中框
                new Center(child: new Checkbox(value: model.select, onChanged: (value) {})),
                new Center(child: Text(model.name)),
              ],
            ),
          ),
        ),
        new FlatButton(
          onPressed: () {
            setState(() {
              //改变状态
              for (FilterModel model in list) {
                model.select = false;
              }
              list[index].select = true;
            });
            //跳转搜索
            select?.call(model.value);
          },
          child: new Container(
            width: itemWidth,
          ),
        )
      ],
    );
  }
}


class FilterModel {
  String name;
  String value;
  bool select;

  FilterModel({this.name, this.value, this.select});
}

//类型
var sortType = [
  FilterModel(name: 'desc', value: 'desc', select: true),
  FilterModel(name: 'asc', value: 'asc', select: false),
];
//搜索筛选类型
var searchFilterType = [
  FilterModel(name: "best_match", value: 'best%20match', select: true),
  FilterModel(name: "stars", value: 'stars', select: false),
  FilterModel(name: "forks", value: 'forks', select: false),
  FilterModel(name: "updated", value: 'updated', select: false),
];
//语言
var searchLanguageType = [
  FilterModel(name: "trendAll", value: null, select: true),
  FilterModel(name: "Java", value: 'Java', select: false),
  FilterModel(name: "Dart", value: 'Dart', select: false),
  FilterModel(name: "Objective_C", value: 'Objective-C', select: false),
  FilterModel(name: "Swift", value: 'Swift', select: false),
  FilterModel(name: "JavaScript", value: 'JavaScript', select: false),
  FilterModel(name: "PHP", value: 'PHP', select: false),
  FilterModel(name: "C__", value: 'C++', select: false),
  FilterModel(name: "C", value: 'C', select: false),
  FilterModel(name: "HTML", value: 'HTML', select: false),
  FilterModel(name: "CSS", value: 'CSS', select: false),
];


