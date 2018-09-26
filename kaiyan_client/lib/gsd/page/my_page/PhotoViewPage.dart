import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:kaiyan_client/gsd/page/tool_page/GSYTitleBar.dart';
import 'package:kaiyan_client/gsd/widget/GSYCommonOptionWidget.dart';
import 'package:share/share.dart';
import 'package:photo_view/photo_view.dart';
/**
 * 图片预览
 */
class PhotoViewPage extends StatelessWidget {
  final String url;

  PhotoViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    OptionControl optionControl = new OptionControl();
    optionControl.url = url;
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text("头像"),),
        actions: <Widget>[
          new GSYCommonOptionWidget(optionControl, otherList: [
            new GSYOptionModel(CommonUtils.getLocale(context).option_share, CommonUtils.getLocale(context).option_share, (model){
              //分享
              Share.share(CommonUtils.getLocale(context).option_share_title + url ?? "");
            })
          ],),
          new Container(width: 20.0,)
        ],
      ),
      body: new Container(
        color: Colors.black,
        child: new GestureDetector(
          child: new PhotoView(
            imageProvider: new NetworkImage(url ?? GSYICons.DEFAULT_REMOTE_PIC),
            loadingChild: Container(
              child: new Stack(
                children: <Widget>[
                  new Center(child: new Image.asset(GSYICons.DEFAULT_IMAGE, height: 150.0, width: 150.0)),//placeholder
                  new Center(child: new SpinKitFoldingCube(color: Colors.white30, size: 60.0)), //加载样式
                ],
              ),
            ),
          ),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

}
