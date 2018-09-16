import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/model/TrendingRepoModel.dart';
import 'package:redux/redux.dart';

final ThendReducer = combineReducers<List<TrendingRepoModel>>([
  TypedReducer<List<TrendingRepoModel>, RefreshTrendAction>(_refresh),
]);

List<TrendingRepoModel> _refresh(List<TrendingRepoModel> list, action){
  list.clear();
  if (action.list == null){
    return list;
  }
  list.addAll(action.list);
  return list;
}


class RefreshTrendAction {
  final List<TrendingRepoModel> list;

  RefreshTrendAction(this.list);

}