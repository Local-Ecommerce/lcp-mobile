import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lcp_mobile/api/base_request.dart';
import 'package:lcp_mobile/feature/cart/models/order.dart';
import 'package:lcp_mobile/feature/credit_card_details/models/credit_card_model.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  final double shippingFee;
  final double totalPrice;

  const CheckoutScreen({Key key, this.shippingFee, this.totalPrice})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

  final _formKey = GlobalKey<FormState>();

  StreamSubscription _sub;
  CreditCard resultCreditCard = creditCards[0];
  PaymentRequest _paymentRequest;
  Object _err;
  Uri _initialUri;
  Uri _latestUri;

  @override
  void initState() {
    super.initState();
    _paymentRequest = new PaymentRequest();

    _handleIncomingLinks();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = getUriLinksStream().listen((Uri uri) {
        if (!mounted) return;
        setState(() {
          Order order = Order.fromMoMoResponse(uri.queryParameters);
          Navigator.pushNamed(context, RouteConstant.checkoutResultRoute,
              arguments: order.orderId);
          // Get.offAll(() => DonationResultPage(),
          //     arguments: {'userDonateDetail': userDonateDetail});
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ giao hàng',
                    //TODO get user info address here
                    style: headingText,
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jane Doe',
                              ),
                              FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Change',
                                    style: TextStyle(color: Colors.orange),
                                  )),
                            ],
                          ),
                          Text(R.strings.dummyShipping1)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phương thức thanh toán',
                        style: headingText,
                      ),
                      FlatButton(
                          onPressed: () async => changePayment(),
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.orange),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                          margin: EdgeInsets.only(right: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              resultCreditCard != null
                                  ? resultCreditCard.image
                                  : R.icon.masterCard,
                              width: 30,
                              height: 30,
                            ),
                          )),
                      Text(resultCreditCard != null
                          ? resultCreditCard.cardHolderName
                          : '')
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Phương thức giao hàng',
                    style: headingText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      deliveryCard(R.icon.ex01),
                      deliveryCard(R.icon.ex02),
                      deliveryCard(R.icon.ex03),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  rowOrderInfo('Đơn hàng:', 112),
                  rowOrderInfo(
                      'Vận chuyển:',
                      widget.shippingFee != null
                          ? widget.shippingFee.toDouble()
                          : 0),
                  rowOrderInfo('Tổng cộng:', 0),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ])),
      bottomNavigationBar:
          Container(padding: EdgeInsets.all(14.0), child: _buttonSubmitOrder()),
    );
  }

  Widget rowOrderInfo(String type, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: minorText,
          ),
          Text(
            "${formatCurrency.format(price)}",
            style: textMedium,
          )
        ],
      ),
    );
  }

  Widget _buttonSubmitOrder() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            // if (_formKey.currentState.validate()) {
            //   DonateService donateService = new DonateService();
            //   donateService
            //       .donate(donateRequest)
            //       .then((value) => {_launchURL(value.deeplink)});
            //   // Get.off(() => DonationResultPage());
            // }
          },
          color: AppColors.indianRed,
          child: Text(
            'XÁC NHẬN ĐẶT HÀNG',
            style: whiteText,
          )),
    );
  }

  Widget deliveryCard(String icon) {
    return Expanded(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(
                  icon,
                  width: 30,
                  height: 30,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '2-3 days',
                  style: smallText,
                ),
              ],
            ),
          )),
    );
  }

  void changePayment() {
    Navigator.pushNamed(context, RouteConstant.creditCard).then((value) {
      setState(() {
        resultCreditCard = value as CreditCard;
        _paymentRequest.payType = resultCreditCard.type;
      });
    });
  }
}
