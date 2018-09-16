import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/model/Event.dart';
import 'package:redux/redux.dart';



final EventReducer = combineReducers<List<Event>>([
  TypedReducer<List<Event>, RefreshEventAction>(_refresh),
  TypedReducer<List<Event>, LoadMoreEventAction>(_refresh)

]);

List<Event> _refresh(List<Event> list, action){

  list.clear();
  if (action.list == null){
    return list;
  }
  list.addAll(action.list);
  return list;
}

class RefreshEventAction {
  final List<Event>list;
  RefreshEventAction(this.list);
}

class LoadMoreEventAction{
  final List<Event>list;
  LoadMoreEventAction(this.list);
}


