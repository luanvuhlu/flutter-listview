import 'package:flutter/material.dart';
import '../../blocs/user/user_bloc.dart';

class UserBlocProvider extends InheritedWidget {
  final UserBloc bloc;
  final Widget child;

  UserBlocProvider({this.bloc, this.child});

  static UserBlocProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(UserBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
