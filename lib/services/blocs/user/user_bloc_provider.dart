import 'package:flutter/material.dart';
import '../../blocs/user/user_bloc.dart';

class UserBlocProvider extends InheritedWidget {
  final UserBloc bloc;

  UserBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  static UserBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(UserBlocProvider)
              as UserBlocProvider)
          .bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
