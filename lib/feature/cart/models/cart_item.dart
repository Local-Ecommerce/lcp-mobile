import 'package:lcp_mobile/feature/discover/model/product.dart';

class CartItem {
  final int id;
  int quantity;
  Product product;

  CartItem({this.id, this.quantity, this.product});

  Map<String, dynamic> toMap() {
    return {'quantity': quantity, 'productId': product.productId};
  }
}
