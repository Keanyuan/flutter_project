import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/repos/IssueCommentDbProvider.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/repos/IssueDetailDbProvider.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/repos/RepositoryIssueDbProvider.dart';
import 'package:kaiyan_client/gsd/common/dao/DataResult.dart';
import 'package:kaiyan_client/gsd/common/model/Issue.dart';
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

  /**
   * 获取仓库issue
   * @param page
   * @param userName
   * @param repository
   * @param state issue状态
   * @param sort 排序类型 created updated等
   * @param direction 正序或者倒序
   */
  static getRepositoryIssueDao(userName, repository, state, {sort, direction, page = 0, needDb = false}) async {
    String fullName = userName + "/" + repository;
    String dbState = state ?? "*";
    RepositoryIssueDbProvider provider = new RepositoryIssueDbProvider();

    next() async {
      String url = Address.getReposIssue(userName, repository, state, sort, direction) + Address.getPageParams("&", page);
      var res = await HttpManager.netFetch(url, null, {"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}, null);
      if (res != null && res.result) {
        List<Issue> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Issue.fromJson(data[i]));
        }
        if (needDb) {
          //插入数据
          provider.insert(fullName, dbState, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Issue> list = await provider.getData(fullName, dbState);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }


  /**
   * 搜索仓库issue
   * @param q 搜索关键字
   * @param name 用户名
   * @param reposName 仓库名
   * @param page
   * @param state 问题状态，all open closed
   */
  static searchRepositoryIssue(q, name, reposName, state, {page = 1}) async {
    String qu;
    if (state == null || state == 'all') {
      qu = q + "+repo%3A${name}%2F${reposName}";
    } else {
      qu = q + "+repo%3A${name}%2F${reposName}+state%3A${state}";
    }
    String url = Address.repositoryIssueSearch(qu) + Address.getPageParams("&", page);
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Issue> list = new List();
      var data = res.data["items"];
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Issue.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }


  /**
   * issue的详请列表
   */
  static getIssueCommentDao(userName, repository, number, {page: 0, needDb = false}) async {
    String fullName = userName + "/" + repository;
    IssueCommentDbProvider provider = new IssueCommentDbProvider();

    next() async {
      String url = Address.getIssueComment(userName, repository, number) + Address.getPageParams("?", page);
      //{"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}
      var res = await HttpManager.netFetch(url, null, {"Accept": 'application/vnd.github.VERSION.raw'}, null);
      if (res != null && res.result) {
        List<Issue> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        if (needDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Issue.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Issue> list = await provider.getData(fullName, number);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }

  /**
   * issue的详请
   */
  static getIssueInfoDao(userName, repository, number, {needDb = true}) async {
    String fullName = userName + "/" + repository;

    IssueDetailDbProvider provider = new IssueDetailDbProvider();

    next() async {
      String url = Address.getIssueInfo(userName, repository, number);
      //{"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}
      var res = await HttpManager.netFetch(url, null, {"Accept": 'application/vnd.github.VERSION.raw'}, null);
      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        return new DataResult(Issue.fromJson(res.data), true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      Issue issue = await provider.getRepository(fullName, number);
      if (issue == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(issue, true, next: next());
      return dataResult;
    }
    return await next();
  }


  /**
   * 编辑issue
   */
  static editIssueDao(userName, repository, number, issue) async {
    String url = Address.editIssue(userName, repository, number);
    var res = await HttpManager.netFetch(url, issue, {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: 'PATCH'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 锁定issue
   */
  static lockIssueDao(userName, repository, number, locked) async {
    String url = Address.lockIssue(userName, repository, number);
    var res = await HttpManager.netFetch(
        url, null, {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: locked ? "DELETE" : 'PUT', contentType: ContentType.text),
        noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 编辑issue回复
   */
  static editCommentDao(userName, repository, number, commentId, comment) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await HttpManager.netFetch(url, comment, {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: 'PATCH'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 删除issue回复
   */
  static deleteCommentDao(userName, repository, number, commentId) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await HttpManager.netFetch(url, null, null, new Options(method: 'DELETE'), noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 增加issue的回复
   */
  static addIssueCommentDao(userName, repository, number, comment) async {
    String url = Address.addIssueComment(userName, repository, number);
    var res = await HttpManager.netFetch(url, {"body": comment}, {"Accept": 'application/vnd.github.VERSION.full+json'}, new Options(method: 'POST'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }
}