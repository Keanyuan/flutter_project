import 'package:flutter/material.dart';
import 'package:kaiyan_client/util/constant.dart';
import 'package:kaiyan_client/widget/type_text.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //背景图片
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
              Constant.dir_image + "author_account_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0, left: 10.0),
          child: GestureDetector(
            child: new Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 40.0,
            ),
            onTap: (){
              Navigator.pop(context);
          },),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '登录',
                style: TextStyle(color: Colors.white, fontSize: 27.0),
              ),
              TypeText(
                delay: 100,
                text: '欢迎来到我的登录页，这将是第一个flutter app，将为你展现不一样的风格',
                style: TextStyle(color: Colors.white),
              ),
              FractionalTranslation(
                translation: const Offset(1.0, 0.0),
                child: TypeText(
                  delay: 1000,
                  text: 'Code by Kean',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

}