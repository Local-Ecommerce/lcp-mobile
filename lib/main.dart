import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/feature/auth/login/repository/firebase_login_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/login_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/route/route_constants.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'db/db_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  await DBProvider.instance.init();
  await UserPreferences.init();
  await TokenPreferences.init();

  FirebaseLoginRepository _authBloc = FirebaseLoginRepository();
  var _initialRoute = await _authBloc.isSignedIn()
      ? RouteConstant.homeRoute
      : RouteConstant.loginRoute;

  runApp(MyApp(
    // initialRoute: RouteConstant.orderHistoryRoute,
    initialRoute: _initialRoute,
  ));
}
