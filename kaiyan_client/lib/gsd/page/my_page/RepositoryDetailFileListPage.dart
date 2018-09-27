import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailPage.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';


/**
 * 仓库文件列表
 */
class RepositoryDetailFileListPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final ReposDetailParentControl reposDetailParentControl;

  RepositoryDetailFileListPage(this.userName, this.reposName, this.reposDetailParentControl, {Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return RepositoryDetailFileListPageState(userName, reposName, reposDetailParentControl);
  }
}

class RepositoryDetailFileListPageState extends GSYListState<RepositoryDetailFileListPage>{
  final String userName;

  final String reposName;

  final ReposDetailParentControl reposDetailParentControl;


  RepositoryDetailFileListPageState(this.userName, this.reposName, this.reposDetailParentControl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: new Text("仓库文件列表"),);
  }

  // TODO: implement isRefreshFirst
  @override
  bool get isRefreshFirst => false;

}