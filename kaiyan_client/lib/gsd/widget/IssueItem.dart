import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/model/Issue.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYCardItem.dart';
import 'package:kaiyan_client/gsd/widget/GSYIConText.dart';
import 'package:kaiyan_client/gsd/widget/GSYMarkdownWidget.dart';
import 'package:kaiyan_client/gsd/widget/GSYUserIconWidget.dart';

/**
 * Issue相关item
 */
class IssueItem extends StatelessWidget {

  final IssueItemViewModel issueItemViewModel;

  ///点击
  final GestureTapCallback onPressed;

  ///长按
  final GestureTapCallback onLongPress;

  ///是否需要底部状态
  final bool hideBottom;

  ///是否需要限制内容行数
  final bool limitComment;

  IssueItem(this.issueItemViewModel, {this.onPressed, this.onLongPress, this.hideBottom = false, this.limitComment = true});

  ///issue 底部状态
  _renderBottomContainer(){
    Color issueStateColor = issueItemViewModel.state == "open" ? Colors.green : Colors.red;
    return (hideBottom)
        ? new Container()
        : new Row(
      children: <Widget>[
        ///issue 关闭打开状态
        new GSYIConText(
          GSYICons.ISSUE_ITEM_ISSUE,
          issueItemViewModel.state,
          TextStyle(
            color: issueStateColor,
            fontSize: GSYConstant.smallTextSize,
          ),
          issueStateColor,
          15.0,
          padding: 2.0,
        ),
        new Padding(padding: new EdgeInsets.all(2.0)),

        ///issue标号
        new Expanded(
          child: new Text(issueItemViewModel.issueTag, style: GSYConstant.smallSubText),
        ),

        ///评论数
        new GSYIConText(
          GSYICons.ISSUE_ITEM_COMMENT,
          issueItemViewModel.commentCount,
          GSYConstant.smallSubText,
          Color(GSYColors.subTextColor),
          15.0,
          padding: 2.0,
        ),
      ],
    );
  }

  ///评论内容
  _renderCommentText(){
    return (limitComment)
        ? new Container(
      child: new Text(
        issueItemViewModel.issueComment,
        style: GSYConstant.smallSubText,
        maxLines: limitComment ? 2 : 1000,
      ),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft,
    )
        : GSYMarkdownWidget(markdownData: issueItemViewModel.issueComment);
  }


  @override
  Widget build(BuildContext context) {
    return GSYCardItem(child: new InkWell(
      onTap: onPressed,
      onLongPress: onLongPress,
      child: new Padding(
        padding: new EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0, bottom: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///头像
            new GSYUserIconWidget(
                width: 30.0,
                height: 30.0,
                image: issueItemViewModel.actionUserPic,
                onPressed: () {
                  NavigatorUtils.goPerson(context, issueItemViewModel.actionUser);
                }),
            new Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //第一列
                new Row(
                  children: <Widget>[
                    ///用户名
                    new Expanded(child: new Text(issueItemViewModel.actionUser, style: GSYConstant.smallTextBold)),
                    //评论时间
                    new Text(
                      issueItemViewModel.actionTime,
                      style: GSYConstant.smallSubText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                //第二列
                ///评论内容
                _renderCommentText(),

                new Padding( padding: new EdgeInsets.only(left: 0.0, top: 2.0, right: 0.0, bottom: 0.0)),

                //第三列
                //底部部件
                _renderBottomContainer(),

              ],
            ))
          ],
        ),
      ),
    ));
  }

}


class IssueItemViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";
  String issueComment = "---";
  String commentCount = "---";
  String state = "---";
  String issueTag = "---";
  String number = "---";
  String id = "";

  IssueItemViewModel();

  IssueItemViewModel.fromMap(Issue issueMap, {needTitle = true}) {
    String fullName = CommonUtils.getFullName(issueMap.repoUrl);
    actionTime = CommonUtils.getNewsTimeStr(issueMap.createdAt);
    actionUser = issueMap.user.login;
    actionUserPic = issueMap.user.avatar_url;
    if (needTitle) {
      issueComment = fullName + "- " + issueMap.title;
      commentCount = issueMap.commentNum.toString();
      state = issueMap.state;
      issueTag = "#" + issueMap.number.toString();
      number = issueMap.number.toString();
    } else {
      issueComment = issueMap.body ?? "";
      id = issueMap.id.toString();
    }
  }
}