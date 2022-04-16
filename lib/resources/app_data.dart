import 'package:lcp_mobile/feature/shipping/model/ship_method.dart';
import 'package:lcp_mobile/resources/R.dart';

import 'strings.dart';

class AppData {
  static List<ShipMethod> shipMethods = [
    ShipMethod(
        title: "Free ship", price: 0.0, description: R.strings.dummyShipping1),
    ShipMethod(
        title: "Fast ship", price: 15.0, description: R.strings.dummyShipping1),
    ShipMethod(
        title: "Custom time",
        price: 20.0,
        description: R.strings.dummyShipping1),
  ];
}

enum AppSettings {
  MY_ORDER,
  MY_FAVORITE,
  MY_WISHLIST,
  TRANSACTION,
  WEBSITE_STATE,
  MY_DEMO,
  PAYMENT,
  INFO,
  LEGAL,
  LOGOUT,
}

extension SettingsExtension on AppSettings {
  String get name {
    switch (this) {
      case AppSettings.MY_ORDER:
        return "My Order";
      case AppSettings.MY_FAVORITE:
        return "My Favorites";
      case AppSettings.MY_WISHLIST:
        return "My Wishlist";
      case AppSettings.TRANSACTION:
        return "Transaction";
      case AppSettings.WEBSITE_STATE:
        return "Website State";
      case AppSettings.MY_DEMO:
        return "My Demogrphics";
      case AppSettings.PAYMENT:
        return "Payment Details";
      case AppSettings.INFO:
        return "Your Infomation";
      case AppSettings.LEGAL:
        return "Legal";
      case AppSettings.LOGOUT:
        return "Logout";
    }
  }
}
