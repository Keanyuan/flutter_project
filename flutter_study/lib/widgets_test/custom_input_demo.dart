import 'package:flutter/material.dart';
import 'package:flutter_study/widgets_test/pin_input_text_field.dart';
import 'package:flutter_study/widgets_test/row_demo.dart';

class CustomInputDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }


}

class _MyHomePageState extends State<CustomInputDemo> {





  @override
  void initState() {
    super.initState();

    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {




    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CustomInput"),
      ),
      body: ListView(padding: EdgeInsets.all(10),children: <Widget>[
        CustomText("CustomInputDemo"),
        PinInputTextField(
          onSubmit: (pin) {
            //Add submit action.
            print(pin);
          },
          pinLength: 4,     // The length of the pin
          decoration: UnderlineDecoration(
              color: Colors.green,
              textStyle: TextStyle(color: Colors.green, fontSize: 25.0),
          ), // BoxTightDecoration or BoxLooseDecoration, UnderlineDecoration
          width: 300.0,
          height: 48.0,
        )
//        CustomText("Expanded弹性"),
//        ColumnExpandedWidget(),
      ],),
    );
  }
}