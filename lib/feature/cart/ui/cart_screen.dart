import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/feature/cart/bloc/cart_bloc.dart';
import 'package:lcp_mobile/feature/cart/models/cart.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/cart/repository/api_cart_repository.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/order/bloc/order_bloc.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/resources/app_theme.dart';
import 'package:lcp_mobile/resources/colors.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/alert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formatCurrency =
      NumberFormat.currency(locale: "en_US", symbol: "VNĐ ", decimalDigits: 0);

  List<OrderRequest> lstOrder = [];
  OrderRequest orderRequest;
  bool _isCreated = false;
  bool _isValidToBuy = true;
  bool _isOutOfStock = false;
  List<int> _lstIndex = [];
  List<int> _lstMaxBuy = [];
  List<bool> _lstValid = [];
  List<bool> _lstStock = [];
  List<Product> _lstProduct = [];

  ApiDiscoverRepository _apiDiscoverRepository;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartBloc>(context).add(CartLoadingEvent());
    orderRequest = new OrderRequest();
    _apiDiscoverRepository = new ApiDiscoverRepository();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              Cart cart;
              lstOrder = [];
              _lstIndex = [];
              _lstMaxBuy = [];
              _lstValid = [];
              _lstStock = [];
              if (state is CartLoadFinished) {
                cart = state.cart;
              }
              if (cart != null) {
                for (int i = 0; i < cart.listCartItem.length; i++) {
                  orderRequest.productId =
                      cart.listCartItem[i].product.productId;
                  orderRequest.quantity = cart.listCartItem[i].quantity;

                  //getOrderRequest
                  lstOrder.add(orderRequest);
                  //MaxBuy
                  if (orderRequest.quantity >
                      cart.listCartItem[i].product.maxBuy) {
                    // _isValidToBuy = false;
                    _lstValid.add(false);
                    _lstIndex.add(i + 1);
                    _lstMaxBuy.add(cart.listCartItem[i].product.maxBuy);
                  } else {
                    // _isValidToBuy = true;
                    _lstValid.add(true);
                  }

                  _lstValid.contains(false)
                      ? _isValidToBuy = false
                      : _isValidToBuy = true;

                  //check again product is out of stock or not
                  //TODO
                  // lstOrder.forEach((order) {
                  //   _lstProduct
                  //       .where((product) => product.productId == order.productId
                  //           ? product.quantity < order.quantity
                  //               ? _isOutOfStock == true
                  //               : _isOutOfStock == false
                  //           : null);
                  //   _lstStock.add(_isOutOfStock);
                  // });

                  // _lstStock.contains(true)
                  //     ? _isOutOfStock = true
                  //     : _isOutOfStock = false;

                  orderRequest = new OrderRequest();
                }
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
                            child: _resultCart(cart.getTotalPrice(),
                                cart.listCartItem.length, cart))),
                  ],
                );
              }

              return Container();
            },
          )),
    );
  }

  Widget _resultCart(double totalPrice, int items, Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16),
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
        _buttonAddToBag(totalPrice, items, cart)
      ],
    );
  }

  Widget _buttonAddToBag(double totalPrice, int items, Cart cart) {
    return BlocListener(
      bloc: context.bloc<OrderBloc>(),
      listener: (context, state) {
        if (state is OrderListLoadFinished) {
          if (_isCreated) {
            Navigator.pushNamed(context, RouteConstant.checkout, arguments: {
              'totalPrice': totalPrice,
              'orderId': state.lstOrder[0].orderId,
              'lstOrder': state.lstOrder
            });
          }
          setState(() {
            _isCreated = false;
          });
        }
      },
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            width: double.infinity,
            child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () => items == 0
                    ? Fluttertoast.showToast(
                        msg: "Không có sản phẩm nào trong giỏ hàng", // message
                        toastLength: Toast.LENGTH_LONG, // length
                        gravity: ToastGravity.CENTER, // location
                      )
                    : !_isValidToBuy
                        ? Fluttertoast.showToast(
                            msg:
                                "Bạn chỉ có thể mua ${_lstMaxBuy} sản phẩm tối đa cho sản phẩm thứ ${_lstIndex}", // message
                            toastLength: Toast.LENGTH_LONG, // length
                            gravity: ToastGravity.CENTER, // location
                          )
                        : _isOutOfStock
                            ? Fluttertoast.showToast(
                                msg: "Sản phẩm bạn mua đã hết hàng", // message
                                toastLength: Toast.LENGTH_LONG, // length
                                gravity: ToastGravity.CENTER, // location
                              )
                            : _isCreated
                                // ? Navigator.pushNamed(context, RouteConstant.checkout,
                                //     arguments: {
                                //         'totalPrice': totalPrice,
                                //         'orderId': _orderId
                                //       })
                                ? null
                                : createOrder(lstOrder),
                color:
                    _isCreated ? AppColors.paleVioletRed : AppColors.indianRed,
                child: Text(
                  'Tiếp tục',
                  style: whiteText,
                )),
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
          "Xoá sản phẩm",
          ""
              "Bạn có muốn xoá ${product.productName} ra khỏi giỏ hàng không?",
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

  createOrder(List<OrderRequest> lstOrder) {
    _isCreated = true;
    BlocProvider.of<OrderBloc>(context)
        .add(CreateOrderEvent(lstRequest: lstOrder));
    setState(() {});
  }

  getProductList(Cart cart) async {
    cart.listCartItem.forEach((cartItem) async {
      Product product = new Product();
      product = await _apiDiscoverRepository
          .getProductDetail(cartItem.product.productId);
      _lstProduct.add(product);
    });
  }
}
