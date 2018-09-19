import 'package:flutter/material.dart';


class GSYFlexButton extends StatelessWidget{
  final String text;

  final Color color;

  final Color textColor;

  final VoidCallback onPress;

  final double fontSize;

  final int maxLines;

  final MainAxisAlignment mainAxisAlignment;

  GSYFlexButton({Key key, this.text, this.color, this.textColor, this.onPress,
    this.fontSize = 20.0, this.maxLines = 1, this.mainAxisAlignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {

    return new RaisedButton(
      onPressed: (){
        this.onPress?.call();
      },
      padding: new EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
      textColor: textColor,
      color: color,
      child: new Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          new Text(text, style: new TextStyle(fontSize: fontSize), maxLines: maxLines, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );

  }


}