import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/feature/auth/register/bloc/register_bloc.dart';
import 'package:lcp_mobile/feature/menu/bloc/category_bloc.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/portal/bloc/portal_bloc.dart';
import 'package:lcp_mobile/feature/portal_details/bloc/portal_detail_bloc.dart';
import 'package:lcp_mobile/localization/app_localization.dart';
import 'package:lcp_mobile/route/router.dart';

import 'feature/cart/bloc/cart_bloc.dart';
import 'feature/discover/bloc/discover_bloc.dart';
import 'feature/home/home.dart';
import 'feature/product_details/bloc/product_details_bloc.dart';
import 'feature/profile/bloc/profile_bloc.dart';

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({Key key, this.initialRoute}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final discoverBloc = DiscoverBloc();
  final cartBloc = CartBloc();
  final productDetailsBloc = ProductDetailsBloc();
  final profileBloc = ProfileBloc();
  final loginBloc = LoginBloc();
  final categoryBloc = CategoryBloc();
  final portalBloc = PortalBloc();
  final portalDetailBloc = PortalDetailsBloc();
  final orderBloc = OrderBloc();
  final regisBloc = RegisterBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return discoverBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return cartBloc..add(CartLoadingEvent());
            },
          ),
          BlocProvider(
            create: (context) {
              return profileBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return productDetailsBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return loginBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return categoryBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return portalBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return orderBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              return regisBloc;
            },
          ),
        ],
        child: MaterialApp(
            initialRoute: widget.initialRoute,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            locale: Locale('en', ''),
            supportedLocales: [
              const Locale('en', ''), // English
              const Locale('vi', ''), // Vietnamese
            ],
            localizationsDelegates: [
              AppLocalization.delegate,
              // GlobalMaterialLocalizations.delegate,
              // GlobalWidgetsLocalizations.delegate,
              // GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomeScreen()));
  }

  @override
  void dispose() {
    discoverBloc.close();
    regisBloc.close();
    cartBloc.close();
    productDetailsBloc.close();
    profileBloc.close();
    loginBloc.close();
    categoryBloc.close();
    portalBloc.close();
    portalDetailBloc.close();
    orderBloc.close();
    super.dispose();
  }
}
