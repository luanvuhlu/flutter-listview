import 'dart:async';
import '../../https/user_api.dart';
// import '../../../models/user/user.dart';
import '../../../models/user/user_list_results.dart';

class UserBloc {
  final UserApiClient _apiClient = new UserApiClient();
  UserBlocState _currentState;
  
  StreamSubscription<UserListResult> _fetchUsersSub;

  final StreamController<UserBlocState> _userController =
      StreamController<UserBlocState>.broadcast();
  Stream<UserBlocState> get userStream => _userController.stream;

  UserBloc() {
    _currentState = UserBlocState.empty();
  }

  UserBlocState getCurrentState() {
    return _currentState;
  }

  void fetchUser({int page = 1}) {
    _fetchUsersSub?.cancel();
    _currentState.loading = true;
    _userController.add(_currentState);

    _apiClient.getList(page, 10).asStream().listen((dynamic results) {
      if (results is UserListResult) {
        _currentState.results = results;
      }
      _currentState.loading = false;
      _userController.add(_currentState);
    });
  }

  loadMore({int page}) {
    _fetchUsersSub?.cancel();
    _currentState.loadingMore = true;
    _userController.add(_currentState);
    int newPage = page == null
        ? ++_currentState.currentPage
        : (_currentState.currentPage = page);
    _apiClient.getList(newPage, 10).asStream().listen((dynamic results) {
      if (results is UserListResult) {
        _currentState.results.info = results.info;
        _currentState.results.users.addAll(results.users);
      }
      _currentState.loadingMore = false;
      _userController.add(_currentState);
    });
  }
}

class UserBlocState {
  bool loading;
  bool loadingMore;
  UserListResult results;
  int currentPage = 1;

  UserBlocState({this.loading = false, this.loadingMore = false, this.results});

  UserBlocState.empty() {
    loadingMore = false;
    loading = false;
    results = null;
  }
}
