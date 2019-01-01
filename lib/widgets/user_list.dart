import 'package:flutter/material.dart';
import '../models/user/user.dart';
import '../pages/user_detail_page.dart';

class UserList extends StatelessWidget {
  final ScrollController scrollController;
  final List<User> users;
  final RefreshCallback refreshCallback;
  final RefreshCallback loadMoreCallback;

  UserList(
      {@required this.scrollController,
      @required this.users,
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
    if (index == users.length - 10) {
      loadMoreCallback();
    }
    User user = users[index];
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => UserDetailPage(user)));
        },
        child: Container(
          decoration: BoxDecoration(color: Color(4293980400)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    child: Hero(
                      tag: 'userAvatar${user.email}',
                      child: Image.network(
                        user.picture.thumbnail,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                // chil`d: Container(
                // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(user.name.title),
                    Text(user.name.first),
                    Text(user.name.last),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(user.favorite ? Icons.favorite : Icons.favorite_border),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView _usersListView() {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: _buildItem,
      itemCount: users.length,
    );
  }
}
