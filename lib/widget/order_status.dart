import 'package:flutter/material.dart';
import 'package:lcp_mobile/resources/colors.dart';

class OrderStatus extends StatelessWidget {
  final int status;
  const OrderStatus({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildOrderStatus();
  }

  Widget _buildOrderStatus() {
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
}
