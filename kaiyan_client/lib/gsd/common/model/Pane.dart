import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

class Pane {
  final String name;
  final String email;

  Pane(this.name, this.email);

  Pane.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
      };
}