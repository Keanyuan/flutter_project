import 'package:json_annotation/json_annotation.dart';

part 'TrendingRepoModel.g.dart';

@JsonSerializable()
class TrendingRepoModel extends Object with _$TrendingRepoModelSerializerMixin{

  String fullName;
  String url;

  String description;
  String language;
  String meta;
  List<String> contributors;
  String contributorsUrl;

  String starCount;
  String forkCount;
  String name;

  String reposName;

  TrendingRepoModel(this.fullName, this.url, this.description, this.language,
      this.meta, this.contributors, this.contributorsUrl, this.starCount,
      this.forkCount, this.name, this.reposName);

  factory TrendingRepoModel.fromJson(Map<String, dynamic> json) => _$TrendingRepoModelFromJson(json);
  TrendingRepoModel.empty();

}