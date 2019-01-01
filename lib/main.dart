import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'services/providers/user/user_bloc_provider.dart';
import 'services/blocs/user/user_bloc.dart';
import 'pages/user_list_page.dart';
import 'pages/user_detail_page.dart';

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
      // home: UserBlocProvider(
      //   bloc: bloc,
      //   child: UserListsPage(),
      // ),
      routes: {
        '/': (BuildContext context) =>
            UserBlocProvider(bloc: bloc, child: UserListsPage()),
        // '/detail' : (BuildContext context) => UserDetailPage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => UserListsPage());
      },
    );
  }
}
