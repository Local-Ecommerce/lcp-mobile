import 'package:lcp_mobile/db/db_provider.dart';
import 'package:lcp_mobile/feature/cart/models/cart.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'cart_repository.dart';

class CartRepositoryLocal extends CartRepository {
  Database _db;

  CartRepositoryLocal() {
    _db = DBProvider.instance.database;
  }

  @override
  Future<Cart> getCartItems() async {
    var res = await _db.rawQuery(""" 
      SELECT * FROM ${DBProvider.TABLE_CART_ITEMS} 
      JOIN ${DBProvider.TABLE_PRODUCT} 
      on ${DBProvider.TABLE_PRODUCT}.productId 
      = ${DBProvider.TABLE_CART_ITEMS}.productId
    """);
    var cartItems = List.generate(res.length, (index) {
      final data = res[index];
      return CartItem(
          id: data['cart_items_id'],
          quantity: data['quantity'],
          product: Product.fromMap(data));
    });
    return Cart(cartItems);
  }

  Future<void> updateQuantity(Product product, int value) async {
    _db.update(DBProvider.TABLE_CART_ITEMS, {"quantity": value},
        where: "productId = ?", whereArgs: [product.productId]);
  }

  Future<void> removeCartItem(CartItem cartItem) async {
    _db.delete(DBProvider.TABLE_CART_ITEMS,
        where: "cart_items_id = ?", whereArgs: [cartItem.id]);
  }
}
