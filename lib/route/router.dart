import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/auth/login/login_screen.dart';
import 'package:lcp_mobile/feature/auth/register/regis_screen.dart';
import 'package:lcp_mobile/feature/auth/register/update_info_screen.dart';
import 'package:lcp_mobile/feature/cart/ui/cart_screen.dart';
import 'package:lcp_mobile/feature/checkout/checkout_screen.dart';
import 'package:lcp_mobile/feature/checkout/checkout_result_screen.dart';
import 'package:lcp_mobile/feature/credit_card_details/card_details_screen.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/home/home.dart';
import 'package:lcp_mobile/feature/order/model/order.dart';
import 'package:lcp_mobile/feature/order/ui/order_detail_screen.dart';
import 'package:lcp_mobile/feature/order/ui/order_screen.dart';
import 'package:lcp_mobile/feature/portal/model/new.dart';
import 'package:lcp_mobile/feature/portal/model/poi.dart';
import 'package:lcp_mobile/feature/portal_details/ui/new_detail_screen.dart';
import 'package:lcp_mobile/feature/portal_details/ui/poi_detail_screen.dart';
import 'package:lcp_mobile/feature/product_category/product_categorys_screen.dart';
import 'package:lcp_mobile/feature/product_details/ui/product_details_screen.dart';
import 'package:lcp_mobile/feature/shipping/shipping_method_screen.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/route/slide_route_builder.dart';

import '../feature/discover/model/product.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstant.homeRoute:
        return SlideRouteBuilder(page: HomeScreen());
      case RouteConstant.productDetailsRoute:
        String productId = settings.arguments;
        return SlideRouteBuilder(
            page: ProductDetailsScreen(
          productId: productId,
        ));
      case RouteConstant.newDetailsRoute:
        New news = settings.arguments;
        return SlideRouteBuilder(
            page: NewDetailScreen(
          news: news,
        ));
      case RouteConstant.poiDetailsRoute:
        POI poi = settings.arguments;
        return SlideRouteBuilder(
            page: POIDetailScreen(
          poi: poi,
        ));
      case RouteConstant.checkoutResultRoute:
        String orderId = settings.arguments;
        return SlideRouteBuilder(
            page: CheckoutResultScreen(
          orderId: orderId,
        ));
      case RouteConstant.loginRoute:
        return SlideRouteBuilder(page: LoginScreen());
      case RouteConstant.registerRoute:
        return SlideRouteBuilder(page: RegisterScreen());
      case RouteConstant.updateProfileRoute:
        return SlideRouteBuilder(page: UpdateProfileScreen());
      case RouteConstant.cart:
        return SlideRouteBuilder(page: CartScreen());
      case RouteConstant.shippingMethod:
        final Map arguments = settings.arguments as Map;
        double totalPrice = arguments['totalPrice'];
        String orderId = arguments['orderId'];
        return SlideRouteBuilder(
            page:
                ShippingMethodScreen(totalPrice: totalPrice, orderId: orderId));
      case RouteConstant.creditCard:
        return SlideRouteBuilder(page: CreditCardDetailsScreen());
      case RouteConstant.checkout:
        final Map arguments = settings.arguments as Map;

        String orderId = arguments['orderId'];
        double shippingFee = arguments['shippingFee'];
        String paymentType = arguments['paymentType'];
        double totalPrice = arguments['totalPrice'];
        return SlideRouteBuilder(
            page: CheckoutScreen(
          orderId: orderId,
          totalPrice: totalPrice,
          paymentType: paymentType,
        )
            // shippingFee: shippingFee),
            );
      case RouteConstant.productCategory:
        final Map arguments = settings.arguments as Map;

        List<Product> listProduct = arguments['listProduct'];
        String categoryName = arguments['categoryName'];

        return SlideRouteBuilder(
            page: ProductCategoryScreen(
          listProduct: listProduct,
          categoryName: categoryName,
        ));
      case RouteConstant.orderHistoryRoute:
        return SlideRouteBuilder(page: MyOrdersView());
      case RouteConstant.orderDetail:
        Order order = settings.arguments;
        return SlideRouteBuilder(page: MyOrderDetailsView(order: order));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
