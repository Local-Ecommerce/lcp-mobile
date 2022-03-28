import 'dart:convert';

import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/product_category/model/product_category.dart';
import 'package:lcp_mobile/resources/R.dart';

class MenuType {
  static const HOT = 'Popular';
  static const NEW = 'New';

  static List<String> values() => [HOT, NEW];
}

class Menu {
  List<Product> productInMenus;
  String menuId;
  String menuName;
  String menuDescription;
  String timeStart;
  String timeEnd;
  String createdDate;
  String updatedDate;
  int status;
  String repeatDate;
  String merchantStoreId;

  Menu(
      {this.productInMenus,
      this.menuId,
      this.menuName,
      this.menuDescription,
      this.timeStart,
      this.timeEnd,
      this.createdDate,
      this.updatedDate,
      this.status,
      this.repeatDate,
      this.merchantStoreId});

  Menu.fromJson(Map<String, dynamic> json) {
    json['ProductInMenus'].forEach((v) {
      productInMenus.add(new Product.fromJson(v));
    });
    menuId = json['MenuId'];
    menuName = json['MenuName'];
    menuDescription = json['MenuDescription'];
    timeStart = json['TimeStart'];
    timeEnd = json['TimeEnd'];
    createdDate = json['CreatedDate'];
    updatedDate = json['UpdatedDate'];
    status = json['Status'];
    repeatDate = json['RepeatDate'];
    merchantStoreId = json['MerchantStoreId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productInMenus != null) {
      data['ProductInMenus'] =
          this.productInMenus.map((v) => v.toJson()).toList();
    }
    data['MenuId'] = this.menuId;
    data['MenuName'] = this.menuName;
    data['MenuDescription'] = this.menuDescription;
    data['TimeStart'] = this.timeStart;
    data['TimeEnd'] = this.timeEnd;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedDate'] = this.updatedDate;
    data['Status'] = this.status;
    data['RepeatDate'] = this.repeatDate;
    data['MerchantStoreId'] = this.merchantStoreId;
    return data;
  }

  @override
  String toString() {
    return 'Menu{id: $menuId, menuName: $menuName, menuDescription: $menuDescription, timeStart: $timeStart, timeEnd: $timeEnd, RepeatDate: $repeatDate}';
  }
}
