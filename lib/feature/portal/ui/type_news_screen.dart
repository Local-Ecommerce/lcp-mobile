import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

class TypeNewScreen extends StatefulWidget {
  final List<New> listNew;
  final String newType;

  TypeNewScreen({@required this.listNew, this.newType});

  @override
  _TypeNewScreenState createState() => _TypeNewScreenState();
}

class _TypeNewScreenState extends State<TypeNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 28, right: 28, bottom: 16),
            child: _buildNewsTilte(widget.newType),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: widget.listNew.length ?? 0,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                var news = widget.listNew[index];
                return _buildCardNews(news);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardNews(New news) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, RouteConstant.newDetailsRoute,
          arguments: news),
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: news.image != null ? Image.network(
                      splitImageStringToList(news.image)[0],
                    ) : Image.asset("assets/images/no_news_pois.png"),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  news.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}

Widget _buildNewsTilte(String newType) {
  if (newType == "Popular") {
    return Text(
      'Tin nổi bật',
      style: headingText1,
    );
  }
  return Text(
    'Tin tức mới',
    style: headingText1,
  );
}
