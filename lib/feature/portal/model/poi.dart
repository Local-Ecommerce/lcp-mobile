class POI {
  String poiId;
  String releaseDate;
  String title;
  String text;
  int status;
  String residentId;
  String apartmentId;
  String type;
  String images;

  POI(
      {this.poiId,
      this.releaseDate,
      this.title,
      this.text,
      this.status,
      this.residentId,
      this.apartmentId,
      this.type,
      this.images = ''});

  POI.fromJson(Map<String, dynamic> json) {
    poiId = json['PoiId'];
    releaseDate = json['ReleaseDate'];
    title = json['Title'];
    text = json['Text'];
    status = json['Status'];
    residentId = json['ResidentId'];
    apartmentId = json['ApartmentId'];
    type = json['Type'];
    images = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PoiId'] = this.poiId;
    data['ReleaseDate'] = this.releaseDate;
    data['Title'] = this.title;
    data['Text'] = this.text;
    data['Status'] = this.status;
    data['ResidentId'] = this.residentId;
    data['ApartmentId'] = this.apartmentId;
    data['Type'] = this.type;
    data['Image'] = this.images;
    return data;
  }
}
