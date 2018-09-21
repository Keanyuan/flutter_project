import 'package:flutter/material.dart';

/**
 * 主页动态tab页
 * Date: 2018-07-16
 */
class DynamicPage extends StatefulWidget {
  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('我的主页'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Text('主页'),
        )
    );
  }
}