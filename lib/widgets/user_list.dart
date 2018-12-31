import 'package:flutter/material.dart';
import '../models/user/user.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final RefreshCallback refreshCallback;
  final RefreshCallback loadMoreCallback;

  UserList(
      {@required this.users,
      @required this.refreshCallback,
      @required this.loadMoreCallback});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshCallback,
      child: _usersListView(),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == users.length - 1) {
      loadMoreCallback();
    }
    User user = users[index];
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                child: Image.network(
                  user.picture.thumbnail,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.name.title),
              Text(user.name.first),
              Text(user.name.last),
            ],
          ),
        ],
      ),
    );
  }

  ListView _usersListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: _buildItem,
      itemCount: users.length,
    );
  }
  
}
