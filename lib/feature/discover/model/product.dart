import 'dart:convert';

import 'package:lcp_mobile/resources/R.dart';

class ProductType {
  static const UPCOMMING = 'Upcoming';
  static const FEATURED = 'Featured';
  static const NEW = 'New';

  static List<String> values() => [UPCOMMING, FEATURED, NEW];
}

class Product {
  final String id;
  String productCode, productName, briefDescription, description;
  List<String> images;
  int colors;
  double defaultPrice;
  String category;
  bool isFavourite;
  double remainingSize, weight;
  String productType;

  Product(
      {this.id,
      this.images,
      this.colors,
      this.isFavourite = false,
      this.productName,
      this.defaultPrice,
      this.description,
      this.briefDescription,
      this.remainingSize,
      this.weight});

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'colors': colors,
      'isFavourite': isFavourite,
      'productName': productName,
      'defaultPrice': defaultPrice,
      'description': description,
      'briefDescription': briefDescription,
      'remainingSize': remainingSize,
      'weight': weight,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['product_id'],
        images: List<String>.from(json.decode(map['images'])),
        colors: map['colors'],
        productName: map['productName'],
        defaultPrice: map['defaultPrice'],
        isFavourite: map['isFavourite'] == 1 ? true : false,
        description: map['description'],
        briefDescription: map['briefDescription'],
        remainingSize: map['remainingSize'],
        weight: map['weight']);
  }

  Map<String, dynamic> toMapSql() {
    return {
      'product_id': id,
      'images': json.encode(images),
      'colors': colors,
      'isFavourite': isFavourite ? 1 : 0,
      'productName': productName,
      'defaultPrice': defaultPrice,
      'category': category,
      'description': description,
      'briefDescription': briefDescription,
      'remainingSize': remainingSize,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, productName: $productName, briefDescription: $briefDescription, description: $description, images: $images, colors: $colors, defaultPrice: $defaultPrice, isFavourite: $isFavourite, remainingSize: $remainingSize, weight: $weight, productType: $productType}';
  }
}

List<Product> demoProducts = [
  Product(
      images: [R.icon.snkr02],
      colors: 0xFF82B1FF,
      productName: 'Air-Max-273-Big-KIDS',
      defaultPrice: 130,
      description: 'description',
      briefDescription: 'briefDescription',
      remainingSize: 7.5,
      weight: 0.25),
  Product(
      images: [R.icon.snkr02],
      colors: 0xFF82B1FF,
      productName: 'Air-Max-273-Big-KIDS',
      defaultPrice: 130,
      description: 'description',
      briefDescription: 'briefDescription',
      remainingSize: 7.5,
      weight: 0.25),
  Product(
      images: [R.icon.snkr01],
      colors: 0xFF82B1FF,
      productName: 'Air-Max-273-Big-KIDS',
      defaultPrice: 130,
      description: 'description',
      briefDescription: 'briefDescription',
      remainingSize: 7.5,
      weight: 0.25),
  Product(
      images: [R.icon.snkr03],
      colors: 0xFF82B1FF,
      productName: 'Air-Max-273-Big-KIDS',
      defaultPrice: 130,
      description: 'description',
      briefDescription: 'briefDescription',
      remainingSize: 7.5,
      weight: 0.25),
];

List<String> categories = ['Nike', 'Adidas', 'Puma', 'Converse'];

List<double> size = [38, 39, 40, 41, 42];

List<double> weight1 = [0.25, 0.5, 0.75, 1.0];

List<double> weight2 = [1.0, 2.0, 3.0, 5.0];

List<double> weight3 = [3.0, 5.0, 7.0, 10.0];
