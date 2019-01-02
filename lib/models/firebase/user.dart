import 'package:flutter/material.dart';

class User {
  final String email;

  User({@required this.email});
  User.fromMap(Map<dynamic, dynamic> map)
      : assert(map['email'] != null),
        email = map['email'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }

  @override
  String toString() => this.email;
}
