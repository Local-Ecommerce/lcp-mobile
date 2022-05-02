import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/feature/order/model/order_detail.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/widget/cart_title.dart';
import 'package:lcp_mobile/widget/order_status.dart';

class MyOrderDetailsView extends StatefulWidget {
  final Order order;

  const MyOrderDetailsView({Key key, @required this.order}) : super(key: key);

  @override
  _MyOrderDetailsViewState createState() => _MyOrderDetailsViewState();
}

class _MyOrderDetailsViewState extends State<MyOrderDetailsView> {
  UserData _userData;

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // return BlocConsumer<OrderBloc, OrderState>(
    //     listener: (context, state) {},
    //     builder: (context, state) {
    // if (state is OrderLoadFinished) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(AppSizes.sidePadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: 'Order: ',
                        style: _theme.textTheme.bodyText1,
                      ),
                      TextSpan(
                        text: 'No' + widget.order.orderId,
                        style: _theme.textTheme.bodyText1
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ])),
                    Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(widget.order.createdDate)),
                        style: _theme.textTheme.bodyText1
                            .copyWith(color: AppColors.lightGray))
                  ],
                ),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: 'Mã đơn hàng: ',
                          style: _theme.textTheme.bodyText1
                              .copyWith(color: AppColors.lightGray),
                        ),
                        TextSpan(
                          text: widget.order.orderId,
                          style: _theme.textTheme.bodyText1,
                        ),
                      ])),
                      _buildOrderStatus(widget.order.status),
                      // Text('Delivered',
                      //     style: _theme.textTheme.bodyText1
                      //         .copyWith(color: AppColors.green)),
                    ]),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.order.orderDetails.length.toString(),
                          style: _theme.textTheme.bodyText1,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: AppSizes.linePadding),
                          child: Text(
                            'sản phẩm',
                            style: _theme.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                // Container(
                //   width: width,
                //   height: height * 0.6,
                //   child: Column(
                Column(
                  children: _buildCartProductItems(widget.order),
                ),
                // ),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                buildSummaryLine('Địa chỉ giao hàng:',
                    _userData.deliveryAddress, _theme, width),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                buildSummaryLine(
                    'Phương thức thanh toán:',
                    widget.order.payments.length == 0
                        ? ""
                        : widget.order.payments[0].paymentMethodId == "PM_CASH"
                            ? "Tiền mặt"
                            : "Momo",
                    _theme,
                    width),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                // buildSummaryLine('Discount:',
                //     state.orderData.promo.toString(), _theme, width),
                // SizedBox(
                //   height: AppSizes.sidePadding,
                // ),
                buildSummaryLine(
                    'Tổng đơn hàng:',
                    formatCurrency.format(widget.order.totalAmount),
                    _theme,
                    width),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                Row(children: <Widget>[
                  // OpenFlutterButton(
                  //   backgroundColor: AppColors.white,
                  //   borderColor: _theme.primaryColor,
                  //   textColor: _theme.primaryColor,
                  //   height: 36,
                  //   width: (width - AppSizes.sidePadding * 3) / 2,
                  //   title: 'Reorder',
                  //   onPressed: (() => {
                  //         //TODO: reorder process
                  //       }),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: AppSizes.sidePadding),
                  // ),
                  // OpenFlutterButton(
                  //   height: 36,
                  //   width: (width - AppSizes.sidePadding * 3) / 2,
                  //   title: 'Leave Feedback',
                  //   onPressed: (() => {
                  //         //TODO: leave feedback
                  //       }),
                  // )
                  // _reportButton()
                ])
              ],
            ),
          )),
      // bottomNavigationBar: _reportButton(),
    );
  }
  //   return Container();
  // });
}

List<Widget> _buildCartProductItems(Order order) {
  return <Widget>[
    for (OrderDetails orderDetail in order.orderDetails)
      OpenFlutterCartTile(
        unitPrice: orderDetail.unitPrice,
        quantity: orderDetail.quantity,
        product: orderDetail.product,
        status: order.status,
        onAddToFav: (() => {}),
        onChangeQuantity: ((int quantity) => {}),
        onRemoveFromCart: (() => {}),
        orderComplete: true,
      )
  ];
}

Row buildSummaryLine(
    String label, String text, ThemeData _theme, double width) {
  // print(label + ' ' + text);
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style:
              _theme.textTheme.bodyText1.copyWith(color: AppColors.lightGray),
        ),
        Container(
          width: width / 2,
          child: Text(
            text,
            style: _theme.textTheme.bodyText1,
          ),
        )
      ]);
}

Widget _reportButton() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {},
        color: AppColors.indianRed,
        child: Text(
          'Báo cáo đơn hàng',
          style: whiteText,
        )),
  );
}

Widget _buildOrderStatus(int status) {
  switch (status) {
    case 5001:
      return Text("Chờ xác nhận",
          style: TextStyle(color: AppColors.darkGoldenRod, fontSize: 16));
      break;
    case 5007:
      return Text("Đã giao",
          style: TextStyle(color: AppColors.green, fontSize: 16));
      break;
    case 5002:
      return Text("Đã bị huỷ",
          style: TextStyle(color: AppColors.red, fontSize: 16));
      break;
    case 5006:
      return Text("Đã xác nhận",
          style: TextStyle(color: AppColors.green, fontSize: 16));
      break;
    default:
      return Container();
  }
}
