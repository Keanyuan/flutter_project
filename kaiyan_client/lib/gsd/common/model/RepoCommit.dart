import 'package:json_annotation/json_annotation.dart';
import 'package:kaiyan_client/gsd/common/model/CommitGitInfo.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';

part 'RepoCommit.g.dart';

@JsonSerializable()
class RepoCommit extends Object with _$RepoCommitSerializerMixin {
  String sha;
  String url;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "comments_url")
  String commentsUrl;

  CommitGitInfo commit;
  User author;
  User committer;
  List<RepoCommit> parents;

  RepoCommit(
      this.sha,
      this.url,
      this.htmlUrl,
      this.commentsUrl,
      this.commit,
      this.author,
      this.committer,
      this.parents,
      );

  factory RepoCommit.fromJson(Map<String, dynamic> json) => _$RepoCommitFromJson(json);
}