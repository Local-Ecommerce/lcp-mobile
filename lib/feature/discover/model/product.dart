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
  List<Product> children;
  // List<ProductCategory> productCategories;
  String systemCategoryId;
  String productId;
  String productCode;
  String productName;
  String briefDescription;
  String description;
  num defaultPrice;
  String images;
  int status;
  String size;
  String color;
  String belongTo;
  num weight;
  int isFavorite;
  String residentId;
  int maxBuy;
  int quantity;

  Product(
      {this.children,
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
      this.isFavorite,
      this.belongTo,
      this.quantity,
      this.maxBuy,
      this.residentId});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'briefDescription': briefDescription,
      'description': description,
      'defaultPrice': defaultPrice,
      'images': images,
      'status': status,
      'size': size,
      'color': color,
      'weight': weight,
      // 'isFavorite': isFavorite,
      'belongTo': belongTo,
      'residentId': residentId,
      'relatedProducts': children,
      'maxBuy': maxBuy,
      'quantity': quantity,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      // images: List<String>.from(json.decode(map['images'])),
      // isFavorite: map['IsFavourite'] == 1 ? true : false,
      productId: map['productId'],
      productName: map['productName'],
      productCode: map['productCode'],
      briefDescription: map['briefDescription'],
      description: map['description'],
      defaultPrice: map['defaultPrice'],
      images: map['images'],
      status: map['status'],
      size: map['size'],
      color: map['color'],
      weight: map['weight'],
      // isFavorite: map['isFavorite'],
      belongTo: map['belongTo'],
      residentId: map['ResidentId'],
      children: map['relatedProducts'],
      maxBuy: map['maxBuy'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMapSql() {
    return {
      'productId': productId,
      'productName': productName,
      'productCode': productCode,
      'briefDescription': briefDescription,
      'description': description,
      'defaultPrice': defaultPrice,
      'images': images,
      'status': status,
      'size': size,
      'color': color,
      'weight': weight,
      // 'isFavorite': isFavorite,
      'belongTo': belongTo,
      'residentId': residentId,
      'maxBuy': maxBuy,

      // 'RelatedProducts': children,
    };
  }

  Product.fromJson(Map<String, dynamic> json) {
    if (json['RelatedProducts'] != null) {
      children = <Product>[];
      json['RelatedProducts'].forEach((v) {
        children.add(new Product.fromJson(v));
      });
    }

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
    // isFavorite = json['IsFavorite'];
    belongTo = json['belongTo'];
    residentId = json['ResidentId'];
    maxBuy = json['MaxBuy'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.children != null) {
      data['RelatedProducts'] = this.children.map((v) => v.toJson()).toList();
    }
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
    // data['IsFavorite'] = this.isFavorite;
    data['BelongTo'] = this.belongTo;
    data['ResidentId'] = this.residentId;
    data['quantity'] = this.quantity;
    data['maxBuy'] = this.maxBuy;
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $productId, productName: $productName, quantity: $quantity, maxBuy: $maxBuy ,briefDescription: $briefDescription, description: $description, images: $images, colors: $color, defaultPrice: $defaultPrice, isFavorite: $isFavorite, remainingSize: $size, weight: $weight}';
  }
}

class ProductRequest {
  BaseProduct baseProduct;
  String productId;
  String productCode;
  String productName;
  String briefDescription;
  String description;
  int defaultPrice;
  String image;
  int status;
  String createdDate;
  String updatedDate;
  String approveBy;
  String size;
  String color;
  double weight;
  int isFavorite;
  String belongTo;
  String residentId;
  String systemCategoryId;

  ProductRequest(
      {this.baseProduct,
      this.productId,
      this.productCode,
      this.productName,
      this.briefDescription,
      this.description,
      this.defaultPrice,
      this.image,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.approveBy,
      this.size,
      this.color,
      this.weight,
      this.isFavorite,
      this.belongTo,
      this.residentId,
      this.systemCategoryId});

  ProductRequest.fromJson(Map<String, dynamic> json) {
    baseProduct = json['BaseProduct'] != null
        ? new BaseProduct.fromJson(json['BaseProduct'])
        : null;
    productId = json['ProductId'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    briefDescription = json['BriefDescription'];
    description = json['Description'];
    defaultPrice = json['DefaultPrice'];
    image = json['Image'];
    status = json['Status'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    approveBy = json['ApproveBy'];
    size = json['Size'];
    color = json['Color'];
    weight = json['Weight'];
    // isFavorite = json['IsFavorite'];
    belongTo = json['BelongTo'];
    residentId = json['ResidentId'];
    systemCategoryId = json['SystemCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.baseProduct != null) {
      data['BaseProduct'] = this.baseProduct.toJson();
    }
    data['ProductId'] = this.productId;
    data['ProductCode'] = this.productCode;
    data['ProductName'] = this.productName;
    data['BriefDescription'] = this.briefDescription;
    data['Description'] = this.description;
    data['DefaultPrice'] = this.defaultPrice;
    data['Image'] = this.image;
    data['Status'] = this.status;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['ApproveBy'] = this.approveBy;
    data['Size'] = this.size;
    data['Color'] = this.color;
    data['Weight'] = this.weight;
    // data['IsFavorite'] = this.isFavorite;
    data['BelongTo'] = this.belongTo;
    data['ResidentId'] = this.residentId;
    data['SystemCategoryId'] = this.systemCategoryId;
    return data;
  }
}

class BaseProduct {
  String productId;
  String productCode;
  String productName;
  String briefDescription;
  String description;
  int defaultPrice;
  String image;
  int status;
  String createdDate;
  String updatedDate;
  String approveBy;
  Null size;
  Null color;
  int weight;
  int isFavorite;
  Null belongTo;
  String residentId;
  String systemCategoryId;

  BaseProduct(
      {this.productId,
      this.productCode,
      this.productName,
      this.briefDescription,
      this.description,
      this.defaultPrice,
      this.image,
      this.status,
      this.createdDate,
      this.updatedDate,
      this.approveBy,
      this.size,
      this.color,
      this.weight,
      this.isFavorite,
      this.belongTo,
      this.residentId,
      this.systemCategoryId});

  BaseProduct.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    briefDescription = json['BriefDescription'];
    description = json['Description'];
    defaultPrice = json['DefaultPrice'];
    image = json['Image'];
    status = json['Status'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    approveBy = json['ApproveBy'];
    size = json['Size'];
    color = json['Color'];
    weight = json['Weight'];
    // isFavorite = json['IsFavorite'];
    belongTo = json['BelongTo'];
    residentId = json['ResidentId'];
    systemCategoryId = json['SystemCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductId'] = this.productId;
    data['ProductCode'] = this.productCode;
    data['ProductName'] = this.productName;
    data['BriefDescription'] = this.briefDescription;
    data['Description'] = this.description;
    data['DefaultPrice'] = this.defaultPrice;
    data['Image'] = this.image;
    data['Status'] = this.status;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['ApproveBy'] = this.approveBy;
    data['Size'] = this.size;
    data['Color'] = this.color;
    data['Weight'] = this.weight;
    // data['IsFavorite'] = this.isFavorite;
    data['BelongTo'] = this.belongTo;
    data['ResidentId'] = this.residentId;
    data['SystemCategoryId'] = this.systemCategoryId;
    return data;
  }
}

List<String> categories = ['Nike', 'Adidas', 'Puma', 'Converse'];

List<double> size = [38, 39, 40, 41, 42];

List<double> weight1 = [0.25, 0.5, 0.75, 1.0];

List<double> weight2 = [1.0, 2.0, 3.0, 5.0];

List<double> weight3 = [3.0, 5.0, 7.0, 10.0];
