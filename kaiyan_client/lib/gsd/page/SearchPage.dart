import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/config/Config.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/page/search_page/GSYSearchDrawer.dart';
import 'package:kaiyan_client/gsd/page/search_page/GSYSearchInputWidget.dart';
import 'package:kaiyan_client/gsd/page/search_page/SelectItemChanged.dart';
import 'package:kaiyan_client/gsd/page/search_page/UserItem.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';
import 'package:kaiyan_client/gsd/widget/GSYPullLoadWidgetControl.dart';
import 'package:kaiyan_client/gsd/widget/ReposItem.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }

}

class _SearchPageState extends GSYListState<SearchPage> {

  int selectIndex = 0;
  //搜索名称
  String searchText;
  String type = searchFilterType[0].value;
  String sort = sortType[0].value;
  String language = searchLanguageType[0].value;

  //呈现项目
  _renderEventItem(index){
    //获取单列数据
    var data = pullLoadWidgetControl.dataList[index];
    if(selectIndex == 0){
      ReposViewModel reposViewModel =  ReposViewModel.fromMap(data);
      return new ReposItem(reposViewModel, onPressed: () {
        //todo 点击头像
//        NavigatorUtils.goReposDetail(context, reposViewModel.ownerName, reposViewModel.repositoryName);
      });
    } else if (selectIndex == 1) {
      return new UserItem(UserItemViewModel.fromMap(data), onPressed: () {
//        NavigatorUtils.goPerson(context, UserItemViewModel.fromMap(data).userName);
      });
    }

  }

  //解析选择索引
  _resolveSelectIndex() {
    //先清除数据
    clearData();
    //显示刷新
    showRefreshLoading();
  }

  //获取数据
  _getDataLogic() async {
    return await ReposDao.searchRepositoryDao(searchText, language, type, sort, selectIndex == 0 ? null : 'user', page, Config.PAGE_SIZE);
  }

  //清除选中状态
  _clearSelect(List<FilterModel> list) {
    for (FilterModel model in list) {
      model.select = false;
    }
  }

    @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => false;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }


  @override
  void dispose() {
    super.dispose();
    //初始化状态
    _clearSelect(sortType);
    sortType[0].select = true;
    _clearSelect(searchLanguageType);
    searchLanguageType[0].select = true;
    _clearSelect(searchFilterType);
    searchFilterType[0].select = true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return new Scaffold(
      endDrawer: new GSYSearchDrawer(
              (String type){
                this.type = type;
                Navigator.pop(context);
                _resolveSelectIndex();
              },
              (String sort){
                this.sort = sort;
                Navigator.pop(context);
                _resolveSelectIndex();
              },
              (String language){
                this.language = language;
                Navigator.pop(context);
                _resolveSelectIndex();
              }),
      backgroundColor: Color(GSYColors.mainBackgroundColor),
      appBar: new AppBar(
        title: new Text(CommonUtils.getLocale(context).search_title),
        bottom: new SearchBottom(
                (value){
                  searchText = value;
                },
                (value){
                  searchText = value;
                  if (searchText == null || searchText.trim().length == 0) {
                    return;
                  }
                  _resolveSelectIndex();
                },
                (){
                  if (searchText == null || searchText.trim().length == 0) {
                    return;
                  }
                  _resolveSelectIndex();
                },
                (selectIndex){
                  this.selectIndex = selectIndex;
                  _resolveSelectIndex();
                }),
      ),
      body: GSYPullLoadWidget(
        pullLoadWidgetControl,
            (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }

}


class SearchBottom extends StatelessWidget implements PreferredSizeWidget {
  final SelectItemChanged onChanged;

  final SelectItemChanged onSubmitted;

  final SelectItemChanged selectItemChanged;

  final VoidCallback onSubmitPressed;

  SearchBottom(this.onChanged, this.onSubmitted, this.onSubmitPressed, this.selectItemChanged);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GSYSearchInputWidget(onChanged, onSubmitted, onSubmitPressed),
        new GSYSelectItemWidget(
          [
            CommonUtils.getLocale(context).search_tab_repos,
            CommonUtils.getLocale(context).search_tab_user,
          ],
          selectItemChanged,
          elevation: 0.0,
          margin: const EdgeInsets.all(5.0),
        )
      ],
    );
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(100.0);
  }
}
