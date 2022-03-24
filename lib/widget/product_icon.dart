import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/resources/colors.dart';

class ProductIconBox extends StatelessWidget {
  final Product product;

  const ProductIconBox({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Image(
              image: AssetImage(product.images[0]),
              width: 36,
              height: 36,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.lightBlue,
            ),
          ),
          Text(
            product.productName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
