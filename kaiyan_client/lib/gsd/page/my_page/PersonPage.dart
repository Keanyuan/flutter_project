import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiyan_client/gsd/common/config/Config.dart';
import 'package:kaiyan_client/gsd/common/dao/EventDao.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/dao/UserDao.dart';
import 'package:kaiyan_client/gsd/common/local/LocalStorage.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/model/UserOrg.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTitleBar.dart';
import 'package:kaiyan_client/gsd/widget/BasePersonState.dart';
import 'package:kaiyan_client/gsd/widget/GSYCommonOptionWidget.dart';
import 'package:kaiyan_client/gsd/widget/GSYPullLoadWidgetControl.dart';
import 'package:redux/redux.dart';

/**
 * 个人详情
 */
class PersonPage extends StatefulWidget {
  static final String sName = "person";

  final String userName;

  PersonPage(this.userName, {Key key}) : super(key: key);

  @override
  _PersonState createState() => _PersonState(userName);
}

class _PersonState extends BasePersonState<PersonPage> {
  final String userName;

  String beStaredCount = "---";

  bool isUser_Self = true;


  bool focusStatus = false;

  String focus = "";

  User userInfo = User.empty();

  final List<UserOrg> orgList = new List();

  final OptionControl titleOptionControl = new OptionControl();

  _PersonState(this.userName);

  _resolveUserInfo(res) {
    if (isShow) {
      setState(() {
        userInfo = res.data;
        titleOptionControl.url = res.data.html_url;
      });
    }
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var userResult = await UserDao.getUserInfo(userName, needDb: true);
    if (userResult != null && userResult.result) {
      _resolveUserInfo(userResult);
      if (userResult.next != null) {
        userResult.next.then((resNext) {
          _resolveUserInfo(resNext);
        });
      }
    } else {
      return null;
    }
    var res = await _getDataLogic();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    _getFocusStatus();
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            beStaredCount = res.data.toString();
          });
        }
      }
    });
    return null;
  }

  Store<GSYState> _getStore() {
    return StoreProvider.of(context);
  }

  _getFocusStatus() async {
    var focusRes = await UserDao.checkFollowDao(userName);
    var userName1 = _getStore().state.userInfo.login;

    if (isShow) {
      setState(() {
        //判断用户是否是自己  是不是自己显示关注按钮
        if(userName1 == userName){
          isUser_Self = true;
        } else {
          isUser_Self = false;
        }
        focus = (focusRes != null && focusRes.result) ? CommonUtils.getLocale(context).user_focus : CommonUtils.getLocale(context).user_un_focus;
        focusStatus = (focusRes != null && focusRes.result);
      });
    }
  }



  _getUserName() {
    if (userInfo == null) {
      return new User.empty();
    }
    return userInfo.login;
  }

  _getFloatingActionButton(){
    if(isUser_Self) {
      return null;
    }
    return new FloatingActionButton(
        child: new Text(focus),
        onPressed: () {
          if (focus == '') {
            return;
          }
          if (userInfo.type == "Organization") {
            Fluttertoast.showToast(msg: CommonUtils.getLocale(context).user_focus_no_support);
            return;
          }
          CommonUtils.showLoadingDialog(context);
          UserDao.doFollowDao(userName, focusStatus).then((res) {
            Navigator.pop(context);
            _getFocusStatus();
          });
        });
  }

  _getDataLogic() async {
    if (userInfo.type == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    getUserOrg(_getUserName());
    return await EventDao.getEventDao(_getUserName(), page: page, needDb: page <= 1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {}

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: GSYTitleBar(
              (userInfo != null && userInfo.login != null) ? userInfo.login : "",
              rightWidget: GSYCommonOptionWidget(titleOptionControl),
            )),
        floatingActionButton: _getFloatingActionButton(),
        body: GSYPullLoadWidget(
          pullLoadWidgetControl,
              (BuildContext context, int index) => renderItem(index, userInfo, beStaredCount, null, null, orgList),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
        ));
  }
}
