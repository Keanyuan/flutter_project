
import 'package:flutter/material.dart';
import 'package:flutter_study/layout_demo/card_demo.dart';
import 'package:flutter_study/layout_demo/stack_demo.dart';
import 'package:flutter_study/layout_demo/wrap_widget.dart';
import 'package:flutter_study/widgets_test/column_demo.dart';
import 'package:flutter_study/widgets_test/container_demo.dart';
import 'package:flutter_study/widgets_test/grid_view_demo.dart';
import 'package:flutter_study/widgets_test/image_demo.dart';
import 'package:flutter_study/widgets_test/list_view_demo.dart';
import 'package:flutter_study/widgets_test/row_demo.dart';
import 'package:flutter_study/widgets_test/text_demo.dart';

class LayoutWidgetDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }


}

class _MyHomePageState extends State<LayoutWidgetDemo> {



  var buildList = [];

  List<Widget> controller = [];

  @override
  void initState() {
    super.initState();

    setState(() {

    });
  }
  //new SwiperTController()
  @override
  Widget build(BuildContext context) {
    buildList = [];
    controller = [];
    buildList.addAll([
      "Row",
      "Column",
      "Stack",
      "Card",
      "Wrap"
    ]);



    controller.addAll([
      RowDemo(),
      ColumnDemo(),
      StackDemo(),
      CardDemo(),
      WrapWidgetDemo(),
    ]);



    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Layout"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          return new Card(
            margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
            shape:  new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            color: Colors.white,
            child: new ListTile(
              title: new Text(buildList[index], style: TextStyle(color: Colors.grey),),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) =>  controller[index]));
              },
            ),
          );
        },
        itemCount: buildList.length,
      ),
    );
  }
}