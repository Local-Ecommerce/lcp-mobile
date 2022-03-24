import 'dart:convert';

class SysCategory {
  String sysCategoryID;
  String sysCategoryName;
  int categoryLevel;
  String type;
  String belongTo;
  int status;
  List<dynamic> lstSysCategories;

  SysCategory(this.sysCategoryID, this.sysCategoryName, this.categoryLevel,
      this.belongTo, this.status);

  SysCategory.fromJson(Map<String, dynamic> json)
      : sysCategoryID = json['SystemCategoryId'],
        sysCategoryName = json['SysCategoryName'],
        type = json['Type'],
        categoryLevel = json['CategoryLevel'],
        belongTo = json['BelongTo'],
        status = json['Status'],
        lstSysCategories = json['InverseBelongToNavigation'];

  Map<String, dynamic> toMapSql() {
    return {
      'SystemCategoryId': sysCategoryID,
      'SysCategoryName': sysCategoryName,
      'categoryLevel': categoryLevel,
      'belongTo': belongTo,
      'status': status
    };
  }

  static String encode(List<SysCategory> categories) =>
      jsonEncode(categories.map((category) => category.toMapSql()).toList())
          .toString();

  @override
  String toString() =>
      'Syscategory{sysCategoryID: $sysCategoryID, sysCategoryName: $sysCategoryName, categoryLevel: $categoryLevel, lstSysCategories: $lstSysCategories}';
}
