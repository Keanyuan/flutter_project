import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/my_page/ReposDetailInfoPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailFileListPage.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailIssuePage.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailReadmePage.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTabBarWidget.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTitleBar.dart';
import 'package:kaiyan_client/gsd/widget/GSYCommonOptionWidget.dart';
import 'package:kaiyan_client/gsd/widget/GSYIConText.dart';
import 'package:kaiyan_client/gsd/widget/ReposHeaderItem.dart';

/**
 *  仓库详情
 */
class RepositoryDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryDetailPageState(userName, reposName);
  }
}

class _RepositoryDetailPageState extends State<RepositoryDetailPage>{
  final String userName;

  final String reposName;

  _RepositoryDetailPageState(this.userName, this.reposName);

  //头部信息
  ReposHeaderViewModel reposHeaderViewModel = new ReposHeaderViewModel();

  //底部信息
  BottomStatusModel bottomStatusModel;

  final TarWidgetControl tarBarControl = new TarWidgetControl();

  final ReposDetailParentControl reposDetailParentControl = new ReposDetailParentControl("master");

  final PageController topPageControl = new PageController();

  //更多信息
  final OptionControl titleOptionControl = new OptionControl();

  //仓库文件列表
  GlobalKey<RepositoryDetailFileListPageState> fileListKey = new GlobalKey<RepositoryDetailFileListPageState>();

  //仓库动态详情
  GlobalKey<ReposDetailInfoPageState> infoListKey = new GlobalKey<ReposDetailInfoPageState>();

  //Readme详情
  GlobalKey<RepositoryDetailReadmePageState> readmeKey = new GlobalKey<RepositoryDetailReadmePageState>();

  //分支列表
  List<String> branchList = new List();



  //获取分支列表
  _getBranchList() async {
    var result = await ReposDao.getBranchesDao(userName, reposName);
    if (result != null && result.result) {
      setState(() {
        branchList = result.data;
      });
    }
  }

  //获取仓库状态
  _getReposStatus() async {
    var result = await ReposDao.getRepositoryStatusDao(userName, reposName);
    String watchText = result.data["watch"] ? "UnWatch" : "Watch";
    String starText = result.data["star"] ? "UnStar" : "Star";
    IconData watchIcon = result.data["watch"] ? GSYICons.REPOS_ITEM_WATCHED : GSYICons.REPOS_ITEM_WATCH;
    IconData starIcon = result.data["star"] ? GSYICons.REPOS_ITEM_STARED : GSYICons.REPOS_ITEM_STAR;
    BottomStatusModel model = new BottomStatusModel(watchText, starText, watchIcon, starIcon, result.data["watch"], result.data["star"]);
    setState(() {
      bottomStatusModel = model;
      tarBarControl.footerButton = _getBottomWidget();
    });
  }

  //刷新底部状态
  _refreshBottom() {
    this._getReposStatus();
  }
  //创建底部单个部件
  _renderBottomItem(var text, var icon, var onPressed){
    return new FlatButton(
        onPressed: onPressed,
        child: new GSYIConText(
            icon,
            text,
            GSYConstant.smallText,
            Color(GSYColors.primaryValue),
            15.0,
            padding: 3.0,
            mainAxisAlignment: MainAxisAlignment.center,
        ));
  }

  //获取底部部件
  _getBottomWidget(){
    List<Widget> bottomWidget = (bottomStatusModel == null)
        ? []
        : [
          _renderBottomItem(bottomStatusModel.starText, bottomStatusModel.starIcon, (){
            CommonUtils.showLoadingDialog(context);
            return ReposDao.doRepositoryStarDao(userName, reposName, bottomStatusModel.star).then((result) {
              _refreshBottom();
              Navigator.pop(context);
            });
          }),
          _renderBottomItem(bottomStatusModel.watchText, bottomStatusModel.watchIcon, (){
            CommonUtils.showLoadingDialog(context);
            return ReposDao.doRepositoryWatchDao(userName, reposName, bottomStatusModel.watch).then((result) {
              _refreshBottom();
              Navigator.pop(context);
            });
          }),
          _renderBottomItem("fock", GSYICons.REPOS_ITEM_FORK, (){
            CommonUtils.showLoadingDialog(context);
            return ReposDao.createForkDao(userName, reposName).then((result) {
              _refreshBottom();
              Navigator.pop(context);
            });
          })
    ];
    return bottomWidget;
  }

  //pageView配合tabbar，通过control同步
  _renderTabItem(){
    var itemList = [
      CommonUtils.getLocale(context).repos_tab_info,
      CommonUtils.getLocale(context).repos_tab_readme,
      CommonUtils.getLocale(context).repos_tab_issue,
      CommonUtils.getLocale(context).repos_tab_file,
    ];

    renderItem(String item, int i){
      return new FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            reposDetailParentControl.currentIndex = i;
            //平移
            topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
          },
          child: new Text(
            item,
            style: GSYConstant.smallTextWhite,
            maxLines: 1,
          )
      );
    }
    List<Widget> list = new List();
    for(int i = 0; i < itemList.length; i ++){
      list.add(renderItem(itemList[i], i));
    }
    return list;

  }

  //创建更多按钮信息
  _getMoreOtherItem(){
    return [
      //版本
      new GSYOptionModel(CommonUtils.getLocale(context).repos_option_release, CommonUtils.getLocale(context).repos_option_release, (model){
        String releaseUrl = "";
        String tagUrl = "";
        if (infoListKey == null || infoListKey.currentState == null) {
          releaseUrl = GSYConstant.app_default_share_url;
          tagUrl = GSYConstant.app_default_share_url;
        } else {
          releaseUrl = infoListKey.currentState.repository == null
              ? GSYConstant.app_default_share_url
              : infoListKey.currentState.repository.htmlUrl + "/releases";
          tagUrl =
          infoListKey.currentState.repository == null ? GSYConstant.app_default_share_url : infoListKey.currentState.repository.htmlUrl + "/tags";
        }
        //TODO 版本信息
//        NavigatorUtils.goReleasePage(context, userName, reposName, releaseUrl, tagUrl);

      }),
      //分支
      new GSYOptionModel(CommonUtils.getLocale(context).repos_option_branch, CommonUtils.getLocale(context).repos_option_branch, (model){
        if(branchList.length == 0) {
          return;
        }
        CommonUtils.showCommitOptionDialog(context, branchList, (value){
          setState(() {
            reposDetailParentControl.currentBranch = branchList[value];
          });
          if (infoListKey.currentState != null && infoListKey.currentState.mounted) {
            infoListKey.currentState.showRefreshLoading();
          }
          if (fileListKey.currentState != null && fileListKey.currentState.mounted) {
            fileListKey.currentState.showRefreshLoading();
          }
          if (readmeKey.currentState != null && readmeKey.currentState.mounted) {
            readmeKey.currentState.refreshReadme();
          }
        });
      }),
    ];
  }
  @override
  void initState() {
    super.initState();
    _getBranchList();
    _refreshBottom();
  }


  @override
  Widget build(BuildContext context) {
    Widget widget = new GSYCommonOptionWidget(titleOptionControl, otherList: _getMoreOtherItem());
    return new GSYTabBarWidget(
      type: GSYTabBarWidget.TOP_TAB,
      tarWidgetControl: tarBarControl,
      tabItems: _renderTabItem(),
      tabViews: [
        new ReposDetailInfoPage(userName, reposName, reposDetailParentControl, titleOptionControl, key: infoListKey),
        new RepositoryDetailReadmePage(userName, reposName, reposDetailParentControl, key: readmeKey),
        new RepositoryDetailIssuePage(userName, reposName),
        new RepositoryDetailFileListPage(userName, reposName, reposDetailParentControl, key: fileListKey),
      ],
      topPageControl: topPageControl,
      backgroundColor: GSYColors.primarySwatch,
      indicatorColor: Color(GSYColors.white),
      title: new GSYTitleBar(
        reposName,
        rightWidget: widget,
      ),
      onPageChanged: (index) {
        reposDetailParentControl.currentIndex = index;
      },
    );
  }

}


/**
 * 底部状态model
 */
class BottomStatusModel {
  final String watchText;
  final String starText;
  final IconData watchIcon;
  final IconData starIcon;
  final bool star;
  final bool watch;

  BottomStatusModel(this.watchText, this.starText, this.watchIcon, this.starIcon, this.watch, this.star);
}

/**
 * 描述详情父控件
 */
class ReposDetailParentControl {
  int currentIndex = 0;
  //当前分支
  String currentBranch;

  ReposDetailParentControl(this.currentBranch);
}
