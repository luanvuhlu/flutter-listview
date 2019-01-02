import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/firebase/comment.dart';
import '../../../models/firebase/user.dart';
import 'package:flutter/material.dart';
import 'validators.dart';

class CommentBloc extends Validators {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('comment');
  final User user;
  final _commentController = StreamController<List<Comment>>();

  final _contentController = BehaviorSubject<String>();
  Stream<String> get content =>
      _contentController.stream.transform(validateContent);
  final _submitValidController = BehaviorSubject<bool>(seedValue: true);
  Stream<bool> get submitValid => Observable.combineLatest2(
      _submitValidController.stream,
      content.map((_) => true),
      (bool a, bool b) => a && b);
  Function(String) get changeContent => _contentController.sink.add;

  final _addingSubject = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get adding => _addingSubject.stream;

  Future<void> addComment() async {
    _submitValidController.add(false);
    _addingSubject.add(true);
    final contentValue = _contentController.value;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc =
          await tx.get(_collectionReference.document());
      final Comment newItem = new Comment(content: contentValue, user: user);
      final Map<String, dynamic> data = newItem.toMap();
      await tx.set(newDoc.reference, data);
      return data;
    };
    return Firestore.instance.runTransaction(createTransaction)
        // .then((map) => Comment.fromMap(map))
        .then((comment) {
      _contentController.add('');
      _submitValidController.add(true);
      _addingSubject.add(false);
    }).catchError((e) => _contentController.sink
            .addError("Add comment error: ${e.toString()}"));
  }

  CommentBloc({@required this.user});

  Stream<List<Comment>> commentsStream() {
    return _collectionReference
        .where('user.email', isEqualTo: user.email)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.documents
            .map((DocumentSnapshot doc) => Comment.fromSnapshot(doc))
            .toList());
  }

  void dispose() {
    _commentController.close();
    _contentController.close();
  }
}
