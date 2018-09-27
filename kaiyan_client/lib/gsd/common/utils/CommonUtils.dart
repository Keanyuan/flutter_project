import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';
import 'package:kaiyan_client/gsd/common/net/Address.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/redux/LocaleReducer.dart';
import 'package:kaiyan_client/gsd/common/redux/ThemeRedux.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/style/GSYStringBase.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/page/tool_page/IssueEditDialog.dart';
import 'package:kaiyan_client/gsd/widget/GSYFlexButton.dart';
import 'package:redux/redux.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
/**
 * 通用逻辑
 */
class CommonUtils {

  static double sStaticBarHeight = 0.0;


  static void initStatusBarHeight(context) async {
    sStaticBarHeight = await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  /**
   * 获得语言环境
   */
  static GSYStringBase getLocale(BuildContext context) {
    return GSYLocalizations.of(context).currentLocalized;
  }

  /**
   * 切换本地语言
   */
  static changeLocale(Store<GSYState> store, int index){
    Locale locale = store.state.platformLocale;

    switch(index){
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
  }

  /*改变主题*/
  static pushTheme(Store store, int index){
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = new ThemeData(primarySwatch: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }
  static List<Color> getThemeListColor() {
    return [
      GSYColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }


  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(child: SpinKitCubeGrid(color: Color(GSYColors.white))),
                        new Container(height: 10.0),
                        new Container(child: new Text(CommonUtils.getLocale(context).loading_text, style: GSYConstant.normalTextWhite)),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
  //aler弹出框
  static Future<Null> showDialogAlert(BuildContext context, String message){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(onPressed: (){
              Navigator.pop(context);
              }, child: new Text('确定')
            ),
          ],
        );
      },
    );
  }

  //切换主题对话框
  static Future<Null> showCommitOptionDialog(
      BuildContext context,
      List<String> commitMaps,
      ValueChanged<int> onTap, {
        width = 250.0,
        height = 400.0,
        List<Color> colorList,
      }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: Color(GSYColors.white),
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps.length,
                  itemBuilder: (context, index) {
                    return GSYFlexButton(
                      maxLines: 2,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null ? colorList[index] : Theme.of(context).primaryColor,
                      text: commitMaps[index],
                      textColor: Color(GSYColors.white),
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }


  //问题反馈弹框
  static Future<Null> showEditDialog(
      BuildContext context,
      String dialogTitle,
      ValueChanged<String> onTitleChanged,
      ValueChanged<String> onContentChanged,
      VoidCallback onPressed, {
        TextEditingController titleController,
        TextEditingController valueController,
        bool needTitle = true,
      }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new IssueEditDialog(
              dialogTitle,
              onTitleChanged,
              onContentChanged,
              onPressed,
              titleController: titleController,
              valueController: valueController,
              needTitle: needTitle,
            ),
          );
        });
  }



  ///版本更新
  static Future<Null> showUpdateDialog(BuildContext context, String contentMsg){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text(CommonUtils.getLocale(context).app_version_title),
          content: new Text(contentMsg),
          actions: <Widget>[
            new FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: new Text(CommonUtils.getLocale(context).app_cancel)),
            new FlatButton(
                onPressed: () {
                  launch(Address.updateUrl);
                  Navigator.pop(context);
                },
                child: new Text(CommonUtils.getLocale(context).app_ok)),
          ],
        );
      }
    );
  }

  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;


  ///日期格式转换
  static String getNewsTimeStr(DateTime date) {
    int subTime = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTime < MILLIS_LIMIT) {
      return "刚刚";
    } else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    } else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分钟前";
    } else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小时前";
    } else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    } else { //超过30天
      return getDateStr(date);
    }
  }

  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 10);
  }


  //获取用户图表地址
  static String getUserChartAddress(String userName) {
    return Address.graphicHost + GSYColors.primaryValueString.replaceAll("#", "") + "/" + userName;
  }

  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }
  //打卡URL
  static launchUrl(context, String url) {
    if (url == null && url.length == 0) return;
    Uri parseUrl = Uri.parse(url);
    bool isImage = isImageEnd(parseUrl.toString());
    if (parseUrl.toString().endsWith("?raw=true")) {
      isImage = isImageEnd(parseUrl.toString().replaceAll("?raw=true", ""));
    }
    if (isImage) {
      //是图片 放大图片
      NavigatorUtils.gotoPhotoViewPage(context, url);
      return;
    }

    if (parseUrl != null && parseUrl.host == "github.com" && parseUrl.path.length > 0) {
      List<String> pathnames = parseUrl.path.split("/");
      if (pathnames.length == 2) {
        //解析人
        String userName = pathnames[1];
        //跳转到个人中心
        NavigatorUtils.goPerson(context, userName);
      } else if (pathnames.length >= 3) {
        String userName = pathnames[1];
        String repoName = pathnames[2];
        //解析仓库
        if (pathnames.length == 3) {
          //跳转到仓库详情
          NavigatorUtils.goReposDetail(context, userName, repoName);
        } else {
          launchWebView(context, "", url);
        }
      }
    } else if (url != null && url.startsWith("http")) {
      launchWebView(context, "", url);
    }
  }

  //打开webview
  static void launchWebView(BuildContext context, String title, String url) {
    if (url.startsWith("http") || url.startsWith("https")) {
      NavigatorUtils.goGSYWebView(context, url, title);
    } else {
      NavigatorUtils.goGSYWebView(
          context, new Uri.dataFromString(url, mimeType: 'text/html', encoding: Encoding.getByName("utf-8")).toString(), title);
    }
  }

  //浏览器打开URL
  static launchOutURL(String url, BuildContext context) async {
    if(await canLaunch(url)){
      //forceSafariVC forceWebView
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: CommonUtils.getLocale(context).option_web_launcher_error + ": " + url);
    }
  }

  //复制链接
  static copy(String data, BuildContext context){
    Clipboard.setData(new ClipboardData(text: data));
    Fluttertoast.showToast(msg: CommonUtils.getLocale(context).option_share_copy_success);
  }

}