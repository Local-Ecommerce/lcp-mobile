import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/feature/credit_card_details/models/credit_card_model.dart';
import 'package:lcp_mobile/feature/payment/model/payment.dart';
import 'package:lcp_mobile/feature/payment/repository/api_payment_repository.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  // final double shippingFee;
  final double totalPrice;
  final String paymentType;
  final String orderId;

  const CheckoutScreen(
      {Key key,
      // this.shippingFee,
      this.totalPrice,
      this.paymentType,
      this.orderId})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

  final _formKey = GlobalKey<FormState>();

  UserData _userData;
  StreamSubscription _sub;
  CreditCard resultCreditCard = creditCards[1];
  PaymentRequest _paymentRequest;
  Object _err;
  Uri _initialUri;
  Uri _latestUri;
  int countdown;
  Order order;

  // DatabaseReference _ref;
  // DatabaseReference _orderRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _paymentRequest = new PaymentRequest();
    _userData = UserPreferences.getUser();
    _handleIncomingLinks();
    // _ref = FirebaseDatabase.instance.reference();

    //Add value to payment request
    _paymentRequest.orderId = widget.orderId;
    _paymentRequest.paymentAmount = widget.totalPrice;
    // _ref.reference().child('Notification').once().then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    // });

    //Loading order info
    context.bloc<OrderBloc>().add(LoadingOrderEvent(orderId: widget.orderId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = getUriLinksStream().listen((Uri uri) {
        if (!mounted) return;
        setState(() {
          Order order = Order.fromMoMoResponse(uri.queryParameters);
          Navigator.pushNamed(context, RouteConstant.checkoutResultRoute,
              arguments: order.orderId);
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
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      if (state is OrderLoadFinished) {
        order = state.order;
      }

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
                                  _userData.fullName != null
                                      ? _userData.fullName
                                      : "Temp",
                                ),
                                FlatButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Change',
                                      style: TextStyle(color: Colors.orange),
                                    )),
                              ],
                            ),
                            Text(_userData.deliveryAddress)
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   'Phương thức giao hàng',
                    //   style: headingText,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   children: [
                    //     if (widget.shippingFee < 10000) ...[
                    //       deliveryCard(R.icon.ex01),
                    //     ],
                    //     if (widget.shippingFee < 20000 &&
                    //         widget.shippingFee > 10000) ...[
                    //       deliveryCard(R.icon.ex02),
                    //     ],
                    //     if (widget.shippingFee > 20000) ...[
                    //       deliveryCard(R.icon.ex03),
                    //     ],
                    //   ],
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mã đơn:',
                            style: minorText,
                          ),
                          Text(
                            widget.orderId,
                            style: textMedium,
                          )
                        ],
                      ),
                    ),
                    // rowOrderInfo('Phí vận chuyển:',
                    //     widget.shippingFee != null ? widget.shippingFee : 0),
                    rowOrderInfo('Tổng cộng:',
                        widget.totalPrice != null ? widget.totalPrice : 0),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              )
            ])),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(14.0), child: _buttonSubmitOrder()),
      );
    });
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
    // int delay = 3;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () async {
            order.orderDetails.forEach((orderDetail) async {
              // _database = FirebaseDatabase.instance
              //     .reference()
              //     .child("Notification/" + orderDetail.product["ResidentId"]);

              // print(orderDetail.product["ResidentId"]);
              // _database.push().set(<String, dynamic>{
              //   'createdDate': order.createdDate,
              //   'data': {orderDetail.product["Image"]},
              //   'read': 0,
              //   'receiverId': order.residentId,
              //   'senderId': _userData.uid,
              //   'type': 301
              // });
              // print("Notification/" +
              //     orderDetail.product["ResidentId"].toString());

              // _ref = FirebaseDatabase.instance.reference().child(
              //     "Notification/" +
              //         orderDetail.product["ResidentId"].toString());
              // _ref
              //     .reference()
              //     .child("Notification/" +
              //         orderDetail.product["residentId"].toString())
              //     .once()
              //     .then((DataSnapshot snapshot) {
              //   print(
              //       'Connected to second database and read ${snapshot.value}');
              // });
              // String key = _orderRef
              //     .child('Notification')
              //     .push()
              //     .child(orderDetail.product['ResidentId'].toString())
              //     .push()
              //     .key;
              // print(key);

              // _orderRef
              //     .child('Notification')
              //     .child(orderDetail.product['ResidentId'].toString())
              //     .child(key)
              //     .set(<String, String>{
              //   'createdDate': order.createdDate,
              //   'data': orderDetail.product["Image"],
              //   'read': '0',
              //   'receiverId': order.residentId,
              //   'senderId': _userData.uid,
              //   'type': '301'
              // });

              // DatabaseReference chatRef = FirebaseDatabase.instance.reference();
              // String key2 = chatRef.child('childname').push().key;
              // chatRef.child('childname').child(key2).set(<String, String>{
              //   'id': key2,
              // });
              // await _ref
              //     .push()
              //     .child("Notification/" +
              //         orderDetail.product["ResidentId"].toString())
              //     .set(<String, String>{
              //   'createdDate': order.createdDate,
              //   'data': orderDetail.product["Image"],
              //   'read': '0',
              //   'receiverId': order.residentId,
              //   'senderId': _userData.uid,
              //   'type': '301'
              // });
            });

            if (_formKey.currentState.validate()) {
              ApiPaymentRepository paymentService = new ApiPaymentRepository();
              paymentService
                  .createPayment(_paymentRequest)
                  .then((value) => {print(value), _launchURL(value.payUrl)});
              // Navigator.popAndPushNamed(
              //     context, RouteConstant.checkoutResultRoute,
              //     arguments: widget.orderId);
            }
          },
          color: AppColors.indianRed,
          child: Text(
            'XÁC NHẬN ĐẶT HÀNG',
            style: whiteText,
          )),
    );
  }

  // Widget deliveryCard(String icon) {
  //   // return Expanded(
  //   // child:
  //   return Card(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           children: [
  //             Image.asset(
  //               icon,
  //               width: 30,
  //               height: 30,
  //             ),
  //             SizedBox(
  //               height: 6,
  //             ),
  //             Text(
  //               widget.shippingFee < 10000
  //                   ? '1 ngày'
  //                   : widget.shippingFee > 20000
  //                       ? '30 phút'
  //                       : '1-3 giờ',
  //               style: smallText,
  //             ),
  //           ],
  //         ),
  //       )
  //       // ),
  //       );
  // }

  void changePayment() {
    Navigator.pushNamed(context, RouteConstant.creditCard).then((value) {
      resultCreditCard = value as CreditCard;
      print(resultCreditCard.type);
      // _paymentRequest.payType = resultCreditCard.type;
      setState(() {});
    });
  }
}
