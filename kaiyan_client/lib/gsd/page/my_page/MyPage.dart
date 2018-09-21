import 'package:flutter/material.dart';

/**
 * 主页我的tab页
 * Date: 2018-07-16
 */
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('主页我的tab页'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Text('主页我的tab页'),
        )
    );
  }
}