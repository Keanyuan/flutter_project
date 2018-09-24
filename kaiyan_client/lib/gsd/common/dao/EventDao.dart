
import 'package:kaiyan_client/gsd/common/ab/provider/event/ReceivedEventDbProvider.dart';
import 'package:kaiyan_client/gsd/common/model/Event.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/net/Address.dart';
import 'package:kaiyan_client/gsd/common/net/Api.dart';
import 'package:kaiyan_client/gsd/common/redux/EventRedux.dart';
import 'package:kaiyan_client/gsd/common/redux/GSYState.dart';
import 'package:redux/redux.dart';
import 'dart:convert';

class EventDao {

  //获取用户事件
  static getEventReceived(Store<GSYState> store, {page = 1, bool needDb = false})async {
    User user = store.state.userInfo;
    if(user == null || user.login == null){
      return null;
    }

    ReceivedEventDbProvider provider = new ReceivedEventDbProvider();

    if(needDb){
      List<Event> dataList =  await provider.getEvents();
      if(dataList.length > 0){
        store.dispatch(new RefreshEventAction(dataList));
      }
    }

    String userName = user.login;

    //收到用户信息接口
    String url = Address.getEventReceived(userName) + Address.getPageParams("?", page);

    //get请求 不需要参数
    var res = await HttpManager.netFetch(url, null, null, null);

    if (res != null && res.result) {
      List<Event> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return null;
      }
      if(needDb) {
        await provider.insert(json.encode(data));
      }

      for (int i = 0; i < data.length; i++) {
        list.add(Event.fromJson(data[i]));
      }


      //如果是第一页 下拉属性
      if (page == 1) {
        store.dispatch(new RefreshEventAction(list));
      } else { //加载更多
        store.dispatch(new LoadMoreEventAction(list));
      }
      return list;
    } else {
      return null;
    }
  }



  static clearEvent(Store store) {
    store.state.eventList.clear();
    store.dispatch(new RefreshEventAction([]));
  }
}