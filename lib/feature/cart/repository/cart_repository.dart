

import 'package:lcp_mobile/feature/cart/models/cart.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';

abstract class CartRepository {

  Future<Cart> getCartItems();
  Future<void> updateQuantity(Product product, int value);
  Future<void> removeCartItem(CartItem cartItem);
}
