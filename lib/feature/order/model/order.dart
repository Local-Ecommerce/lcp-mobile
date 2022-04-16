// class Order {
//   String _orderId;
//   String _customerId;
//   double _amount;
//   String _payType;
//   String _transId;
//   String _orderTime;
//   int _resultCode;
//   String _resultMessage;

//   Order(
//       {String orderId,
//       String userId,
//       double amount,
//       String payType,
//       String transId,
//       String orderTime,
//       int resultCode,
//       String resultMessage}) {
//     this._orderId = orderId;
//     this._customerId = _customerId;
//     this._amount = amount;
//     this._payType = payType;
//     this._transId = transId;
//     this._orderTime = orderTime;
//     this._resultCode = resultCode;
//     this._resultMessage = resultMessage;
//   }

//   String get orderId => _orderId;

//   set orderId(String orderId) => _orderId = orderId;

//   String get userId => _customerId;

//   set userId(String customerId) => _customerId = customerId;

//   double get amount => _amount;

//   set amount(double amount) => _amount = amount;

//   String get payType => _payType;

//   set payType(String payType) => _payType = payType;

//   String get transId => _transId;

//   set transId(String transId) => _transId = transId;

//   String get orderTime => _orderTime;

//   set orderTime(String orderTime) => _orderTime = orderTime;

//   int get resultCode => _resultCode;

//   set resultCode(int resultCode) => _resultCode = resultCode;

//   String get resultMessage => _resultMessage;

//   set resultMessage(String resultMessage) => _resultMessage = resultMessage;

//   Order.fromJson(Map<String, dynamic> json) {
//     _orderId = json['OrderId'];
//     _customerId = json['UserId'];
//     _amount = json['Amount'];
//     _payType = json['PayType'];
//     _transId = json['TransId'];
//     _orderTime = json['OrderTime'];
//     _resultCode = json['ResultCode'];
//     _resultMessage = json['ResultMessage'];
//   }

//   Order.fromMoMoResponse(Map<String, String> json) {
//     _orderId = json['orderId'];
//     _amount = double.parse(json['amount']);
//     _payType = json['orderType'];
//     _transId = json['transId'];
//     _orderTime = json['responseTime'];
//     _resultCode = int.parse(json['resultCode']);
//     _resultMessage = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Id'] = this._orderId;
//     data['UserId'] = this._customerId;
//     data['Amount'] = this._amount;
//     data['PayType'] = this._payType;
//     data['TransId'] = this._transId;
//     data['OrderTime'] = this._orderTime;
//     data['ResultCode'] = this._resultCode;
//     data['ResultMessage'] = this._resultMessage;
//     return data;
//   }
// }

import 'package:lcp_mobile/feature/order/model/order_detail.dart';

class Order {
  List<OrderDetails> orderDetails;
  String orderId;
  String createdDate;
  String updatedDate;
  double totalAmount;
  int status;
  int discount;
  String residentId;
  String merchantStoreId;
  String payType;
  String transId;

  Order(
      {this.orderDetails,
      this.orderId,
      this.createdDate,
      this.updatedDate,
      this.totalAmount,
      this.status,
      this.discount,
      this.residentId,
      this.merchantStoreId,
      this.payType,
      this.transId});

  Order.fromJson(Map<String, dynamic> json) {
    if (json['OrderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['OrderDetails'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
    orderId = json['OrderId'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    totalAmount = json['TotalAmount'].toDouble();
    status = json['Status'];
    discount = json['Discount'];
    residentId = json['ResidentId'];
    merchantStoreId = json['MerchantStoreId'];
  }

  Order.fromMoMoResponse(Map<String, String> json) {
    orderId = json['orderId'];
    totalAmount = double.parse(json['amount']);
    payType = json['orderType'];
    transId = json['transId'];
    createdDate = json['responseTime'];
    // _resultCode = int.parse(json['resultCode']);
    // _resultMessage = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetails != null) {
      data['OrderDetails'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    data['OrderId'] = this.orderId;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['TotalAmount'] = this.totalAmount;
    data['Status'] = this.status;
    data['Discount'] = this.discount;
    data['ResidentId'] = this.residentId;
    data['MerchantStoreId'] = this.merchantStoreId;
    return data;
  }
}

// class OrderRequest {
//   List<Map<String, dynamic>> order;

//   OrderRequest({this.order});

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['UpdatedDate'] = this.order;
//     data['TotalAmount'] = this.totalAmount;
//     data['Status'] = this.status;
//     data['Discount'] = this.discount;
//     data['ResidentId'] = this.residentId;
//     data['MerchantStoreId'] = this.merchantStoreId;
//     return data;
//   }

// }

class OrderRequest {
  String productId;
  int quantity;
  num discount;

  OrderRequest({this.productId, this.quantity});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    return data;
  }
}
