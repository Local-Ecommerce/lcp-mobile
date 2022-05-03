import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

class TypePoiScreen extends StatefulWidget {
  final List<POI> listPoi;
  final String poiType;

  TypePoiScreen({@required this.listPoi, this.poiType});

  @override
  _TypePoiState createState() => _TypePoiState();
}

class _TypePoiState extends State<TypePoiScreen> {
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
            child: _buildPoiTilte(widget.poiType),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: widget.listPoi.length ?? 0,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                var poi = widget.listPoi[index];
                return _buildCardPoi(poi);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardPoi(POI poi) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, RouteConstant.poiDetailsRoute,
          arguments: poi),
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
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
                    child:poi.images != null ? Image.network(
                      splitImageStringToList(poi.images)[0],
                    ) : Image.asset("assets/images/no_news_pois.png"),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  poi.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, bottom: 12),
              //   child: Text(
              //     poi.releaseDate,
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
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

Widget _buildPoiTilte(String poiType) {
  if (poiType == "Popular") {
    return Text(
      'Địa điểm nổi bật',
      style: headingText1,
    );
  }
  return Text(
    'Địa điểm phổ biến',
    style: headingText1,
  );
}
