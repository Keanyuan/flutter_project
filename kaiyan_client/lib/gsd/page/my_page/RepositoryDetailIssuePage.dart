import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiyan_client/gsd/common/dao/IssueDao.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/search_page/GSYSearchInputWidget.dart';
import 'package:kaiyan_client/gsd/page/search_page/SelectItemChanged.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';
import 'package:kaiyan_client/gsd/widget/GSYPullLoadWidgetControl.dart';
import 'package:kaiyan_client/gsd/widget/IssueItem.dart';

/**
 * 仓库详情issue列表
 */
class RepositoryDetailIssuePage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepositoryDetailIssuePage(this.userName, this.reposName);

  @override
  _RepositoryDetailIssuePageState createState() => _RepositoryDetailIssuePageState(userName, reposName);
}

class _RepositoryDetailIssuePageState extends GSYListState<RepositoryDetailIssuePage> {

  final String userName;

  final String reposName;

  String searchText;
  String issueState;
  int selectIndex;

  _RepositoryDetailIssuePageState(this.userName, this.reposName);


  //更新状态
  _resolveSelectIndex() {
    clearData();
    switch (selectIndex) {
      case 0:
        issueState = null;
        break;
      case 1:
        issueState = 'open';
        break;
      case 2:
        issueState = "closed";
        break;
    }
    showRefreshLoading();
  }

  //获取数据
  _getDataLogic(String searchString) async {
    if (searchString == null || searchString.trim().length == 0) {
      //正常加载数据
      return await IssueDao.getRepositoryIssueDao(userName, reposName, issueState, page: page, needDb: page <= 1);
    }
    //搜索数据
    return await IssueDao.searchRepositoryIssue(searchString, userName, reposName, this.issueState, page: this.page);
  }

  //创建列表item
  _renderEventItem(index) {
    IssueItemViewModel issueItemViewModel = IssueItemViewModel.fromMap(pullLoadWidgetControl.dataList[index]);
    return new IssueItem(
      issueItemViewModel,
      onPressed: () {
        //todo
        NavigatorUtils.goIssueDetail(context, userName, reposName, issueItemViewModel.number);
      },
    );
  }

  //新建问题
  _createIssue() {
    String title = "";
    String content = "";
    CommonUtils.showEditDialog(context, CommonUtils.getLocale(context).issue_edit_issue, (titleValue) {
      title = titleValue;
    }, (contentValue) {
      content = contentValue;
    }, () {
      if (title == null || title.trim().length == 0) {
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).issue_edit_issue_title_not_be_null);
        return;
      }
      if (content == null || content.trim().length == 0) {
        Fluttertoast.showToast(msg: CommonUtils.getLocale(context).issue_edit_issue_content_not_be_null);
        return;
      }
      CommonUtils.showLoadingDialog(context);
      //提交修改
      IssueDao.createIssueDao(userName, reposName, {"title": title, "body": content}).then((result) {
        showRefreshLoading();
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }, needTitle: true, titleController: new TextEditingController(), valueController: new TextEditingController()
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: new AppBar(
        leading: new Container(),
        //头部输入框
        flexibleSpace: GSYSearchInputWidget(
                (value){
                  this.searchText = value;
                },
                (value){
                  _resolveSelectIndex();
                },
                (){
                  _resolveSelectIndex();
                }),
        elevation: 0.0,
        backgroundColor: Color(GSYColors.mainBackgroundColor),
        //头部 选项卡
        bottom: new GSYSelectItemWidget([
          CommonUtils.getLocale(context).repos_tab_issue_all,
          CommonUtils.getLocale(context).repos_tab_issue_open,
          CommonUtils.getLocale(context).repos_tab_issue_closed,
        ], (selectIndex){
          this.selectIndex = selectIndex;
          _resolveSelectIndex();
        }),
      ),
      backgroundColor: Color(GSYColors.mainBackgroundColor),
      body: GSYPullLoadWidget(
        pullLoadWidgetControl,
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
      //新建问题
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          GSYICons.ISSUE_ITEM_ADD,
          size: 55.0,
          color: Color(GSYColors.textWhite),
        ),
        onPressed: (){
          _createIssue();
        },
      ),
    );
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  requestLoadMore()async {
    return await _getDataLogic(this.searchText);
  }

  @override
  requestRefresh() async{
    return await _getDataLogic(this.searchText);
  }


}