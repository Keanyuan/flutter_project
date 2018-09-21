import 'package:flutter/material.dart';

/**
 * 主页趋势tab页
 * Date: 2018-07-16
 */
class TrendPage extends StatefulWidget {
  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('主页趋势tab页'),
          centerTitle: true,
        ),
        body: new Center(
          child: new Text('主页趋势tab页'),
        )
    );
  }
}