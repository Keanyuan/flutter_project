import 'package:json_annotation/json_annotation.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';


part 'IssueEvent.g.dart';

@JsonSerializable()
class IssueEvent extends Object with _$IssueEventSerializerMixin{
  int id;
  User user;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "author_association")
  String authorAssociation;
  String body;
  @JsonKey(name: "body_html")
  String bodyHtml;
  @JsonKey(name: "event")
  String type;
  @JsonKey(name: "html_url")
  String htmlUrl;

  IssueEvent(this.id, this.user, this.createdAt, this.updatedAt,
      this.authorAssociation, this.body, this.bodyHtml, this.type,
      this.htmlUrl);
  factory IssueEvent.fromJson(Map<String, dynamic> json) => _$IssueEventFromJson(json);

}


