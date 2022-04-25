import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/resources/resources.dart';

class OpenFlutterCartTile extends StatefulWidget {
  final int quantity;
  final dynamic product;
  final int unitPrice;
  final Function(int quantity) onChangeQuantity;
  final Function() onAddToFav;
  final Function() onRemoveFromCart;
  final bool orderComplete;

  const OpenFlutterCartTile(
      {Key key,
      @required this.unitPrice,
      @required this.quantity,
      @required this.product,
      @required this.onChangeQuantity,
      @required this.onAddToFav,
      @required this.onRemoveFromCart,
      this.orderComplete = false})
      : super(key: key);

  @override
  _OpenFlutterCartTileState createState() => _OpenFlutterCartTileState();
}

class _OpenFlutterCartTileState extends State<OpenFlutterCartTile> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;

    print(widget.product['BaseProduct']['ProductName']);
    return Padding(
        padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: AppSizes.linePadding * 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.lightGray.withOpacity(0.3),
                      blurRadius: AppSizes.imageRadius,
                      offset: Offset(0.0, AppSizes.imageRadius))
                ],
                color: AppColors.white),
            child: Stack(children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 104,
                      child: widget.product['Image'] == null
                          ? Image.asset(R.icon.snkr01)
                          : Image.network(splitImageStringToList(
                              widget.product['Image'])[0])),
                  Container(
                      padding: EdgeInsets.only(left: AppSizes.sidePadding),
                      width: width - 134,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: width - 173,
                                    child: Text(
                                        widget.product['ProductName'] != null
                                            ? widget.product['ProductName']
                                            : widget.product['BaseProduct']
                                                ['ProductName'],
                                        style: _theme.textTheme.bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.black)),
                                  ),
                                  !widget.orderComplete
                                      ? InkWell(
                                          onTap: (() => {
                                                //TODO: show popup with add to favs and delete from cart
                                                showPopup = !showPopup,
                                                setState(() => {})
                                              }),
                                          child:
                                              Icon(Icons.more_vert, size: 24))
                                      : Container()
                                ]),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: AppSizes.linePadding * 2)),
                            // Wrap(
                            //     children: widget.item.selectedAttributes
                            //         .map((key, value) => MapEntry(
                            //             key,
                            //             SelectedAttributeView(
                            //               productAttribute: key,
                            //               selectedValue: value,
                            //             )))
                            //         .values
                            //         .toList()),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //       bottom: AppSizes.linePadding * 2),
                            // ),
                            Wrap(
                              direction: Axis.horizontal,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                if (widget.product['Size'] != null) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: 'Size: ',
                                          style: _theme.textTheme.bodyText1
                                              .copyWith(
                                                  color: AppColors.lightGray),
                                        ),
                                        TextSpan(
                                          text: widget.product['Size'],
                                          style: _theme.textTheme.bodyText1,
                                        ),
                                      ])),
                                    ],
                                  ),
                                ],
                                if (widget.product['Color'] != null) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: 'Color: ',
                                              style: _theme.textTheme.bodyText1
                                                  .copyWith(
                                                      color:
                                                          AppColors.lightGray),
                                            ),
                                            TextSpan(
                                              text: widget.product['Color'],
                                              style: _theme.textTheme.bodyText1,
                                            ),
                                          ])),
                                    ],
                                  ),
                                ],
                                if (double.parse(
                                        widget.product['Weight'].toString()) !=
                                    0) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: 'Weight: ',
                                              style: _theme.textTheme.bodyText1
                                                  .copyWith(
                                                      color:
                                                          AppColors.lightGray),
                                            ),
                                            TextSpan(
                                              text: widget.product['Weight']
                                                  .toString(),
                                              style: _theme.textTheme.bodyText1,
                                            ),
                                          ])),
                                    ],
                                  ),
                                ],
                              ],
                            ),

                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: AppSizes.linePadding * 2),
                            ),
                            Row(children: <Widget>[
                              Container(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: 'Quantity: ',
                                        style: _theme.textTheme.bodyText1
                                            .copyWith(
                                                color: AppColors.lightGray),
                                      ),
                                      TextSpan(
                                        text: widget.quantity.toString(),
                                        style: _theme.textTheme.bodyText1,
                                      ),
                                    ])),
                                  ],
                                ),
                              ),
                              Container(
                                width: width - 280,
                                alignment: Alignment.centerRight,
                                child: Text(
                                    formatCurrency.format(
                                        widget.unitPrice * widget.quantity),
                                    style: _theme.textTheme.bodyText1),
                              )
                            ]),
                          ]))
                ],
              ),
              showPopup
                  ? Positioned(
                      top: 10,
                      right: 30,
                      child: Container(
                          height: 90,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSizes.imageRadius),
                              color: AppColors.white,
                              border:
                                  Border.all(color: _theme.primaryColorLight)),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                  onTap: (() => {
                                        widget.onAddToFav(),
                                        showPopup = false,
                                        setState(() => {})
                                      }),
                                  child: Container(
                                      width: 140,
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.all(AppSizes.sidePadding),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: _theme.primaryColorLight,
                                              width: 0.4),
                                        ),
                                      ),
                                      child: Text('Add to Favorites'))),
                              InkWell(
                                  onTap: (() => {
                                        widget.onRemoveFromCart(),
                                        showPopup = false,
                                        setState(() => {})
                                      }),
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.all(AppSizes.sidePadding),
                                      child: Text('Remove from Cart'))),
                            ],
                          )))
                  : Container()
            ])));
  }
}

splitImageStringToList(String images) {
  return images.split("|");
}
