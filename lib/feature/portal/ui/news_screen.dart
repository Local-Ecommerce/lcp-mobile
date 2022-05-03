import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/portal/bloc/portal_bloc.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/portal_carousel_slider.dart';
import 'package:lcp_mobile/widget/portal_card_widget.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  double width;
  double height;
  UserData _userData = UserPreferences.getUser();
  int _currentPage = 0;

  List<New> lstNews = [];
  List<New> lstPopularNews = [];
  List<New> lstHotNews = [];
  List<New> lstNewsImage = [];

  @override
  void initState() {
    super.initState();
    context
        .bloc<PortalBloc>()
        .add(LoadingNewsEvent(apartmentId: _userData.apartmentId));
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
                        "Tin tức mới",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteConstant.typeNewsRoute,
                                arguments: {
                                  "listNew": lstHotNews,
                                  "newType": lstHotNews[0].type
                                });
                          },
                          child: Text(
                            'Xem thêm',
                            style: TextStyle(color: Colors.orange),
                          )),
                    ],
                  ),
                ),
                _buildHotNewsCatalog(),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tin nổi bật",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteConstant.typeNewsRoute,
                                arguments: {
                                  "listNew": lstPopularNews,
                                  "newType": lstPopularNews[0].type
                                });
                          },
                          child: Text(
                            'Xem thêm',
                            style: TextStyle(color: Colors.orange),
                          )),
                    ],
                  ),
                ),
                _buildPopularNewsCatalog(),
              ],
            )),
      ],
    ));
  }

  Widget buildListCarouse() {
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      lstNewsImage = [];

      if (state is NewsLoadFinished) {
        lstNewsImage = _getListNewsHaveImage(state.news);
      }

      return CarouselSlider(
        items: List.generate(lstNewsImage.length, (index) {
          var news = lstNewsImage[index];
          return Container(
              child: PortalCarousel(
            news: news,
            poi: null,
            onTap: () {
              Navigator.pushNamed(context, RouteConstant.newDetailsRoute,
                  arguments: news);
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

  Widget _buildListNews() {
    // return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: lstNews.length,
        itemBuilder: (context, index) {
          var news = lstNews[index];
          return PortalCard(
              poi: null,
              news: news,
              onTapCard: () {
                Navigator.pushNamed(context, RouteConstant.newDetailsRoute,
                    arguments: news);
              });
        });
    // });
  }

  Widget _buildPopularNewsCatalog() {
    // _getListPopularNews();
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      // lstPopularNews = [];

      // if (state is NewsLoadFinished) {
      //   lstPopularNews = state.news;
      // }

      return Container(
        width: width * 0.85,
        height: height * 0.21,
        // margin: EdgeInsets.only(top: 16),
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: lstPopularNews.length,
            itemBuilder: (context, index) {
              var news = lstPopularNews[index];
              return PortalCard(
                  poi: null,
                  news: news,
                  onTapCard: () {
                    Navigator.pushNamed(context, RouteConstant.newDetailsRoute,
                        arguments: news);
                  });
            }),
      );
    });
  }

  Widget _buildHotNewsCatalog() {
    // _getListHotNews();
    return BlocBuilder<PortalBloc, PortalState>(builder: (context, state) {
      lstNews = [];
      lstHotNews = [];
      lstPopularNews = [];

      if (state is NewsLoadFinished) {
        lstNews = state.news;
      }

      lstNews.forEach((news) {
        news.type == "Popular"
            ? lstPopularNews.add(news)
            : lstHotNews.add(news);
      });

      return Container(
        width: width * 0.85,
        height: height * 0.21,
        // margin: EdgeInsets.only(top: 16),
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: lstHotNews.length,
            itemBuilder: (context, index) {
              var news = lstHotNews[index];
              return PortalCard(
                  poi: null,
                  news: news,
                  onTapCard: () {
                    Navigator.pushNamed(context, RouteConstant.newDetailsRoute,
                        arguments: news);
                  });
            }),
      );
    });
  }

  List<New> _getListNewsHaveImage(List<New> lstNews) {
    List<New> lstTmp = [];
    lstNews.forEach((news) {
      if (news.image != null) lstTmp.add(news);
    });
    return lstTmp;
  }

  _getListPopularNews() {
    BlocProvider.of<PortalBloc>(context).add(LoadingNewsEvent(
        apartmentId: _userData.apartmentId, type: ApiStrings.popular));
  }

  _getListHotNews() {
    BlocProvider.of<PortalBloc>(context).add(LoadingNewsEvent(
        apartmentId: _userData.apartmentId, type: ApiStrings.hot));
  }
}
