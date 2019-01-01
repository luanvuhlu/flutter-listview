import 'user.dart';
import 'info.dart';

class UserListResult {
  List<User> users;
  Info info;

  UserListResult({this.users, this.info});
  UserListResult.empty() {
    this.users = [];
  }
  UserListResult.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      users = new List<User>();
      json['results'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['results'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}
