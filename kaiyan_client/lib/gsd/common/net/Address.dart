

import 'package:kaiyan_client/gsd/common/config/Config.dart';

///地址数据
class Address {

  static const String host = "https://api.github.com/";

  static const String hostWeb = "https://github.com/";

  static const String downloadUrl = 'https://www.pgyer.com/GSYGithubApp';

  static const String graphicHost = 'https://ghchart.rshah.org/';

  static const String updateUrl = 'https://www.pgyer.com/vj2B';


  ///获取授权  post
  static getAuthorization() {
    return "${host}authorizations";
  }

  ///我的用户信息 GET
  static getMyUserInfo() {
    return "${host}user";
  }

  ///用户信息 get
  static getUserInfo(userName) {
    return "${host}users/$userName";
  }
  ///用户的star get
  static userStar(userName, sort) {
    sort ??= 'updated';
    return "${host}users/$userName/starred?sort=$sort";
  }

  ///创建issue post
  static createIssue(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/issues";
  }


  static getReposRelease(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/releases";
  }

  ///仓Tag get
  static getReposTag(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/tags";
  }

  ///处理分页参数
  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page=$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }


  ///用户收到的事件信息 get
  static getEventReceived(userName) {
    return "${host}users/$userName/received_events";
  }

  ///搜索 get
  static search(q, sort, order, type, page, [pageSize = Config.PAGE_SIZE]) {
    //根据用户查询
    if (type == 'user') {
      return "${host}search/users?q=$q&page=$page&per_page=$pageSize";
    }
    sort ??= "best%20match";
    order ??= "desc";
    page ??= 1;
    pageSize ??= Config.PAGE_SIZE;
    //根据仓库名
    return "${host}search/repositories?q=$q&sort=$sort&order=$order&page=$page&per_page=$pageSize";
  }

  ///获取用户组织
  static getUserOrgs(userName) {
    return "${host}users/$userName/orgs";
  }

  ///用户的仓库 get
  static userRepos(userName, sort) {
    sort ??= 'pushed';
    return "${host}users/$userName/repos?sort=$sort";
  }


  ///用户关注 get
  static getUserFollow(userName) {
    return "${host}users/$userName/following";
  }

  ///用户的关注者 get
  static getUserFollower(userName) {
    return "${host}users/$userName/followers";
  }

  ///通知 get
  static getNotifation(all, participating) {
    if (all == null && participating == null) {
      return "${host}notifications";
    }
    all ??= false;
    participating ??= false;
    return "${host}notifications?all=$all&participating=$participating";
  }

  ///获取组织成员
  static getMember(orgs) {
    return "${host}orgs/$orgs/members";
  }

  ///用户相关的事件信息 get
  static getEvent(userName) {
    return "${host}users/$userName/events";
  }
}