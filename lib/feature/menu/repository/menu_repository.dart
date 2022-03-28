import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/discover/repository/discover_repository.dart';

class FirebaseDiscoverRepository extends DiscoverRepository {
  final discoverCollection = FirebaseFirestore.instance.collection('products');

  @override
  Stream<List<Product>> getListProduct() {
    return discoverCollection.snapshots().map(_productListFromSnapshot);
  }

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    var result = snapshot.docs.map((doc) {
      return Product(
          productId: doc.id,
          images: List<String>.from(doc.data()['images']),
          color: doc.data()['colors'],
          productName: doc.data()['productName'],
          defaultPrice: doc.data()['defaultPrice'],
          isFavorite: doc.data()['isFavourite'],
          description: doc.data()['description'],
          briefDescription: doc.data()['briefDescription'],
          size: doc.data()['remainingSize'],
          weight: doc.data()['weight']);
    }).toList();
    return result;
  }

  @override
  Future<void> addListProduct(List<Product> products) async {
    products.forEach((element) {
      discoverCollection.add(element.toMap());
    });
  }
}
