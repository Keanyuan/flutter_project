
import 'package:flutter/material.dart';
import 'package:flutter_study/web/ChartsWebPage.dart';
import 'package:flutter_study/web/webview_page.dart';

class GridViewWidgetDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GridViewGridDelegateState();
  }
}
//ListView
class _GridViewWidgetState extends State<GridViewWidgetDemo> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GridView"),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding:const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: <Widget>[
          Container(color: Colors.orange, child: const Text('GridView'),),
          Container(color: Colors.orange, child: const Text('GridView'),),
          Container(color: Colors.orange, child: const Text('GridView'),),
          Container(color: Colors.orange, child: const Text('GridView'),),
          Container(color: Colors.orange, child: const Text('GridView'),),
          Container(color: Colors.orange, child: const Text('GridView'),),

        ],
      ),
    );
  }
}
//ListView
class _GridViewGridDelegateState extends State<GridViewWidgetDemo> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("GridView"),
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            childAspectRatio: 0.7, //宽高比
        ),
        children: <Widget>[
          new Image.network('http://img5.mtime.cn/mt/2018/10/22/104316.77318635_180X260X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/10/10/112514.30587089_180X260X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/13/093605.61422332_180X260X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/07/092515.55805319_180X260X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/21/090246.16772408_135X190X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/17/162028.94879602_135X190X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/19/165350.52237320_135X190X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/16/115256.24365160_180X260X4.jpg',fit: BoxFit.cover),
          new Image.network('http://img5.mtime.cn/mt/2018/11/20/141608.71613590_135X190X4.jpg',fit: BoxFit.cover),
        ],
      )
    );
  }
}