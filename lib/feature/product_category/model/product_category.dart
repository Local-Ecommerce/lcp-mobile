import 'dart:convert';

class ProductCategory {
  final String productCategoryID;
  final String categoryName;
  final String residentID;
  final String productID;
  final String systemCategoryID;
  final int status;

  ProductCategory(this.productCategoryID, this.categoryName, this.residentID,
      this.productID, this.systemCategoryID, this.status);

  ProductCategory.fromJson(Map<String, dynamic> json)
      : productCategoryID = json['productCategoryID'],
        categoryName = json['categoryName'],
        residentID = json['residentID'],
        productID = json['productID'],
        systemCategoryID = json['systemCategoryID'],
        status = json['status'];

  Map<String, dynamic> toMapSql() {
    return {
      'productCategoryID': productCategoryID,
      'categoryName': categoryName,
      'residentID': residentID,
      'productID': productID,
      'systemCategoryID': systemCategoryID,
      'status': status
    };
  }

  static String encode(List<ProductCategory> categories) =>
      jsonEncode(categories.map((category) => category.toMapSql()).toList())
          .toString();
}
