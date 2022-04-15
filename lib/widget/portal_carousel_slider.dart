import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';

class PortalCarousel extends StatefulWidget {
  final POI poi;
  final New news;
  final Function onTap;
  const PortalCarousel({Key key, this.poi, this.news, this.onTap})
      : super(key: key);

  @override
  _PortalCarouselState createState() => _PortalCarouselState();
}

class _PortalCarouselState extends State<PortalCarousel> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: _image(),
              height: 192.0,
              width: mediaQuery.size.width,
              fit: BoxFit.cover,
              // placeholder: (context, url) => Platform.isAndroid
              //     ? CircularProgressIndicator()
              //     : CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/img_not_found.jpg',
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          Container(
            width: mediaQuery.size.width,
            height: 192.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.0,
                  0.7,
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 12.0,
                  right: 12.0,
                ),
                child: Text(
                  widget.poi != null ? widget.poi.title : widget.news.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 4.0,
                  right: 12.0,
                ),
                child: Wrap(
                  children: <Widget>[
                    Icon(
                      Icons.launch,
                      color: Colors.white.withOpacity(0.8),
                      size: 12.0,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      widget.poi != null
                          ? '${widget.poi.text}'
                          : '${widget.news.text}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _image() {
    return widget.poi != null
        ? splitImageStringToList(widget.poi.images)[0]
        : splitImageStringToList(widget.news.image)[0];
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}
