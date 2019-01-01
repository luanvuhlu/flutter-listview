import '../../../models/user/user_list_results.dart';

class UserBlocState {
  bool loading;
  bool loadingMore;
  UserListResult results;
  int currentPage = 1;

  UserBlocState({this.loading = false, this.loadingMore = false, this.results});

  UserBlocState.empty() {
    loadingMore = false;
    loading = false;
    results = UserListResult.empty();
  }
}