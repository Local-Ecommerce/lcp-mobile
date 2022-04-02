import 'package:flutter/material.dart';
// import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:intl/intl.dart';

class CardProduct extends StatelessWidget {
  //TODO product req
  // final Product product;
  final product;
  final Function onTapCard;

  const CardProduct({Key key, @required this.product, this.onTapCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTapCard,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            width: width * 0.5,
            height: height * 0.4,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(
                  Text(
                    '${product.productName}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22),
                  ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    formatCurrency(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Text('130', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: 40,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  width: width * 0.4,
                  height: height * 0.2,
                  alignment: Alignment.bottomLeft,
                  child: Image.network(
                    splitImageStringToList('${product.images}')[0],
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                    alignment: Alignment.bottomLeft,
                  )),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 30,
              child: IconButton(
                  icon: Image.asset(
                    R.icon.rightArrow,
                    color: Colors.white,
                  ),
                  onPressed: () {}))
        ],
      ),
    );
  }

  formatCurrency() {
    final formatCurrency = NumberFormat.currency(
        locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

    return formatCurrency.format(int.parse('${product.defaultPrice}'));
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}
