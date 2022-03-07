import 'package:flutter/material.dart';
import 'package:lcp_mobile/resources/colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key key, this.hintText}) : super(key: key);
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => print(value),
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hintText,
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}
