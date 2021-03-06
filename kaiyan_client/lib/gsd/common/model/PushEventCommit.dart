import 'package:json_annotation/json_annotation.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';

part 'PushEventCommit.g.dart';

@JsonSerializable()
class PushEventCommit extends Object with _$PushEventCommitSerializerMixin{
  String sha;
  User author;
  String message;
  bool distinct;
  String url;

  PushEventCommit(this.sha, this.author, this.message, this.distinct, this.url);

  factory PushEventCommit.fromJson(Map<String, dynamic> json) => _$PushEventCommitFromJson(json);

}