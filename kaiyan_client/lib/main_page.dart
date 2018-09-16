import 'package:flutter/material.dart';
import 'package:kaiyan_client/page/home/home.dart';
import 'package:kaiyan_client/page/login.dart';
import 'package:kaiyan_client/util/constant.dart';
import 'package:kaiyan_client/widget/common_widget.dart';
import 'package:kaiyan_client/widget/route_animation.dart';
import 'package:scoped_model/scoped_model.dart';

int _curIndex = 0;

class MainPage extends StatefulWidget {

  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    return ScopedModel<IndexModel>(
      model: IndexModel(),
      child: Scaffold(
        //TODO
        body: SafeArea(child: _body()),
        bottomNavigationBar: Container(
          height: 49.0,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              MyDirver(),
              Container(
                height: 48.0,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconText(0),
                    IconText(1),
                    Expanded(
                      child: GestureDetector(
                        child: Image.asset(
                          Constant.dir_image + 'publish_add.png',
                          height: 48.0,
                          width: 48.0,
                        ),
                        onTap: (){
                          Navigator.push(context, AnimationPageRoute(
                            sildeTween: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero
                            ),
                            builder: (c){
                              return Login();
                            }
                          ));
                        },
                      ),
                    ),
                    IconText(2),
                    IconText(3)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

  /**
   * 方法
   */
  final MaterialColor c_normal = Colors.blue;
  final MaterialColor c_select = Colors.red;
  final titles = ['首页', '关注', '通知', '我的'];


  Widget _body() {
    return ScopedModelDescendant<IndexModel>(
      builder: (ctx, child, model){
        return IndexedStack(
          index: model._index,
          children: <Widget>[
            HomeViewController(),
            Text(titles[1]),
            Text(titles[2]),
            Text(titles[3]),
          ],
        );
      },
    );
  }

    Widget getIcon(int i, IconData data){
    if (i == _curIndex){
      return Icon(
        data,
        color: c_select,
      );
    }
    return Icon(
      data,
      color: c_normal,
    );
  }

}



class IconText extends StatefulWidget {
  final int index;
  const IconText(this.index);

  @override
  _IconTextState createState() => _IconTextState();
}

class _IconTextState extends State<IconText> {

  var titles = ['首页', '关注', '通知', '我的'];
  var icons_normal = [
    'ic_tab_strip_icon_feed.png',
    'ic_tab_strip_icon_follow.png',
    'ic_tab_strip_icon_category.png',
    'ic_tab_strip_icon_profile.png'
  ];

  var icons_selcect = [
    'ic_tab_strip_icon_feed_selected.png',
    'ic_tab_strip_icon_follow_selected.png',
    'ic_tab_strip_icon_category_selected.png',
    'ic_tab_strip_icon_profile_selected.png'
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<IndexModel>(
      builder: (ctx, child, model){
        return Expanded(
          child: GestureDetector(
            child: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    widget.index == model._index
                        ? Constant.dir_image + icons_selcect[widget.index]
                        : Constant.dir_image + icons_normal[widget.index],
                    height: 30.0,
                  ),
                  Text(
                    titles[widget.index],
                    style: TextStyle(fontSize: 8.0),
                  )
                ],
              ),

            ),
            onTap: (){
              model.changeIndex(widget.index);
            },
          ),
        );
      });
  }

}


/**
 * 定义控制器model
 *
 */
class IndexModel extends Model {
  int _index = 0;

  void changeIndex(int i){
    _index = i;
    notifyListeners();
  }
}