// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationSubject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSubject _$NotificationSubjectFromJson(Map<String, dynamic> json) {
  return new NotificationSubject(
      json['title'] as String, json['url'] as String, json['type'] as String);
}

abstract class _$NotificationSubjectSerializerMixin {
  String get title;
  String get url;
  String get type;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'title': title, 'url': url, 'type': type};
}
