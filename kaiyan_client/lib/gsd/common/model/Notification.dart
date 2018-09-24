import 'package:json_annotation/json_annotation.dart';
import 'package:kaiyan_client/gsd/common/model/NotificationSubject.dart';
import 'package:kaiyan_client/gsd/common/model/Repository.dart';


part 'Notification.g.dart';

@JsonSerializable()
class Notification extends Object with _$NotificationSerializerMixin {
  String id;
  bool unread;
  String reason;
  @JsonKey(name: "updated_at")
  DateTime updateAt;
  @JsonKey(name: "last_read_at")
  DateTime lastReadAt;
  Repository repository;
  NotificationSubject subject;

  Notification(this.id, this.unread, this.reason, this.updateAt, this.lastReadAt, this.repository, this.subject);

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
}