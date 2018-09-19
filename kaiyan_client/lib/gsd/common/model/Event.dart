import 'package:json_annotation/json_annotation.dart';
import 'package:kaiyan_client/gsd/common/model/EventPayload.dart';
import 'package:kaiyan_client/gsd/common/model/Repository.dart';
import 'package:kaiyan_client/gsd/common/model/User.dart';
part 'Event.g.dart';

@JsonSerializable()
class Event extends Object with _$EventSerializerMixin{
  String id;
  String type;
  User actor;
  Repository repo;
  User org;
  EventPayload payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  Event(this.id, this.type, this.actor, this.repo, this.org, this.payload,
      this.isPublic, this.createdAt);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);


}