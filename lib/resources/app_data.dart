import 'package:lcp_mobile/feature/shipping/model/ship_method.dart';
import 'package:lcp_mobile/resources/R.dart';

import 'strings.dart';

class AppData {
  static List<ShipMethod> shipMethods = [
    ShipMethod(
        title: "Free ship",
        shippingFee: 0.0,
        description: R.strings.dummyShipping1),
    ShipMethod(
        title: "Fast ship",
        shippingFee: 15000.0,
        description: R.strings.dummyShipping1),
    ShipMethod(
        title: "Custom time",
        shippingFee: 25000.0,
        description: R.strings.dummyShipping1),
  ];
}

enum AppSettings {
  MY_ORDER,
  INFO,
  CHANGE_PASSWORD,
  CONNECT_WITH_US,
  LOGOUT,
}

extension SettingsExtension on AppSettings {
  String get name {
    switch (this) {
      case AppSettings.MY_ORDER:
        return "Đơn hàng của tôi";
      case AppSettings.CHANGE_PASSWORD:
        return "Đổi mật khẩu";
      case AppSettings.INFO:
        return "Cập nhật thông tin";
      case AppSettings.CONNECT_WITH_US:
        return "Trở thành người bán hàng";
      case AppSettings.LOGOUT:
        return "Đăng xuất";
    }
  }
}
