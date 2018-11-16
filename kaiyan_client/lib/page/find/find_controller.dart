import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';

class FindViewController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FindViewControllerState();
  }

}

class _FindViewControllerState extends State<FindViewController> with TickerProviderStateMixin{
  Widget _itemBuilder(BuildContext context, int index) {
    return new Padding(
      key: new Key(index.toString()),
      padding: new EdgeInsets.only(top: 40.0),
      child: new Text("顺序数据:$index",
        style: new TextStyle(fontSize: 14.0),
      ),
    );
  }

  int _itemCount;

  @override
  void initState() {
//    Navigator.popUntil(context, (Route<dynamic> route){
//      if(route.settings.name == ''){
//
//      }
//    });
    /*
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){

      return null;

    })).then((data){



    });*/



    _itemCount = 16;
    print("bbbbbbbb");

    super.initState();

    print("ccccccc");
  }

  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _itemCount += 10;
      });
    });
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _itemCount = 16;
      });
    });
  }

  @override
  Widget build(BuildContext context) {



    return new Scaffold(
        appBar: new AppBar(
          title: new Text("发现"),
        ),
        body: new SafeArea(
            child: new Refresh(
              onFooterRefresh: onFooterRefresh,
              onHeaderRefresh: onHeaderRefresh,
              childBuilder: (BuildContext context,
                  {ScrollController controller, ScrollPhysics physics}) {
                return new Container(
                    child: new ListView.builder(
                      physics: physics,
                      controller: controller,
                      itemBuilder: _itemBuilder,
                      itemCount: _itemCount,
                    ));
              },
            )));
  }

}