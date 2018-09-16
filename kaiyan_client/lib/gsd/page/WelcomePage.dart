import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:redux/redux.dart';


class WelcomePage extends StatefulWidget {
  static final String sName = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {

  bool hadInit = false;

  ///概念依赖关系
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(hadInit){
      return;
    }
    hadInit = true;

    Store<GSYState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);


  }

  @override
  Widget build(BuildContext context) {

    return StoreBuilder<GSYState>(builder: (context, store){
      return new Container(
        color: Color(GSYColors.white),
        child: new Center(
          child: new Image(image: new AssetImage('images/welcome.png')),
        ),
      );
    });

  }

}

