class New {
  String newsId;
  String releaseDate;
  String title;
  String text;
  int status;
  String residentId;
  String apartmentId;
  String type;
  String image;

  New(
      {this.newsId,
      this.releaseDate,
      this.title,
      this.text,
      this.status,
      this.residentId,
      this.apartmentId,
      this.type,
      this.image = ''});

  New.fromJson(Map<String, dynamic> json) {
    newsId = json['NewsId'];
    releaseDate = json['ReleaseDate'];
    title = json['Title'];
    text = json['Text'];
    status = json['Status'];
    residentId = json['ResidentId'];
    apartmentId = json['ApartmentId'];
    type = json['Type'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NewsId'] = this.newsId;
    data['ReleaseDate'] = this.releaseDate;
    data['Title'] = this.title;
    data['Text'] = this.text;
    data['Status'] = this.status;
    data['ResidentId'] = this.residentId;
    data['ApartmentId'] = this.apartmentId;
    data['Type'] = this.type;
    data['Image'] = this.image;
    return data;
  }
}
