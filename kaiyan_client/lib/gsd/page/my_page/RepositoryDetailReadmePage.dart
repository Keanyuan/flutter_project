import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/page/my_page/RepositoryDetailPage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(child: new Text("Readme详情"),);
  }
  @override
  bool get wantKeepAlive => true;

}