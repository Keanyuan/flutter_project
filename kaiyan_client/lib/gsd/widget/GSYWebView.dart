import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:kaiyan_client/gsd/widget/GSYCommonOptionWidget.dart';


/**
 *  webview
 */
class GSYWebView extends StatelessWidget {
  final String url;
  final String title;
  final OptionControl optionControl = new OptionControl();

  GSYWebView(this.url, this.title);

  _renderTitle() {
    if (url == null || url.length == 0) {
      return new Text(title);
    }
    optionControl.url = url;
    return new Row(children: [
      //标题
      new Expanded(child: new Container()),
      //更多
      GSYCommonOptionWidget(optionControl),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      withJavascript: true,
      url: url,
      scrollBar:true,
      withLocalUrl: true,
      appBar: new AppBar(
        title: _renderTitle(),
      ),
    );
  }
}