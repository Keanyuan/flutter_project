import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kaiyan_client/api/api.dart';
import 'package:kaiyan_client/events/loginEvent.dart';
import 'package:kaiyan_client/model/user_Info.dart';
import 'package:kaiyan_client/page/login.dart';
import 'package:kaiyan_client/util/constant.dart';
import 'package:kaiyan_client/util/data_utils.dart';
import 'package:kaiyan_client/util/net_utils.dart';
import 'package:kaiyan_client/widget/common_web_page.dart';
import 'package:kaiyan_client/widget/route_animation.dart';
import 'package:kaiyan_client/widget/webview_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaiyan_client/util/constant.dart';

class MineController extends StatefulWidget {

  MineController({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MineControllerState();
  }

}

class _MineControllerState extends State<MineController> {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var titles = ["我的消息", "阅读记录", "我的博客", "我的问答", "我的活动", "我的团队", "邀请好友"];
  var imagePaths = [
    "ic_my_message.png",
    "ic_my_blog.png",
    "ic_my_blog.png",
    "ic_my_question.png",
    "ic_discover_pos.png",
    "ic_my_team.png",
    "ic_my_recommend.png"
  ];

  var icons = [];
  //头像
  var userAvatar;
  var userName;
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    Constant.dir_image + 'ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );


  _MineControllerState(){
    for(int i = 0; i < imagePaths.length; i++){
      icons.add(getIconImage(Constant.dir_image + imagePaths[i]));
    }
  }

  Widget getIconImage(path){
    return new Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: new Image.asset(
        path,
        width: IMAGE_ICON_WIDTH,
        height: IMAGE_ICON_WIDTH,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showUserInfo();
  }

  _showUserInfo(){
    DataUtils.getUserInfo().then((UserInfo userInfo){
      if(userInfo != null){
        setState(() {
          userAvatar = userInfo.avatar;
          userName = userInfo.name;
        });
      } else {
        setState(() {
          userAvatar = null;
          userName = null;
        });
      }
    });
  }

  _showUserInfoDetail() {}

  _login() async {
    final result = await Navigator
        .of(context)
        .push(new MaterialPageRoute(builder: (context) {
          //TODO
      return null;
//      return new LoginPage();
    }));
    if (result != null && result == "refresh") {
      // 刷新用户信息
//      getUserInfo();
      // 通知动弹页面刷新
      Constant.eventBus.fire(new LoginEvent());
    }
  }

  // 获取用户信息
  getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String accessToken = sp.get(DataUtils.SP_AC_TOKEN);
    Map<String, String> params = new Map();
    params['access_token'] = accessToken;
    NetUtils.get(Api.USER_INFO, params: params).then((data) {
      if (data != null) {
        var map = json.decode(data);
        setState(() {
          userAvatar = map['avatar'];
          userName = map['name'];
        });
        DataUtils.saveUserInfo(map);
      }
    });
  }



  @override
  Widget build(BuildContext context) {


    return new Container(
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('我的',
                style: new TextStyle(color: Colors.white, fontFamily: 'Lobster')),
            iconTheme: new IconThemeData(color: Colors.white),
          ),
          body:  new ListView.builder(
            itemCount: titles.length * 2,
            itemBuilder: (context, i){
              return renderRow(i);
            },
          ),
        )
    );
  }

  renderRow(i){
    if(i == 0){
      var avatarContainer = new Container(
        color: const Color(0xff63ca6c),
        height: 200.0,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userAvatar == null
                  ? new Image.asset(
                Constant.dir_image + 'ic_avatar_default.png',
                width: 60.0,
              )
                  : new Container(
                width: 60.0,
                height: 60.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: new DecorationImage(
                    image: new NetworkImage(userAvatar),
                    fit: BoxFit.cover
                  ),
                  border: new Border.all(
                    color: Colors.white,
                    width: 2.0
                  )
                ),
              ),
              new Text(
                userName == null ? '点击头像登录' : userName,
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              )

            ],
          ),
        ),
      );

      return new GestureDetector(
        onTap: (){
          _showLoginDialog();
//          DataUtils.isLogin().then((isLogin){
//            if(isLogin){
//              // 已登录，显示用户详细信息
//              _showUserInfoDetail();
//            } else {
//              // 未登录，跳转到登录页面
//              _login();
//            }
//          });
        },
        child: avatarContainer,
      );
    }

    --i;
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    }

    i = i ~/ 2;

    String title = titles[i];
    var listItemContent = new Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: new Row(
        children: <Widget>[
          icons[i],
          new Expanded(child:
            new Text(
              title,
              style: titleTextStyle
            )),
          rightArrowIcon
        ],
      ),
    );

    return InkWell(
      child: listItemContent,
      onTap: (){
        _handleListItemClick(title);
      },
    );

  }

  _showLoginDialog(){
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: new Text('提示'),
          content: new Text('没有登录，现在去登录吗？'),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: new Text(
                  '取消',
                  style: new TextStyle(color: Colors.red),
                )
            ),
            new FlatButton(
              child: new Text(
                '确定',
                style: new TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, AnimationPageRoute(
                    sildeTween: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero
                    ),
                    builder: (c){
                      return Login();
                    }
                ));
//                _login();
              },
            )
          ],
        );
      }
    );
  }



  _handleListItemClick(String title){

//    Navigator.of(context).push(new MaterialPageRoute(
//        builder: (context) {
//          return new WebPageBaseController(title: "码云封面人物", url: "https://www.baidu.com");
//        }
//    ));


//    DataUtils.isLogin().then((isLogin){
//      if (!isLogin) {
//        // 未登录
//        _showLoginDialog();
//      } else {
//        DataUtils.getUserInfo().then((info){
//          Navigator.of(context).push(
//            new MaterialPageRoute(
//              builder: (context) => new CommonWebPage(
//                title: '我的博客',
//                url: "https://my.oschina.net/u/${info.id}/blog",
//              )
//            )
//          );
//        });
//      }
//    });
  }





}