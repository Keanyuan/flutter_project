

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
}