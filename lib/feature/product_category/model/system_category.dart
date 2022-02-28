import 'dart:convert';

class SysCategory {
  final String sysCategoryID;
  final String sysCategoryName;
  final int categoryLevel;
  final String belongTo;
  final int status;

  SysCategory(this.sysCategoryID, this.sysCategoryName, this.categoryLevel,
      this.belongTo, this.status);

  SysCategory.fromJson(Map<String, dynamic> json)
      : sysCategoryID = json['sysCategoryID'],
        sysCategoryName = json['sysCategoryName'],
        categoryLevel = json['categoryLevel'],
        belongTo = json['belongTo'],
        status = json['status'];

  Map<String, dynamic> toMapSql() {
    return {
      'sysCategoryID': sysCategoryID,
      'sysCategoryName': sysCategoryName,
      'categoryLevel': categoryLevel,
      'belongTo': belongTo,
      'status': status
    };
  }

  static String encode(List<SysCategory> categories) =>
      jsonEncode(categories.map((category) => category.toMapSql()).toList())
          .toString();
}
