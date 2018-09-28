import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/dao/UserDao.dart';
import 'package:kaiyan_client/gsd/common/model/Event.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/model/UserOrg.dart';
import 'package:kaiyan_client/gsd/common/utils/EventUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/search_page/UserItem.dart';
import 'package:kaiyan_client/gsd/widget/EventItem.dart';
import 'package:kaiyan_client/gsd/widget/GSYListState.dart';
import 'package:kaiyan_client/gsd/widget/UserHeaderItem.dart';

/**
 * 个人中心 基类
 */
abstract class BasePersonState<T extends StatefulWidget> extends GSYListState<T> {

  final List<UserOrg> orgList = new List();

  @protected
  renderItem(index, User userInfo, String beStaredCount, Color notifyColor, VoidCallback refreshCallBack, List<UserOrg> orgList) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beStaredCount, Theme.of(context).primaryColor,
          notifyColor: notifyColor, refreshCallBack: refreshCallBack, orgList: orgList);
    }
    if (userInfo.type == "Organization") {
      return new UserItem(UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]), onPressed: () {
        // 个人中心
        NavigatorUtils.goPerson(context, UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]).userName);
      });
    } else {
      Event event = pullLoadWidgetControl.dataList[index - 1];
      return new EventItem(EventViewModel.fromEventMap(event), onPressed: () {
        // 个人中心
        EventUtils.ActionUtils(context, event, "");
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @protected
  getUserOrg(String userName) {
    if (page <= 1) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next;
        }
        return new Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

}
