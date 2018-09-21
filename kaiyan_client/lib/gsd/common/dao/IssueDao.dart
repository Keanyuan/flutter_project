import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/dao/DataResult.dart';
import 'package:kaiyan_client/gsd/common/net/Address.dart';
import 'package:kaiyan_client/gsd/common/net/Api.dart';

/**
 * Issue 问题相关
 */
class IssueDao {

  /**
   * 创建issue
   */
  static createIssueDao(userName, repository, issue) async {
    String url = Address.createIssue(userName, repository);
    var res = await HttpManager.netFetch(url, issue,
        {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: 'POST'));
    if(res != null && res.result){
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }
}