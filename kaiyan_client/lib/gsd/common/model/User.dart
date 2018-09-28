import 'package:json_annotation/json_annotation.dart';


///关联文件、允许User访问 User.g.dart 中的私有方法
///User.g.dart 是通过命令生成的文件。名称为 xx.g.dart，其中 xx 为当前 dart 文件名称
///User.g.dart中创建了抽象类_$UserSerializerMixin，实现了_$TemplateFromJson方法
part 'User.g.dart';

///标志class需要实现json序列化功能
@JsonSerializable()
class User  extends Object with _$UserSerializerMixin {
  ///'xx.g.dart'文件中，默认会根据当前类名如 AA 生成 _$AASerializerMixin

  ///通过JsonKey重新定义参数名
  /// @JsonKey(name: "push_id")
  /// int pushId;

  String login;
  int id;
  String node_id;
  String avatar_url;
  String gravatar_id;
  String url;
  String html_url;
  String followers_url;
  String following_url;
  String gists_url;
  String starred_url;
  String subscriptions_url;
  String organizations_url;
  String repos_url;
  String events_url;
  String received_events_url;
  String type;
  bool site_admin;
  String name;
  String company;
  String blog;
  String location;
  String email;
  String starred;
  String bio;
  int public_repos;
  int public_gists;
  int followers;
  int following;
  DateTime created_at;
  DateTime updated_at;
  int private_gists;
  int total_private_repos;
  int owned_private_repos;
  int disk_usage;
  int collaborators;
  bool two_factor_authentication;

  User(this.login, this.id, this.node_id, this.avatar_url, this.gravatar_id,
      this.url, this.html_url, this.followers_url, this.following_url,
      this.gists_url, this.starred_url, this.subscriptions_url,
      this.organizations_url, this.repos_url, this.events_url,
      this.received_events_url, this.type, this.site_admin, this.name,
      this.company, this.blog, this.location, this.email, this.starred,
      this.bio, this.public_repos, this.public_gists, this.followers,
      this.following, this.created_at, this.updated_at, this.private_gists,
      this.total_private_repos, this.owned_private_repos, this.disk_usage,
      this.collaborators, this.two_factor_authentication);


  ///'xx.g.dart'文件中，默认会根据当前类名如 AA 生成 _$AAeFromJson方法
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  User.empty();
}