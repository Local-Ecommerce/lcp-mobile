import 'package:lcp_mobile/feature/discover/model/product.dart';

class OrderDetails {
  String orderDetailId;
  int quantity;
  String orderDate;
  int finalAmount;
  int discount;
  int unitPrice;
  int status;
  String orderId;
  String productInMenuId;
  Product product;

  OrderDetails(
      {this.orderDetailId,
      this.quantity,
      this.orderDate,
      this.finalAmount,
      this.discount,
      this.unitPrice,
      this.status,
      this.orderId,
      this.productInMenuId,
      this.product});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['OrderDetailId'];
    quantity = json['Quantity'];
    orderDate = json['OrderDate'];
    finalAmount = json['FinalAmount'];
    discount = json['Discount'];
    unitPrice = json['UnitPrice'];
    status = json['Status'];
    orderId = json['OrderId'];
    productInMenuId = json['ProductInMenuId'];
    // product = json['Product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderDetailId'] = this.orderDetailId;
    data['Quantity'] = this.quantity;
    data['OrderDate'] = this.orderDate;
    data['FinalAmount'] = this.finalAmount;
    data['Discount'] = this.discount;
    data['UnitPrice'] = this.unitPrice;
    data['Status'] = this.status;
    data['OrderId'] = this.orderId;
    data['ProductInMenuId'] = this.productInMenuId;
    data['Product'] = this.product;
    return data;
  }
}
