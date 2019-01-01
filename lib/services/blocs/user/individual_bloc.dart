import 'package:rxdart/rxdart.dart';
import 'users_state.dart';
import 'dart:async';
import '../../../models/user/user.dart';

class UserIndividualBloc {
  final _favoritedUsersController = StreamController<List<User>>();
  // final _favoritedChangeController = StreamController<User>();
  final _isFavoritedSubject = BehaviorSubject<bool>(seedValue: false);
  ValueObservable<bool> get isFavorited => _isFavoritedSubject.stream;
  Sink<List<User>> get favoritedUsers => _favoritedUsersController.sink;

  UserIndividualBloc(User user) {
    _favoritedUsersController.stream
        .map((users) => users.any((_user) => _user == user))
        .listen((isFavorited) => _isFavoritedSubject.add(isFavorited));
  }

  void dispose() {
    _favoritedUsersController.close();
    _isFavoritedSubject.close();
  }
}
