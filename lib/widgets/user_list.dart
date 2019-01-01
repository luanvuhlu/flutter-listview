import 'package:flutter/material.dart';
import '../models/user/user.dart';
import '../pages/user_detail_page.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/blocs/user/individual_bloc.dart';
import '../services/blocs/user/user_bloc_provider.dart';
import 'dart:async';

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
    UserBloc bloc = UserBlocProvider.of(context);

    return RefreshIndicator(
      onRefresh: refreshCallback,
      child: _usersListView(bloc),
    );
  }

  Widget _buildItem(BuildContext context, int index, UserBloc bloc) {
    // if (index == users.length - 10) {
    //   loadMoreCallback();
    // }

    User user = users[index];
    UserIndividualBloc individualBloc = UserIndividualBloc(user);
    bloc.favoritedUsers.listen(individualBloc.favoritedUsers.add);
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
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(4293980400)
                  : Colors.greenAccent),
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
                onTap: () {
                  bloc.favoriteChange.add(user);
                },
                child: StreamBuilder(
                  stream: individualBloc.isFavorited,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Icon(
                      snapshot.hasData && snapshot.data
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
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

  ListView _usersListView(UserBloc bloc) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, index, bloc);
      },
      itemCount: users.length,
    );
  }
}
