// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ApiActionModel extends Equatable {
  final String name;
  final String method;
  final String fullUrl;
  final Map<String, dynamic> body;

  const ApiActionModel({
    required this.name,
    required this.method,
    required this.fullUrl,
    required this.body,
  });

  @override
  List<Object?> get props => [
        name,
        method,
        fullUrl,
        body,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'method': method,
      'fullUrl': fullUrl,
      'body': body,
    };
  }

  factory ApiActionModel.fromMap(Map<String, dynamic> map) {
    return ApiActionModel(
        name: map['name'] as String,
        method: map['method'] as String,
        fullUrl: map['fullUrl'] as String,
        body: Map<String, dynamic>.from(
          (map['body'] as Map<String, dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ApiActionModel.fromJson(String source) =>
      ApiActionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
