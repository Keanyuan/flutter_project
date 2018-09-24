import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/SqlManager.dart';
import 'package:kaiyan_client/gsd/common/config/Config.dart';
import 'package:kaiyan_client/gsd/common/dao/EventDao.dart';
import 'package:kaiyan_client/gsd/common/dao/IssueDao.dart';
import 'package:kaiyan_client/gsd/common/dao/ReposDao.dart';
import 'package:kaiyan_client/gsd/common/dao/UserDao.dart';
import 'package:kaiyan_client/gsd/common/local/LocalStorage.dart';
import 'package:kaiyan_client/gsd/common/localization/GSYLocalizations.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/common/utils/NavigatorUtils.dart';
import 'package:kaiyan_client/gsd/widget/GSYFlexButton.dart';
import 'package:redux/redux.dart';
import 'package:get_version/get_version.dart';


/**
* 主页drawer
*/
class HomeDrawer extends StatelessWidget {

  //关于
  showAboutDialog(BuildContext context, String versionName){
    versionName ??= "Null";
    showDialog(
      context: context,
      builder: (BuildContext context) => AboutDialog(
        applicationName: CommonUtils.getLocale(context).app_name,
        applicationVersion: CommonUtils.getLocale(context).app_version + ': ' + versionName,
        applicationIcon: new Image(image: new AssetImage(GSYICons.DEFAULT_USER_ICON), width: 50.0, height: 50.0),
        applicationLegalese: "https://github.com/Keanyuan",
      )
    );
  }


  //切换主题
  showThemeDialog(BuildContext context, Store store){
    List<String> list = [
      CommonUtils.getLocale(context).home_theme_default,
      CommonUtils.getLocale(context).home_theme_1,
      CommonUtils.getLocale(context).home_theme_2,
      CommonUtils.getLocale(context).home_theme_3,
      CommonUtils.getLocale(context).home_theme_4,
      CommonUtils.getLocale(context).home_theme_5,
      CommonUtils.getLocale(context).home_theme_6,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index){
      CommonUtils.pushTheme(store, index);
      print("theme-color:  " + index.toString());
      LocalStorage.save(Config.THEME_COLOR, index.toString());
    }, colorList: CommonUtils.getThemeListColor());
  }

  ///切换语言
  showLanguageDialog(BuildContext context, Store store) {
    List<String> list = [
      CommonUtils.getLocale(context).home_language_default,
      CommonUtils.getLocale(context).home_language_zh,
      CommonUtils.getLocale(context).home_language_en,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index){
      CommonUtils.changeLocale(store, index);
      print("locale:  " + index.toString());
      LocalStorage.save(Config.LOCALE, index.toString());
    }, height: 150.0);
  }


  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(
      builder: (context, store){
        User user = store.state.userInfo;
        return new Drawer(
          child: new Container(
            color: store.state.themeData.primaryColor,
            child: new SingleChildScrollView(
              child: Container(
                constraints: new BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: new Material(
                  color: Color(GSYColors.white),
                  child: new Column(
                    children: <Widget>[
                      new UserAccountsDrawerHeader(
                        //Material内置控件 用户名
                        accountName: new Text(user.login ?? "---", style: GSYConstant.largeTextWhite),
                        //邮箱
                        accountEmail: new Text(user.email ?? user.name ?? "---", style: GSYConstant.normalTextLight),
                        //头像
                        currentAccountPicture: new GestureDetector(
                          onTap: (){},
                          child: new CircleAvatar(backgroundImage: new NetworkImage(user.avatar_url ?? GSYICons.DEFAULT_REMOTE_PIC))
                        ),
                        //用一个BoxDecoration装饰器提供背景图片
                        decoration: new BoxDecoration(color: store.state.themeData.primaryColor),
                      ),

                      //问题反馈
                      new ListTile(
                        title: new Text(CommonUtils.getLocale(context).home_reply, style: GSYConstant.normalText),
                        onTap: (){
                          _problemFaceBack(context);
                        },
                      ),

                      //阅读历史
                      new ListTile(
                        title: new Text(
                          CommonUtils.getLocale(context).home_history,
                          style: GSYConstant.normalText,
                        ),
                        onTap: (){
                          //TODO 阅读历史
                          NavigatorUtils.gotoCommonList(context, CommonUtils.getLocale(context).home_history, "repository", "history",
                              userName: "", reposName: "");
                          },
                      ),

                      //个人信息
                      new ListTile(
                        title: new Text(CommonUtils.getLocale(context).home_user_info, style: GSYConstant.normalText),
                        onTap: (){
                          NavigatorUtils.gotoUserProfileInfo(context);
                        },
                      ),

                      //切换主题
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_change_theme,
                            style: GSYConstant.normalText,
                          ),
                          onTap: () {
                            showThemeDialog(context, store);
                          }),

                      //切换语言
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_change_language,
                            style: GSYConstant.normalText,
                          ),
                          onTap: () {
                            showLanguageDialog(context, store);
                          }),

                      //检测更新
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_check_update,
                            style: GSYConstant.normalText,
                          ),
                          onTap: () {
                            ReposDao.getNewsVersion(context, true);
                          }),

                      //关于
                      new ListTile(
                          title: new Text(
                            GSYLocalizations.of(context).currentLocalized.home_about,
                            style: GSYConstant.normalText,
                          ),
                          onTap: () {
                            //TODO 关于
                            GetVersion.projectVersion.then((value){
                              showAboutDialog(context, value);
                            });
                          }),

                      //退出登录
                      new ListTile(
                        title: new GSYFlexButton(
                          text: CommonUtils.getLocale(context).Login_out,
                          color: Colors.redAccent,
                          textColor: Color(GSYColors.textWhite),
                          onPress: (){
                            UserDao.clearAll(store);
                            EventDao.clearEvent(store);
                            SqlManager.close();
                            NavigatorUtils.goLogin(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  _problemFaceBack(BuildContext context){
    String content = "";
    CommonUtils.showEditDialog(context, CommonUtils.getLocale(context).home_reply,
            (title){},
            (res){
      content = res;
            },
            (){
              if (content == null || content.length == 0) {
                return;
              }
              CommonUtils.showLoadingDialog(context);
              IssueDao.createIssueDao(
                  "Keanyuan", "flutter_project", {"title": CommonUtils.getLocale(context).home_reply, "body": content})
                  .then((result) {
                Navigator.pop(context);
                Navigator.pop(context);
              });

            },
        titleController: new TextEditingController(),
        valueController: TextEditingController(),
        needTitle: false);
  }
}
