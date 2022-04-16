import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/size_config.dart';
import 'package:lcp_mobile/widget/badge_color_text.dart';

class PortalCard extends StatelessWidget {
  final POI poi;
  final New news;
  final Function onTapCard;

  PortalCard({Key key, this.poi, this.news, this.onTapCard}) : super(key: key);

  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    var image;
    if (news != null) {
      image = news.image != null ? splitImageStringToList(news.image)[0] : null;
    } else {
      image = poi.images != null ? splitImageStringToList(poi.images)[0] : null;
    }

    // SizeConfig().init(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTapCard,
      child: Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //     flex: 1,
              //     child:
              Container(
                width: width * 0.8,
                height: height * 0.2,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Expanded(
                              // flex: 2,
                              // child:
                              Container(
                                width: width,
                                child: Text(
                                  poi != null ? poi.title : news.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // alignment: Alignment.topRight,
                                    child: Row(
                                      children: [
                                        poi != null
                                            ? BadgeColorText(
                                                text: poi.type,
                                                color: Color(0xFFC44500),
                                              )
                                            : news != null
                                                ? BadgeColorText(
                                                    text: news.type,
                                                    color: Color(0xFFC44500),
                                                  )
                                                : Container(),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            width: 24,
                                            height: 24,
                                            child: Icon(
                                              FontAwesome5.clock,
                                              color: Colors.black,
                                              size: 16,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(left: 1),
                                          child: Text(
                                            poi != null
                                                ? DateFormat('dd/MM/yyyy hh:mm')
                                                    .format(DateTime.parse(
                                                        poi.releaseDate))
                                                : DateFormat('dd/MM/yyyy hh:mm')
                                                    .format(DateTime.parse(
                                                        news.releaseDate)),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // padding: EdgeInsets.only(right: 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (image != null) ...[
                          Container(
                              alignment: Alignment.topRight,
                              height: width * 0.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8)),
                                child: FadeInImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(image),
                                    // image: AssetImage(R.icon.snkr01),
                                    placeholder: AssetImage(R.icon.snkr01)),
                              )),
                        ],
                      ],
                    ),
                    Container(
                      child: Text(
                        poi != null ? poi.text : news.text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
              // )
            ],
          ),
        ),
      ),
    );
  }

  getTimeFrom() {
    DateTime now = DateTime.now();
    DateTime tmp = DateTime.parse(
        poi.releaseDate != null ? poi.releaseDate : news.releaseDate);
    return tmp.difference(now).inHours;
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}
