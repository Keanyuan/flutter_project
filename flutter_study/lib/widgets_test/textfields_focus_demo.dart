/**
 * 实现原理：
 * 使用FocusNode获取当前textField焦点
 * 在TextNode的textInputAction属性中选择键盘action（next/down）
 * 对于最后一个之前的TextField：在onSubmitted属性中解除当前focus状态
 * 再聚焦下一个FocusNode:FocusScope.of(context).requestFocus( nextFocusNode );
 * 对于最后一个TextField,直接解除focus并提交表单
 */
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TextFieldFocusDemo extends StatefulWidget {
  @override
  State createState() => TextFieldFocusDemoState();
}

class TextFieldFocusDemoState extends State<TextFieldFocusDemo> {
  TextEditingController _nameController,_pwController;
  FocusNode _nameFocus,_pwFocus;
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwController = TextEditingController();
    _nameFocus = FocusNode();
    _pwFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: SafeArea(
        child: ListView(padding: EdgeInsets.all(16.0),
          children: <Widget>[
            const SizedBox(height: 60.0),
            Material(
              borderRadius: BorderRadius.circular(10.0),
              child: TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                obscureText: false,
                textInputAction: TextInputAction.next,
                onSubmitted: (input){
                  _nameFocus.unfocus();
                  FocusScope.of(context).requestFocus(_pwFocus);
                },
                decoration: InputDecoration(
                  labelText: "name",
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Material(
              borderRadius: BorderRadius.circular(10.0),
              child: TextField(
                focusNode: _pwFocus,
                controller: _pwController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (input){
                  _pwFocus.unfocus();
                  //登陆请求
//                    _login();
                },
                decoration: InputDecoration(
                  labelText: "password",
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            new InputDecorator(
              decoration: const InputDecoration(
//                icon: const Icon(Icons.color_lens),
                labelText: 'Color',
              ),
              isEmpty: _color == '',
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: _color,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      _color = newValue;
                    });
                  },
                  items: _colors.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 40.0,),
            ButtonBar(
              children: <Widget>[
                RaisedButton(onPressed: _login,child: Text('login'),color: Colors.white,)
              ],
            )
          ],
        ),
      ),
    );
  }

  _login() async{
    Fluttertoast.showToast(msg: "登录成功", gravity: ToastGravity.CENTER);

  }
}