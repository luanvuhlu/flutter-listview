import 'package:cloud_firestore/cloud_firestore.dart';
import './user.dart';

class Comment {
  final String content;
  User user;
  DocumentReference reference;

  Comment({this.content, this.user});
  Comment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        assert(map['user'] != null),
        content = map['content'],
        user = User.fromMap(map['user']);
  Comment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      '${this.user == null ? "null" : this.user.email} - $content';

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['user'] = user.toMap();
    return data;
  }
}
