import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadgeColorText extends StatelessWidget {
  final String text;
  final Color color;

  const BadgeColorText({Key key, this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
