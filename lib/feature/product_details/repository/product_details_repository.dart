import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lcp_mobile/db/db_provider.dart';
import 'package:lcp_mobile/feature/cart/models/cart_item.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/api_discover_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

class ProductDetailsRepository {
  Database db;
  final productCollection = FirebaseFirestore.instance.collection('products');
  ApiDiscoverRepository apiDiscoverRepository;

  ProductDetailsRepository() {
    db = DBProvider.instance.database;
    apiDiscoverRepository = new ApiDiscoverRepository();
  }

  Future<int> insertProductToCart(Product product) async {
    print("mapSQL");
    //productCodenull
    print(product.toMapSql());

    db.insert(
      DBProvider.TABLE_PRODUCT,
      product.toMapSql(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    var findCartItem = await db.query(DBProvider.TABLE_CART_ITEMS,
        where: "productId = ?", whereArgs: [product.productId]);

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
          where: "productId = ?", whereArgs: [product.productId]);
    }
  }

  Future<void> addToWishlist(Product product) {
    return productCollection
        .doc('${product.productId}')
        .update({'isFavourite': true});
  }

  Future<Product> getProductDetails(String id) async {
    // var result = await productCollection.doc(id).get();
    Product result = await apiDiscoverRepository.getProductDetail(id);
    return _productListFromSnapshot(result);
  }

  Product _productListFromSnapshot(Product doc) {
    return Product(
        productId: doc.productId,
        // images: List<String>.from(doc.data()['images']),
        // images: doc.data()['image'],
        // color: doc.data()['colors'],
        // productName: doc.data()['title'],
        // defaultPrice: doc.data()['price'],
        // isFavorite: doc.data()['isFavourite'],
        // description: doc.data()['description'],
        // briefDescription: doc.data()['briefDescription'],
        // size: doc.data()['remainingSize'],
        // weight: doc.data()['weight']);
        images: doc.images,
        color: doc.color,
        productName: doc.productName,
        defaultPrice: doc.defaultPrice,
        isFavorite: doc.isFavorite,
        description: doc.description,
        briefDescription: doc.briefDescription,
        size: doc.size,
        weight: doc.weight,
        children: doc.children);
  }

/*  Future<void> query() async{
    var result = await db.query(DBProvider.TABLE_PRODUCT);
    print('------------ $result');
    var result1 = await db.query(DBProvider.TABLE_CART_ITEMS);
    print('------------ $result1');
  }*/
}
