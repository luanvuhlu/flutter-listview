import 'package:flutter/material.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/blocs/user/user_bloc_provider.dart';
import '../widgets/user_list.dart';
import '../pages/camera_page.dart';
import '../services/blocs/user/users_state.dart';

class UserListsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListsPageState();
  }
}

class _UserListsPageState extends State<UserListsPage> {
  bool _firstTimeLoad = true;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserBlocProvider.of(context);
    if (_firstTimeLoad) {
      bloc.fetch(page: 1);
      _firstTimeLoad = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('User Lists'),
        actions: <Widget>[
          Center(
            child: StreamBuilder(
              stream: bloc.itemCount,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('${snapshot.data} girls');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30),
          ),
          Center(
            child: StreamBuilder(
              stream: bloc.favoritesCount,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('${snapshot.data} favorites');
              },
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) =>
                      CameraPage()));
            },
            child: Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder<UserBlocState>(
        initialData: bloc.getCurrentState(),
        stream: bloc.userStream,
        builder: _buildBody,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 500));
            },
            child: Icon(Icons.arrow_drop_up),
          ),
          // FloatingActionButton(
          //   onPressed: () {
          //     _scrollController.animateTo(
          //         _scrollController.position.maxScrollExtent,
          //         curve: Curves.linear,
          //         duration: Duration(milliseconds: 500));
          //   },
          //   child: Icon(Icons.arrow_drop_down),
          // )
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<UserBlocState> snapshot) {
    if (snapshot.data.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent -
                    MediaQuery.of(context).size.height) {
              _handleLoadMore();
            }
          },
          child: UserList(
              scrollController: _scrollController,
              users: snapshot.data.results.users,
              refreshCallback: _handleRefresh,
              loadMoreCallback: _handleLoadMore),
        ),
        _loader(snapshot)
      ],
    );
  }

  Widget _loader(AsyncSnapshot<UserBlocState> snapshot) {
    return snapshot.data.loadingMore
        ? new Align(
            child: new Container(
              width: 70.0,
              height: 70.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(child: new CircularProgressIndicator())),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : new SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Future<Null> _handleRefresh() async {
    UserBloc bloc = UserBlocProvider.of(context);
    bloc.fetch();
    await bloc.userStream.first;
    return null;
  }

  Future<Null> _handleLoadMore() async {
    UserBloc bloc = UserBlocProvider.of(context);
    bloc.loadMore();
    await bloc.userStream.first;
    return null;
  }
}
