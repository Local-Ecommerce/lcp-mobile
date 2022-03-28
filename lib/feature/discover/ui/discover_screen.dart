import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/discover/bloc/discover_bloc.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/ui/discover_fresh.dart';
import 'package:lcp_mobile/feature/discover/ui/discover_other.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/appbar.dart';
import 'package:lcp_mobile/widget/card_product.dart';
import 'package:lcp_mobile/widget/search_bar.dart';

import '../../../route/route_constants.dart';
import '../bloc/discover_bloc.dart';
import '../model/product.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  var _isSelectedCategory = false;
  var _currentIndexCategory = 0;

  var _isSelectedProductType = false;
  var _currentIndexProductType = 0;

  String _currentProductType = '';
  String _currentCategory = '';

  double width;
  double height;

  List<Product> listProduct;

  TabController _tabController;
  DiscoverFreshItemScreen _freshItemScreen;
  DiscoverItemScreen _otherItemScreen;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _freshItemScreen = DiscoverFreshItemScreen();
    _otherItemScreen = DiscoverItemScreen();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.pinkAccent.withOpacity(0.8),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: SearchField(hintText: "Tìm sản phẩm"),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.indianRed,
                  tabs: const <Widget>[
                    Tab(
                      text: "FRESH",
                    ),
                    Tab(
                      text: "OTHER",
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: <Widget>[_freshItemScreen, _otherItemScreen]),
    );
  }
}
