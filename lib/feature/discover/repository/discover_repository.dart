import 'package:lcp_mobile/feature/discover/model/product.dart';

abstract class DiscoverRepository {

  Stream<List<Product>> getListProduct();
  Future<void> addListProduct(List<Product> products);

}
