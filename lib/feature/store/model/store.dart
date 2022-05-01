class Store {
  String merchantStoreId;
  String storeName;
  String createdDate;
  String storeImage;
  int status;
  String residentId;
  String apartmentId;

  Store(
      {this.merchantStoreId,
      this.storeName,
      this.createdDate,
      this.storeImage,
      this.status,
      this.residentId,
      this.apartmentId});

  Store.fromJson(Map<String, dynamic> json) {
    merchantStoreId = json['MerchantStoreId'];
    storeName = json['StoreName'];
    createdDate = json['CreatedDate'];
    storeImage = json['StoreImage'];
    status = json['Status'];
    residentId = json['ResidentId'];
    apartmentId = json['ApartmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['MerchantStoreId'] = this.merchantStoreId;
    data['StoreName'] = this.storeName;
    data['CreatedDate'] = this.createdDate;
    data['StoreImage'] = this.storeImage;
    data['Status'] = this.status;
    data['ResidentId'] = this.residentId;
    data['ApartmentId'] = this.apartmentId;
    return data;
  }
}
