import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_version/get_version.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/repos/ReadHistoryDbProvider.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/user/UserReposDbProvider.dart';
import 'package:kaiyan_client/gsd/common/ab/provider/user/UserStaredDbProvider.dart';
import 'package:kaiyan_client/gsd/common/config/Config.dart';
import 'package:kaiyan_client/gsd/common/dao/DataResult.dart';
import 'package:kaiyan_client/gsd/common/model/Release.dart';
import 'package:kaiyan_client/gsd/common/model/Repository.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
import 'package:kaiyan_client/gsd/common/net/Address.dart';
import 'package:kaiyan_client/gsd/common/net/Api.dart';
import 'package:kaiyan_client/gsd/common/utils/CommonUtils.dart';
import 'package:pub_semver/pub_semver.dart';

class ReposDao {

  /**
   * 检查更新
   */
  static getNewsVersion(context, showTip) async {
    //ios不检查更新
//    if(Platform.isIOS){
//      return;
//    }

    var res = await getRepositoryReleaseDao(
        'Keanyuan', 'flutter_project', 1, release: false, needHtml: false );
    if (res != null && res.result && res.data.lengtn > 0) {
      Release release = res.data[0];
      String versionName = release.name;
      if (versionName != null) {
        if (Config.DEBUG) {
          print( "versionName " + versionName );
        }
        var appVersion = await GetVersion.projectVersion;
        if (Config.DEBUG) {
          print( "appVersion " + appVersion );
        }

        Version versionNameNum = Version.parse( versionName );
        Version currentNum = Version.parse( appVersion );
        int result = versionNameNum.compareTo( currentNum );
        if (Config.DEBUG) {
          print(
              "versionNameNum " + versionNameNum.toString( ) + " currentNum " +
                  currentNum.toString( ) );
        }
        if (Config.DEBUG) {
          print( "newsHad " + result.toString( ) );
        }

        if (result > 0) {
          CommonUtils.showUpdateDialog(
              context, release.name + ": " + release.body );
        } else {
          if (showTip) {
            Fluttertoast.showToast( msg: CommonUtils
                .getLocale( context )
                .app_not_new_version );
          }
        }
      }
    } else {
      Fluttertoast.showToast( msg: CommonUtils
          .getLocale( context )
          .app_not_new_version );
    }
  }

  /**
   * 获取仓库的release列表
   */
  static getRepositoryReleaseDao(userName, reposName, page,
      {needHtml = true, release = true}) async {
    String url = "";

    if (release) {
      url = Address.getReposRelease( userName, reposName ) +
          Address.getPageParams( "?", page );
    } else {
      url = Address.getReposTag( userName, reposName ) +
          Address.getPageParams( "?", page );
    }


    var res = await HttpManager.netFetch(
        url,
        null,
        {
          "Accept": (needHtml
              ? 'application/vnd.github.html,application/vnd.github.VERSION.raw'
              : "")
        },
        null
    );
    if (res != null && res.result && res.data.length > 0) {
      List<Release> list = new List( );
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult( null, false );
      }
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add( Release.fromJson( data ) );
      }
      return new DataResult( list, true );
    } else {
      return new DataResult( null, false );
    }
  }

  /**
   * 获取阅读历史
   */
  static getHistoryDao(page) async {
    ReadHistoryDbProvider provider = new ReadHistoryDbProvider( );
    List<Repository> list = await provider.geData( page );
    if (list == null || list.length <= 0) {
      return new DataResult( null, false );
    }
    return new DataResult( list, true );
  }

  /*
  * 搜索仓库
  * q 搜索关键字
  * sort 分类排序beat match、most star等
  * order 倒序或正序
  * type 搜索类型 人或者仓库 null \ 'user',
  * */
  static searchRepositoryDao(q, language, sort, order, type, page, pageSize) async {
    if (language != null) {
      q = q + "%2Blanguage%3A$language";
    }
    String url = Address.search(q, sort, order, type, page, pageSize);
    var res = await HttpManager.netFetch(url, null, null, null);
    if (type == null) {
      if (res != null && res.result && res.data["items"] != null) {
        List<Repository> list = new List();
        var dataList = res.data["items"];
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(Repository.fromJson(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    } else {
      if (res != null && res.result && res.data["items"] != null) {
        List<User> list = new List();
        var data = res.data["items"];
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }
  }

  /**
   * 用户的仓库
   */
  static getUserRepositoryDao(userName, page, sort, {needDb = false}) async {
    UserReposDbProvider provider = new UserReposDbProvider();
    next() async {
      String url = Address.userRepos(userName, sort) + Address.getPageParams("&", page);
      var res = await HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result && res.data.length > 0) {
        List<Repository> list = new List();
        var dataList = res.data;
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(Repository.fromJson(data));
        }
        if (needDb) {
          provider.insert(userName, json.encode(dataList));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Repository> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }

  /**
   * 获取用户所有star
   */
  static getStarRepositoryDao(userName, page, sort, {needDb = false}) async {
    UserStaredDbProvider provider = new UserStaredDbProvider();
    next() async {
      String url = Address.userStar(userName, sort) + Address.getPageParams("&", page);
      var res = await HttpManager.netFetch(url, null, null, null);
      if (res != null && res.result && res.data.length > 0) {
        List<Repository> list = new List();
        var dataList = res.data;
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(Repository.fromJson(data));
        }
        if (needDb) {
          provider.insert(userName, json.encode(dataList));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Repository> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }


  /**
   * 用户的前100仓库
   */
  static getUserRepository100StatusDao(userName) async {
    String url = Address.userRepos(userName, 'pushed') + "&page=1&per_page=100";
    var res = await HttpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      int stared = 0;
      for (int i = 0; i < res.data.length; i++) {
        var data = res.data[i];
        stared += data["watchers_count"];
      }
      return new DataResult(stared, true);
    }
    return new DataResult(null, false);
  }

}

