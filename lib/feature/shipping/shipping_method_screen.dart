import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/shipping/model/ship_method.dart';
import 'package:lcp_mobile/resources/app_data.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/route/route_constants.dart';

class ShippingMethodScreen extends StatefulWidget {
  final double totalPrice;
  final String orderId;

  const ShippingMethodScreen({Key key, this.totalPrice, this.orderId})
      : super(key: key);
  @override
  _ShippingMethodScreenState createState() => _ShippingMethodScreenState();
}

class _ShippingMethodScreenState extends State<ShippingMethodScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);
  var _isSelectedShipMethod = false;
  var _currentIndexShipMethod = 0;
  var _shippingFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Shipping method',
                style: headingText1,
              )),
          Container(
            color: Colors.grey[300],
            height: 1,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 28, right: 28, bottom: 16),
              child: Text(
                'Choose your shipping method',
                style: textMedium,
              )),
          Expanded(
              child: ListView.builder(
            itemCount: AppData.shipMethods.length,
            itemBuilder: (context, index) {
              _isSelectedShipMethod = _currentIndexShipMethod == index;
              var shipMethod = AppData.shipMethods[index];
              return cartShipping(shipMethod, index);
            },
          )),
          _nextButton()
        ],
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            Navigator.pushNamed(context, RouteConstant.checkout, arguments: {
              'totalPrice': widget.totalPrice,
              'orderId': widget.orderId,
              'shippingFee':
                  AppData.shipMethods[_currentIndexShipMethod].shippingFee,
            });
          },
          color: AppColors.indianRed,
          child: Text(
            'Tiếp tục',
            style: whiteText,
          )),
    );
  }

  Widget cartShipping(ShipMethod shipMethod, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndexShipMethod = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: _isSelectedShipMethod ? Colors.black : Colors.cyan[50],
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 26, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shipMethod.title,
                    style: _isSelectedShipMethod ? textMediumWhite : textMedium,
                  ),
                  Text(
                    formatCurrency.format(shipMethod.shippingFee),
                    style: _isSelectedShipMethod ? textMediumWhite : textMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                shipMethod.description,
                style: _isSelectedShipMethod ? minorTextWhite : minorText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
