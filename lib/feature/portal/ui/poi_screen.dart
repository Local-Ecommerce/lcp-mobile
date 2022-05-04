import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/portal/bloc/portal_bloc.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/portal_card_widget.dart';
import 'package:lcp_mobile/widget/portal_carousel_slider.dart';

class PoiScreen extends StatefulWidget {
  PoiScreen({Key key}) : super(key: key);

  @override
  State<PoiScreen> createState() => _PoiScreenState();
}

class _PoiScreenState extends State<PoiScreen> {
  double width;
  double height;
  UserData _userData = UserPreferences.getUser();
  ChangeNotifier notifier;

  List<POI> lstPois = [];
  List<POI> lstPopularPois = [];
  List<POI> lstHotPois = [];
  List<POI> lstPoiImages = [];

  @override
  void initState() {
    super.initState();
    context
        .bloc<PortalBloc>()
        .add(LoadingPoisEvent(apartmentId: _userData.apartmentId));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Container(
        child: ListView(
      padding: EdgeInsets.all(0),
      children: [
        Padding(padding: EdgeInsets.only(top: 12)),
        buildListCarouse(),
        Container(
            margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Địa điểm nổi bật",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteConstant.typePoisRoute,
                                arguments: {
                                  "listPoi": lstPopularPois,
                                  "poiType": lstPopularPois[0].type
                                });
                          },
                          child: Text(
                            'Xem thêm',
                            style: TextStyle(color: Colors.orange),
                          )),
                    ],
                  ),
                ),
                _buildHotPoisCatalog(),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Địa điểm phổ biến",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteConstant.typePoisRoute,
                                arguments: {
                                  "listPoi": lstHotPois,
                                  "poiType": lstHotPois[0].type
                                });
                          },
                          child: Text(
                            'Xem thêm',
                            style: TextStyle(color: Colors.orange),
                          )),
                    ],
                  ),
                ),
                _buildPopularPoisCatalog(),
              ],
            )),
      ],
    ));
  }

  Widget buildListCarouse() {
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      lstPoiImages = [];

      if (state is PoisLoadFinished) {
        lstPoiImages = _getListPoisHaveImage(state.pois);
      }

      return CarouselSlider(
        items: List.generate(lstPoiImages.length, (index) {
          var poi = lstPoiImages[index];
          return Container(
              child: PortalCarousel(
            news: null,
            poi: poi,
            onTap: () {
              Navigator.pushNamed(context, RouteConstant.poiDetailsRoute,
                  arguments: poi);
            },
          ));
        }).toList(),
        options: CarouselOptions(
            height: height * 0.25,
            scrollDirection: Axis.horizontal,
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlay: true,
            onPageChanged: (index, reason) {
              // setState(() {
              //   _current = index;
              // });
            }),
      );
    });
  }

  Widget _buildListPois() {
    // return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: lstPois.length,
        itemBuilder: (context, index) {
          var poi = lstPois[index];
          return PortalCard(
              poi: poi,
              news: null,
              onTapCard: () {
                Navigator.pushNamed(context, RouteConstant.poiDetailsRoute,
                    arguments: poi);
              });
        });
    // });
  }

  Widget _buildPopularPoisCatalog() {
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      return Container(
        width: width * 0.85,
        height: height * 0.21,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: lstPopularPois.length,
            itemBuilder: (context, index) {
              var poi = lstPopularPois[index];
              return PortalCard(
                  poi: poi,
                  news: null,
                  onTapCard: () {
                    Navigator.pushNamed(context, RouteConstant.poiDetailsRoute,
                        arguments: poi);
                  });
            }),
      );
    });
  }

  Widget _buildHotPoisCatalog() {
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      lstPois = [];
      lstHotPois = [];
      lstPopularPois = [];

      if (state is PoisLoadFinished) {
        lstPois = state.pois;
      }

      lstPois.forEach((poi) {
        poi.type == "Popular" ? lstPopularPois.add(poi) : lstHotPois.add(poi);
      });

      return Container(
        width: width * 0.85,
        height: height * 0.21,
        // margin: EdgeInsets.only(top: 16),
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: lstHotPois.length,
            itemBuilder: (context, index) {
              var poi = lstHotPois[index];
              return PortalCard(
                  poi: poi,
                  news: null,
                  onTapCard: () {
                    Navigator.pushNamed(context, RouteConstant.poiDetailsRoute,
                        arguments: poi);
                  });
            }),
      );
    });
  }

  List<POI> _getListPoisHaveImage(List<POI> lstPoi) {
    List<POI> lstTmp = [];
    lstPoi.forEach((poi) {
      if (poi.images != null) lstTmp.add(poi);
    });

    return lstTmp;
  }

  _getListPopularPois() {
    BlocProvider.of<PortalBloc>(context).add(LoadingPoisEvent(
        apartmentId: _userData.apartmentId, type: ApiStrings.popular));
  }

  _getListHotPois() {
    BlocProvider.of<PortalBloc>(context).add(LoadingPoisEvent(
        apartmentId: _userData.apartmentId, type: ApiStrings.hot));
  }
}
