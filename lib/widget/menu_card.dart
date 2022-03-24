import 'dart:math';

import 'package:flutter/material.dart';

import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/colors.dart';

class CardMenu extends StatelessWidget {
  final menu;
  final Function onTapCard;

  const CardMenu({Key key, @required this.menu, this.onTapCard})
      : super(key: key);

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Container(
      height: 150.0,
      margin: new EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
        gradient: new LinearGradient(
            colors: [Colors.yellow[700], Colors.redAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
              padding: new EdgeInsets.only(left: 10.0, right: 10.0),
              child: new CircleAvatar(
                radius: 35.0,
                backgroundImage:
                    NetworkImage('https://wallpapercave.com/wp/wp2365076.jpg'),
              )),
          new Expanded(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                'New York',
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
              new SizedBox(
                height: 8.0,
              ),
              new Text(
                'Sunny',
                style: new TextStyle(fontSize: 12.0, color: Colors.white70),
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Row(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Text('2342',
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.white)),
                      new Text('Popularity',
                          style: new TextStyle(
                              fontSize: 10.0, color: Colors.white)),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text('2342',
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.white)),
                      new Text('Like',
                          style: new TextStyle(
                              fontSize: 10.0, color: Colors.white)),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text('2342',
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.white)),
                      new Text('Followed',
                          style: new TextStyle(
                              fontSize: 10.0, color: Colors.white)),
                    ],
                  )
                ],
              )
            ],
          )),
          new Padding(
              padding: new EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    '12°',
                    style: new TextStyle(fontSize: 30.0, color: Colors.white70),
                  ),
                  new Text(
                    'Ranking',
                    style: new TextStyle(fontSize: 14.0, color: Colors.white70),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
