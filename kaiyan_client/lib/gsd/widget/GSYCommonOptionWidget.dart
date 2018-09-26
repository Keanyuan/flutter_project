import 'package:kaiyan_client/gsd/common/style/GSYColors.dart';
import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:share/share.dart';

/**
 * 更多信息
 */
class GSYCommonOptionWidget extends StatelessWidget {
  final List<GSYOptionModel> otherList;

  final OptionControl control;

  GSYCommonOptionWidget(this.control, {this.otherList});

  //构建更多列表
  _renderHeaderPopItemChild(List<GSYOptionModel> data){
    List<PopupMenuEntry<GSYOptionModel>> list = new List();
    for(GSYOptionModel item in data){
      list.add(PopupMenuItem<GSYOptionModel>(
        child: new Text(item.name),
        value: item,));
    }
    return list;
  }

  //构建头部更多按钮
  _renderHeaderPopItem(List<GSYOptionModel> list){
    return new PopupMenuButton<GSYOptionModel>(
      child: new Icon(GSYICons.MORE),
      onSelected: (model){
        model.selected(model);
      },
      itemBuilder: (BuildContext context){
        return _renderHeaderPopItemChild(list);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    List<GSYOptionModel> list = [
      new GSYOptionModel(CommonUtils.getLocale(context).option_web, CommonUtils.getLocale(context).option_web, (model){
        //浏览器打开
        CommonUtils.launchOutURL(control.url, context);
      }),
      new GSYOptionModel(CommonUtils.getLocale(context).option_copy, CommonUtils.getLocale(context).option_copy, (model){
        //复制链接
        CommonUtils.copy(control.url ?? "", context);
      }),
      new GSYOptionModel(CommonUtils.getLocale(context).option_share, CommonUtils.getLocale(context).option_share, (model){
        //分享
        Share.share(CommonUtils.getLocale(context).option_share_title + control.url ?? "");
      })
    ];

    if(otherList != null && otherList.length > 0){
      list.addAll(otherList);
    }

    return _renderHeaderPopItem(list);

  }
}

class OptionControl {
  String url = GSYConstant.app_default_share_url;
}

class GSYOptionModel {
  final String name;
  final String value;
  final PopupMenuItemSelected<GSYOptionModel> selected;

  GSYOptionModel(this.name, this.value, this.selected);
}