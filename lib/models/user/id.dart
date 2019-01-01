import 'package:quiver/core.dart';

class Id {
  String name;
  String value;

  Id({this.name, this.value});
  Id.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }

  bool operator ==(o) => o is Id && name == o.name && value == o.value;
  int get hashCode => hash2(name.hashCode, value.hashCode);

  @override
  String toString() {
    return '$name - $value';
  }
}
