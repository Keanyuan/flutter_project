import 'package:flutter/material.dart';

class AnimationPageRoute<T> extends MaterialPageRoute<T> {
  //滑动渐变
  Tween<Offset> sildeTween;
  Tween<double> fadeTween;

  AnimationPageRoute(
      {
        WidgetBuilder builder, 
        RouteSettings settings,
        bool maintainState: true,
        bool fullscreenDialog: false,
        this.sildeTween,
        this.fadeTween
      }) : super(
      builder: builder, 
      settings: settings, 
      maintainState: maintainState, 
      fullscreenDialog: fullscreenDialog);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, 
      Animation<double> secondaryAnimation, Widget child) {
    Widget widget = SlideTransition(
      position: __getSlideAnimation(animation),
      child: FadeTransition(
        opacity: _getFadeAnimation(animation),
        child: child,
      ),
    );
    
    return widget;
  }
  
  
  Animation<Offset> __getSlideAnimation(Animation<double> animation){
    if (sildeTween == null){
      sildeTween = new Tween<Offset>(
        begin: new Offset(0.0, 0.0),
        end: Offset.zero
      );
    }
    return sildeTween.animate(
      new CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)
    );
  }
  
  Animation<double> _getFadeAnimation(Animation<double> animation){
    if(fadeTween == null){
      fadeTween = new Tween<double>(
        begin: 1.0,
        end: 1.0
      );
    }
    
    return fadeTween.animate(
      new CurvedAnimation(parent: animation, curve: Curves.easeIn)
    );
  }
  
}