import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lcp_mobile/db/db_provider.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ProductDetailsRepository {
  Database db;
  final productCollection = FirebaseFirestore.instance.collection('products');

  ProductDetailsRepository() {
    db = DBProvider.instance.database;
  }

  Future<int> insertProductToCart(Product product) async {
    db.insert(
      DBProvider.TABLE_PRODUCT,
      product.toMapSql(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    var findCartItem = await db.query(DBProvider.TABLE_CART_ITEMS,
        where: "product_id = ?", whereArgs: [product.id]);

    if (findCartItem.isEmpty) {
      var cartItem = CartItem(product: product, quantity: 1).toMap();

      return db.insert(
        DBProvider.TABLE_CART_ITEMS,
        cartItem,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      var currentQuantity = 0;
      findCartItem.forEach((element) {
        currentQuantity = element['quantity'];
      });
      return db.update(
          DBProvider.TABLE_CART_ITEMS, {"quantity": currentQuantity + 1},
          where: "product_id = ?", whereArgs: [product.id]);
    }
  }

  Future<void> addToWishlist(Product product) {
    return productCollection.doc('${product.id}').update({'isFavourite': true});
  }

  Future<Product> getProductDetails(String id) async {
    var result = await productCollection.doc(id).get();
    return _productListFromSnapshot(result);
  }

  Product _productListFromSnapshot(DocumentSnapshot doc) {
    return Product(
        id: doc.id,
        images: List<String>.from(doc.data()['images']),
        colors: doc.data()['colors'],
        productName: doc.data()['title'],
        defaultPrice: doc.data()['price'],
        isFavourite: doc.data()['isFavourite'],
        description: doc.data()['description'],
        briefDescription: doc.data()['briefDescription'],
        remainingSize: doc.data()['remainingSize'],
        weight: doc.data()['remainingSize']);
  }

/*  Future<void> query() async{
    var result = await db.query(DBProvider.TABLE_PRODUCT);
    print('------------ $result');
    var result1 = await db.query(DBProvider.TABLE_CART_ITEMS);
    print('------------ $result1');
  }*/
}
