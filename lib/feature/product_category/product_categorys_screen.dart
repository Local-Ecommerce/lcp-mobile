import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

import '../discover/model/product.dart';

class ProductCategoryScreen extends StatefulWidget {
  final List<Product> listProduct;
  final String categoryName;

  ProductCategoryScreen({@required this.listProduct, this.categoryName});

  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

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
              padding: const EdgeInsets.only(
                  top: 16, left: 28, right: 28, bottom: 16),
              child: Text(
                '${widget.categoryName}',
                style: headingText1,
              )),
          Expanded(
            child: GridView.builder(
              itemCount: widget.listProduct.length ?? 0,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                var product = widget.listProduct[index];
                return _buildCardProduct(product);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCardProduct(Product product) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, RouteConstant.productDetailsRoute,
          arguments: {
            'productId': product.productId,
            'residentId': product.residentId,
          }),
      child: Card(
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
                    child: Image.network(
                      splitImageStringToList(product.images)[0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  product.productName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  "${formatCurrency.format(product.defaultPrice)}",
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
