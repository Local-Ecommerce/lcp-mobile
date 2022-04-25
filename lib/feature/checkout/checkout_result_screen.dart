import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/db/db_provider.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';
import 'package:sqflite/sqflite.dart';

class CheckoutResultScreen extends StatefulWidget {
  final String orderId;

  const CheckoutResultScreen({Key key, this.orderId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckoutResultScreenState();
}

class _CheckoutResultScreenState extends State<CheckoutResultScreen> {
  Order order;
  UserData _userData;
  Database db;

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
    db = DBProvider.instance.database;

    context.bloc<OrderBloc>().add(LoadingOrderEvent(orderId: widget.orderId));
  }

  _convertDonateTime(String value) {
    try {
      return DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(value));
    } on FormatException catch (ex) {
      return DateFormat('dd/MM/yyyy hh:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(value)));
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
          iconTheme: IconThemeData(color: Colors.blueAccent),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: order == null
            ? LoaderPage()
            : ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 16),
                    child: Image.asset(
                      'assets/icon/success.png',
                      height: 64,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      "Đặt hàng thành công",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 16),
                    child: Text(order.orderId == null ? "" : order.orderId,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blueAccent, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mã giao dịch",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              // Text(order.transId)
                              Text("AMX_10213")
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Số tiền",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(NumberFormat("#,###", "vi_VN")
                                      .format(order.totalAmount) +
                                  "đ")
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Thời gian",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(_convertDonateTime(order.createdDate))
                              ],
                            )),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hình thức",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            //TODO
                            // (order.payType == 'momo')
                            // ? Text(
                            //     "Ví MoMo",
                            //     textAlign: TextAlign.end,
                            //   )
                            // : Text(
                            //     "Tiền mặt",
                            //     textAlign: TextAlign.end,
                            //   )
                            Text(
                              "Tiền mặt",
                              textAlign: TextAlign.end,
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                  // Container(
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.blueAccent, width: 0.5),
                  //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //     margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  //     padding: EdgeInsets.all(12),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           "Lời nhắn",
                  //           style: TextStyle(
                  //               color: Colors.black, fontWeight: FontWeight.bold),
                  //         ),
                  //         Text(
                  //           userDonateDetail.message,
                  //           textAlign: TextAlign.end,
                  //         )
                  //       ],
                  //     )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                        "Cảm ơn bạn đã đặt hàng, đơn hàng của bạn sẽ nhanh chóng đến thôi!",
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.black,
                          fontSize: 16,
                        )),
                  ),
                ],
              ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async => {
              await db.delete(DBProvider.TABLE_CART_ITEMS),
              // Navigator.popUntil(
              //     context, ModalRoute.withName(Navigator.defaultRouteName))
              Navigator.popUntil(context, ModalRoute.withName('/'))
            },
            child: Text(
              "Quay về trang chủ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                primary: AppColors.indianRed,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ),
      );
    });
  }
}
