import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/resources/resources.dart';

class OpenFlutterOrderTile extends StatelessWidget {
  final Order order;
  final Function(String) onClick;
  final Function onCancel;

  const OpenFlutterOrderTile(
      {Key key, @required this.order, @required this.onClick, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(AppSizes.imageRadius),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _theme.primaryColor.withOpacity(0.3),
                blurRadius: AppSizes.imageRadius,
              )
            ],
            borderRadius: BorderRadius.circular(AppSizes.imageRadius),
            color: AppColors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.sidePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: 'Order: ',
                        style: _theme.textTheme.bodyText1.copyWith(
                            color: AppColors.lightGray,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: 'No' + order.orderId.toString(),
                        style: _theme.textTheme.bodyText1
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ])),
                    Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(order.createdDate)),
                        style: _theme.textTheme.bodyText1
                            .copyWith(color: AppColors.lightGray))
                  ],
                ),
                SizedBox(
                  height: AppSizes.sidePadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Mã đơn:',
                          style: _theme.textTheme.bodyText1
                              .copyWith(color: AppColors.lightGray),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: AppSizes.sidePadding),
                          child: Text(
                            order.orderId,
                            style: _theme.textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.sidePadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Số sản phẩm: ',
                              style: _theme.textTheme.bodyText1
                                  .copyWith(color: AppColors.lightGray),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.linePadding),
                              child: Text(
                                order.orderDetails.length.toString(),
                                style: _theme.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Tổng tiền: ',
                              style: _theme.textTheme.bodyText1
                                  .copyWith(color: AppColors.lightGray),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.sidePadding),
                              child: Text(
                                formatCurrency.format(order.totalAmount),
                                //total amount
                                style: _theme.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: AppSizes.linePadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 24, right: 24, top: 10, bottom: 10),
                      color: AppColors.white,
                      onPressed: () {
                        onClick(order.orderId);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: AppColors.black, width: 2)),
                      child: Text(
                        'Chi tiết',
                        style: _theme.textTheme.bodyText1,
                      ),
                    ),

                    if (order.status == 5001) ...[
                      RaisedButton(
                        padding: EdgeInsets.only(
                            left: 24, right: 24, top: 10, bottom: 10),
                        color: AppColors.white,
                        onPressed: () async {
                          if (await confirm(context,
                              title: const Text("Huỷ đơn hàng"),
                              content: const Text(
                                  "Bạn có chắc muốn huỷ bỏ đơn hàng này không?"),
                              textOK: const Text("Đồng ý"),
                              textCancel: const Text("Trở về"))) {
                            return onCancel();
                          } else {
                            print('pressedCancel');
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: AppColors.black, width: 2)),
                        child: Text(
                          'Huỷ đơn',
                          style: _theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                    // Text(order.status.toString().split('.')[1],
                    _buildOrderStatus(order.status),
                  ],
                )
              ],
            ),
          ),
        ));
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

  // String getOrderStatusString() {
  //   var str = 'New';
  //   switch (OrderStatus) {
  //     case OrderStatus.Paid:
  //       str = 'Paid';
  //       break;
  //     case OrderStatus.Sent:
  //       str = 'Sent';
  //       break;
  //     case OrderStatus.Delivered:
  //       str = 'Delivered';
  //       break;
  //     case OrderStatus.New:
  //     default:
  //       break;
  //   }
  //   return str;
  // }
}
