import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(child: new Text("仓库详情issue列表"),);
  }

  @override
  bool get isRefreshFirst => false;

}