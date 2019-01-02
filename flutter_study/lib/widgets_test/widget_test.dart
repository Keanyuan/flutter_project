
import 'package:flutter/material.dart';
import 'package:flutter_study/widgets_test/check_box_demo.dart';
import 'package:flutter_study/widgets_test/column_demo.dart';
import 'package:flutter_study/widgets_test/container_demo.dart';
import 'package:flutter_study/widgets_test/custom_gradient_button.dart';
import 'package:flutter_study/widgets_test/custom_input_demo.dart';
import 'package:flutter_study/widgets_test/grid_view_demo.dart';
import 'package:flutter_study/widgets_test/image_demo.dart';
import 'package:flutter_study/widgets_test/list_view_demo.dart';
import 'package:flutter_study/widgets_test/button_demo.dart';
import 'package:flutter_study/widgets_test/row_demo.dart';
import 'package:flutter_study/widgets_test/text_demo.dart';

class WidgetsListDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }


}

class _MyHomePageState extends State<WidgetsListDemo> {



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
      "Text",
      "Container",
      "Image",
      "ListView",
      "GridView",
      "Button",
      "CustomInput",
      "Switch CheckBox",
    ]);



    controller.addAll([
      TextDemo(),
      ContainerDemo(),
      ImageDemo(),
      ListViewWidgetDemo(),
      GridViewWidgetDemo(),
      RaisedButtonDemo(),
      CustomInputDemo(),
      SwitchAndCheckBoxTestRoute(),
    ]);



    return new Scaffold(
      appBar: new AppBar(
        title: new Text("WidgetsList"),
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