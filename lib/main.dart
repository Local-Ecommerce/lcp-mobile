import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/feature/auth/login/repository/firebase_login_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/login_repository.dart';
import 'package:lcp_mobile/route/route_constants.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'db/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  await DBProvider.instance.init();

  // LoginBloc _authBloc = LoginBloc();
  // var initialRoute = await _authBloc.add(Submitted())
  //     ? RouteConstant.homeRoute
  //     : RouteConstant.loginRoute;
  FirebaseLoginRepository _authBloc = FirebaseLoginRepository();
  var _initialRoute = await _authBloc.isSignedIn()
      ? RouteConstant.homeRoute
      : RouteConstant.loginRoute;

  runApp(MyApp(
    initialRoute: RouteConstant.updateProfileRoute,
    // initialRoute: _initialRoute,
  ));
}
