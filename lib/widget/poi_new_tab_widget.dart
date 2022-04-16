import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/portal/bloc/portal_bloc.dart';
import 'package:lcp_mobile/feature/portal/ui/news_screen.dart';
import 'package:lcp_mobile/feature/portal/ui/poi_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/resources/api_strings.dart';

class PoiNewTabWidget extends StatefulWidget {
  @override
  State<PoiNewTabWidget> createState() => _PoiNewTabWidgetState();
}

class _PoiNewTabWidgetState extends State<PoiNewTabWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PoiScreen _poiScreen;
  NewsScreen _newsScreen;

  @override
  void initState() {
    _poiScreen = new PoiScreen();
    _newsScreen = new NewsScreen();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 50,
          decoration: BoxDecoration(
              color: Color(0xFFC4C4C4).withOpacity(0.4),
              borderRadius: BorderRadius.circular(25)),
          child: TabBar(
              controller: _tabController,
              labelColor: Colors.blueAccent,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelColor: Color(0xFF8A8A8A),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
              indicatorColor: Colors.transparent,
              isScrollable: true,
              tabs: [
                Tab(text: ApiStrings.pois),
                Tab(
                  text: ApiStrings.news,
                ),
              ])),
      Expanded(
        child: TabBarView(
            controller: _tabController,
            children: <Widget>[_newsScreen, _poiScreen]),
      )
    ]);
  }
}
