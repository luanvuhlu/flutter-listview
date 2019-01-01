import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../../https/user_api.dart';
import 'users_state.dart';
import '../../../models/user/user_list_results.dart';
import '../../../models/user/user.dart';

class UserBloc {
  UserApiClient _apiClient;
  UserBlocState _currentState;

  final _userController = StreamController<UserBlocState>.broadcast();
  Stream<UserBlocState> get userStream => _userController.stream;

  Stream<int> get itemCount => _itemCountController.stream;
  final _itemCountController = BehaviorSubject<int>();

  Stream<int> get favoritesCount => _favoritesCountSubject.stream;
  final _favoritesCountSubject = BehaviorSubject<int>();

  final _favoritedUsers = List<User>();
  final _favoritedUsersSubject = BehaviorSubject<List<User>>(seedValue: []);
  ValueObservable<List<User>> get favoritedUsers =>
      _favoritedUsersSubject.stream;

  Sink<User> get favoriteChange => _favoritedUsersChangeController.sink;
  final _favoritedUsersChangeController = StreamController<User>();

  // StreamSubscription<UserListResult> _fetchUsersSub;

  UserBloc() {
    _currentState = UserBlocState.empty();
    _apiClient = new UserApiClient();
    _userController.stream.listen(_handle);
    _favoritedUsersChangeController.stream.listen(_changeFavorite);
    _favoritedUsersSubject.stream.listen((List<User> user){
      _favoritesCountSubject.add(user.length);
    });
  }

  _changeFavorite(User user) {
    if (_favoritedUsers.any((_user) => _user == user)) {
      _favoritedUsers.remove(user);
    } else {
      _favoritedUsers.add(user);
    }
    _favoritedUsersSubject.add(_favoritedUsers);
    _favoritesCountSubject.add(_favoritedUsers.length);
  }

  getCurrentState() => _currentState;

  void _handle(UserBlocState state) {
    _itemCountController.add(state.results.users.length);
  }

  void fetch({int page = 1}) {
    // _fetchUsersSub?.cancel();
    _currentState.loading = true;
    _userController.add(_currentState);
    _favoritedUsers.clear();
    _favoritedUsersSubject.add(_favoritedUsers);
    _apiClient.getList(page, 20).asStream().listen((dynamic results) {
      if (results is UserListResult) {
        _currentState.results = results;
      }
      _currentState.loading = false;
      _userController.add(_currentState);
    });
  }

  loadMore({int page}) {
    if (_currentState.loadingMore) {
      return;
    }
    // _fetchUsersSub?.cancel();
    _currentState.loadingMore = true;
    _userController.add(_currentState);
    int newPage = page == null
        ? ++_currentState.currentPage
        : (_currentState.currentPage = page);
    _apiClient.getList(newPage, 20).asStream().listen((dynamic results) {
      if (results is UserListResult) {
        _currentState.results.info = results.info;
        _currentState.results.users.addAll(results.users);
      }
      _currentState.loadingMore = false;
      _userController.add(_currentState);
    });
  }

  void dispose() {
    _favoritedUsersChangeController.close();
    _favoritesCountSubject.close();
    _favoritedUsersSubject.close();
  }
}
