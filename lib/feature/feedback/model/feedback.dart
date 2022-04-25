class FeedbackRequest {
  String feedbackDetail;
  String feedbackDate;
  List<String> image;
  String productId;

  FeedbackRequest(
      {this.feedbackDetail, this.feedbackDate, this.image, this.productId});

  FeedbackRequest.fromJson(Map<String, dynamic> json) {
    feedbackDetail = json['feedbackDetail'];
    feedbackDate = json['feedbackDate'];
    image = json['image'].cast<String>();
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedbackDetail'] = this.feedbackDetail;
    data['feedbackDate'] = this.feedbackDate;
    data['image'] = this.image;
    data['productId'] = this.productId;
    return data;
  }
}
