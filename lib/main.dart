import 'package:flutter/material.dart';
import 'services/providers/user/user_bloc_provider.dart';
import 'services/blocs/user/user_bloc.dart';
import 'widgets/user_list.dart';
import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserBloc bloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserBlocProvider(
        bloc: bloc,
        child: MyHomePage(title: 'Flutter Bloc Demo Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _firstTimeLoad = true;

  @override
  Widget build(BuildContext context) {
    UserBloc bloc = UserBlocProvider.of(context).bloc;

    if (_firstTimeLoad) {
      bloc.fetchUser(page: 1);
      _firstTimeLoad = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UserBlocState>(
        initialData: bloc.getCurrentState(),
        stream: bloc.userStream,
        builder: _buildBody,
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
    print(snapshot.data.results.users);
    return Stack(
      children: <Widget>[
        UserList(
            users: snapshot.data.results.users,
            refreshCallback: _handleRefresh,
            loadMoreCallback: _handleLoadMore),
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
    UserBloc bloc = UserBlocProvider.of(context).bloc;
    bloc.fetchUser();
    await bloc.userStream.first;
    return null;
  }

  Future<Null> _handleLoadMore() async {
    UserBloc bloc = UserBlocProvider.of(context).bloc;
    bloc.loadMore();
    await bloc.userStream.first;
    return null;
  }
}
