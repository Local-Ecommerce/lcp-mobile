import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lcp_mobile/feature/cart/bloc/cart_bloc.dart';
import 'package:lcp_mobile/feature/cart/models/cart.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/resources/app_theme.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/alert_dialog.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(CartLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              Cart cart;
              if (state is CartLoadFinished) {
                cart = state.cart;
              }
              if (cart != null) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 28, right: 28, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Giỏ hàng',
                                  style: headingText,
                                ),
                                Text(
                                    'Tổng ${cart.listCartItem.length} sản phẩm')
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cart.listCartItem.length,
                            itemBuilder: (context, index) {
                              final cartItem = cart.listCartItem[index];
                              return Container(child: _cartItem(cartItem));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            child: _resultCart(cart.getTotalPrice()))),
                  ],
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget _resultCart(double totalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          height: 1,
          color: Colors.grey[300],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${formatCurrency.format(totalPrice)}",
                style: boldTextMedium,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _nextButton(totalPrice)
      ],
    );
  }

  Widget _nextButton(double totalPrice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            Navigator.pushNamed(context, RouteConstant.shippingMethod,
                arguments: totalPrice);
          },
          color: AppColors.indianRed,
          child: Text(
            'Tiếp tục',
            style: whiteText,
          )),
    );
  }

  Widget _cartItem(CartItem cartItem) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.all(24),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(26)),
            ),
            Positioned(
                right: 35,
                bottom: 35,
                child: Center(
                    child: Image.network(
                  splitImageStringToList(cartItem.product.images)[0],
                  width: 100,
                )))
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO need get Shop name
                // Text(
                //   cartItem.product.residentId,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Text(
                  cartItem.product.productName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cartItem.product.size != null) ...[
                      Text(
                        'Size:' + cartItem.product.size,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                    if (cartItem.product.color != null) ...[
                      Text(
                        'Màu:' + cartItem.product.color,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                    if (cartItem.product.weight != 0) ...[
                      Text(
                        'Cân nặng:' + cartItem.product.weight.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ]
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Text(
                  formatCurrency.format(cartItem.product.defaultPrice),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 30,
                      child: OutlineButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            decreaseQuantity(cartItem.product, cartItem),
                        child: Icon(Icons.remove),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "${cartItem.quantity}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 40,
                      height: 32,
                      child: OutlineButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            increaseQuantity(cartItem.product, cartItem),
                        child: Icon(Icons.add),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  increaseQuantity(Product product, CartItem cartItem) {
    BlocProvider.of<CartBloc>(context)
        .add(ChangeQuantityCartItem(product, cartItem.quantity + 1, cartItem));
  }

  decreaseQuantity(Product product, CartItem cartItem) {
    if (cartItem.quantity <= 1) {
      showAlertDialog(
          context,
          "Remove cart items?",
          ""
              "Are you sure to remove ${product.productName} from the shopping cart",
          () =>
              BlocProvider.of<CartBloc>(context).add(RemoveCartItem(cartItem)));
    } else {
      BlocProvider.of<CartBloc>(context).add(
          ChangeQuantityCartItem(product, cartItem.quantity - 1, cartItem));
    }
  }

  splitImageStringToList(String images) {
    return images.split("|");
  }
}
