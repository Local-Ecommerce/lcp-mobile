import 'dart:convert';

import 'package:lcp_mobile/feature/product_category/model/product_category.dart';
import 'package:lcp_mobile/resources/R.dart';

class ProductType {
  static const UPCOMMING = 'Upcoming';
  static const FEATURED = 'Featured';
  static const NEW = 'New';

  static List<String> values() => [UPCOMMING, FEATURED, NEW];
}

class Product {
  // final String id;
  // String productCode, productName, briefDescription, description;
  // List<String> images;
  // List<ProductCategory> productCategories;
  // String color;
  // double defaultPrice;
  // bool isFavourite;
  // double remainingSize, weight;
  // String productType;
  // int status;

  List<Product> inverseBelongToNavigation;
  // List<ProductCategory> productCategories;
  String systemCategoryId;
  String productId;
  String productCode;
  String productName;
  String briefDescription;
  String description;
  int defaultPrice;
  // int defaultPrice;
  String images;
  int status;
  // String size;
  // String color;
  double size;
  int color;
  int weight;
  // double weight;
  int isFavorite;

  Product(
      {this.inverseBelongToNavigation,
      this.systemCategoryId,
      this.productId,
      this.productCode,
      this.productName,
      this.briefDescription,
      this.description,
      this.defaultPrice,
      this.images,
      this.status,
      this.size,
      this.color,
      this.weight,
      this.isFavorite});

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'colors': color,
      'isFavourite': isFavorite,
      'productName': productName,
      'defaultPrice': defaultPrice,
      'description': description,
      'briefDescription': briefDescription,
      'remainingSize': size,
      'weight': weight,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        productId: map['product_id'],
        // images: List<String>.from(json.decode(map['images'])),
        images: map['Image'],
        color: map['Color'],
        productName: map['productName'],
        defaultPrice: map['defaultPrice'],
        // isFavorite: map['IsFavourite'] == 1 ? true : false,
        isFavorite: map['isFavorite'],
        description: map['Description'],
        briefDescription: map['BriefDescription'],
        size: map['remainingSize'],
        weight: map['weight']);
  }

  Map<String, dynamic> toMapSql() {
    return {
      'product_id': productId,
      'images': json.encode(images),
      'color': color,
      // 'isFavourite': isFavorite ? 1 : 0,
      'isFavorite': isFavorite,
      'productName': productName,
      'defaultPrice': defaultPrice,
      'description': description,
      'briefDescription': briefDescription,
      'remainingSize': size,
      'weight': weight,
    };
  }

  Product.fromJson(Map<String, dynamic> json) {
    if (json['InverseBelongToNavigation'] != null) {
      inverseBelongToNavigation = <Product>[];
      json['InverseBelongToNavigation'].forEach((v) {
        inverseBelongToNavigation.add(new Product.fromJson(v));
      });
    }
    // if (json['ProductCategories'] != null) {
    //   productCategories = <ProductCategory>[];
    //   json['ProductCategories'].forEach((v) {
    //     productCategories.add(new ProductCategory.fromJson(v));
    //   });
    // }
    systemCategoryId = json['SystemCategoryId'];
    productId = json['ProductId'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    briefDescription = json['BriefDescription'];
    description = json['Description'];
    defaultPrice = json['DefaultPrice'];
    images = json['Image'];
    status = json['Status'];
    size = json['Size'];
    color = json['Color'];
    weight = json['Weight'];
    isFavorite = json['IsFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inverseBelongToNavigation != null) {
      data['InverseBelongToNavigation'] =
          this.inverseBelongToNavigation.map((v) => v.toJson()).toList();
    }
    // if (this.productCategories != null) {
    //   data['ProductCategories'] =
    //       this.productCategories.map((v) => v.toJson()).toList();
    // }
    data['SystemCategoryId'] = this.systemCategoryId;
    data['ProductId'] = this.productId;
    data['ProductCode'] = this.productCode;
    data['ProductName'] = this.productName;
    data['BriefDescription'] = this.briefDescription;
    data['Description'] = this.description;
    data['DefaultPrice'] = this.defaultPrice;
    data['Image'] = this.images;
    data['Status'] = this.status;
    data['Size'] = this.size;
    data['Color'] = this.color;
    data['Weight'] = this.weight;
    data['IsFavorite'] = this.isFavorite;
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $productId, productName: $productName, briefDescription: $briefDescription, description: $description, images: $images, colors: $color, defaultPrice: $defaultPrice, isFavourite: $isFavorite, remainingSize: $size, weight: $weight}';
  }
}

// List<Product> demoProducts = [
//   Product(
//       images: [R.icon.snkr02],
//       colors: 0xFF82B1FF,
//       productName: 'Air-Max-273-Big-KIDS',
//       defaultPrice: 130,
//       description: 'description',
//       briefDescription: 'briefDescription',
//       remainingSize: 7.5,
//       weight: 0.25),
//   Product(
//       images: [R.icon.snkr02],
//       colors: 0xFF82B1FF,
//       productName: 'Air-Max-273-Big-KIDS',
//       defaultPrice: 130,
//       description: 'description',
//       briefDescription: 'briefDescription',
//       remainingSize: 7.5,
//       weight: 0.25),
//   Product(
//       images: [R.icon.snkr01],
//       colors: 0xFF82B1FF,
//       productName: 'Air-Max-273-Big-KIDS',
//       defaultPrice: 130,
//       description: 'description',
//       briefDescription: 'briefDescription',
//       remainingSize: 7.5,
//       weight: 0.25),
//   Product(
//       images: [R.icon.snkr03],
//       colors: 0xFF82B1FF,
//       productName: 'Air-Max-273-Big-KIDS',
//       defaultPrice: 130,
//       description: 'description',
//       briefDescription: 'briefDescription',
//       remainingSize: 7.5,
//       weight: 0.25),
// ];

List<String> categories = ['Nike', 'Adidas', 'Puma', 'Converse'];

List<double> size = [38, 39, 40, 41, 42];

List<double> weight1 = [0.25, 0.5, 0.75, 1.0];

List<double> weight2 = [1.0, 2.0, 3.0, 5.0];

List<double> weight3 = [3.0, 5.0, 7.0, 10.0];
