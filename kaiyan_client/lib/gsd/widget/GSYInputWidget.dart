import 'package:flutter/material.dart';

class GSYInputWidget extends StatefulWidget {

  //密码隐藏不可见
  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final IconData prefixIcon;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;


  GSYInputWidget({Key key,this.obscureText = false, this.hintText, this.iconData, this.onChanged,
    this.textStyle, this.controller, this.prefixIcon}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GSYInputWidgetState();
  }

}

class _GSYInputWidgetState extends State<GSYInputWidget> {
  _GSYInputWidgetState() : super();


  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      autocorrect: false,
      decoration: new InputDecoration(
        hintText: widget.hintText,
        icon: widget.iconData == null ? null : new Icon(widget.iconData),
        prefixIcon: widget.prefixIcon == null ?  null : new Icon(widget.prefixIcon),
        border:  widget.prefixIcon == null ?  UnderlineInputBorder() : OutlineInputBorder(),
      ),
    );
  }

}