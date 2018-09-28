import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailPage.dart';
import 'package:kaiyan_client/gsd/widget/GSYMarkdownWidget.dart';

/**
 * Readme详情
 */
class RepositoryDetailReadmePage extends StatefulWidget {
  final String userName;

  final String reposName;

  final ReposDetailParentControl reposDetailParentControl;

  RepositoryDetailReadmePage(this.userName, this.reposName, this.reposDetailParentControl, {Key key}) : super(key: key);

  @override
  RepositoryDetailReadmePageState createState() => RepositoryDetailReadmePageState(userName, reposName, reposDetailParentControl);
}

class RepositoryDetailReadmePageState extends State<RepositoryDetailReadmePage> with AutomaticKeepAliveClientMixin{
  final String userName;

  final String reposName;

  final ReposDetailParentControl reposDetailParentControl;

  bool isShow = false;

  String markdownData;

  RepositoryDetailReadmePageState(this.userName, this.reposName, this.reposDetailParentControl);

  refreshReadme(){
    ReposDao.getRepositoryDetailReadmeDao(userName, reposName, reposDetailParentControl.currentBranch).then((res){
      //先获取数据库信息
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next;
        }
      }
      return new Future.value(null);
    }).then((res){
      //再获取请求信息
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(markdownData == null){
      //加载动画
      return Center(
        child: new Container(
          width: 200.0,
          height: 200.0,
          padding: new EdgeInsets.all(4.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
              new Container(width: 10.0,),
              new Container(child: new Text(CommonUtils.getLocale(context).loading_text, style: GSYConstant.middleText),)
            ],
          ),
        ),
      );
    }

    return GSYMarkdownWidget(markdownData: markdownData);
  }
}