import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/portal/bloc/portal_bloc.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/feature/portal/ui/news_screen.dart';
import 'package:lcp_mobile/feature/portal/ui/poi_screen.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/app_theme.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/appbar.dart';
import 'package:lcp_mobile/widget/poi_new_tab_widget.dart';
import 'package:lcp_mobile/widget/search_bar.dart';

class Portal extends StatefulWidget {
  @override
  _PortalState createState() => _PortalState();
}

class _PortalState extends State<Portal> with TickerProviderStateMixin {
  double width;
  double height;
  TabController _tabController;
  List<POI> listPOI = [];
  List<New> listNew = [];
  PoiScreen _poiScreen;
  NewsScreen _newsScreen;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _poiScreen = new PoiScreen();
    _newsScreen = new NewsScreen();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Bảng tin chung cư",
            style: headingText,
          ),
          elevation: 0,
        ),
        body: Container(
            child: Column(children: [
          Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Color(0xFFC4C4C4).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(25)),
              child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelColor: Color(0xFF8A8A8A),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  tabs: [
                    Tab(text: ApiStrings.news),
                    Tab(
                      text: ApiStrings.pois,
                    ),
                  ])),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: <Widget>[_newsScreen, _poiScreen]),
          )
        ])));
  }
}
