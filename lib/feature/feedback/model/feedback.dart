class FeedbackRequest {
  String feedbackDetail;
  List<String> image;
  String productId;

  FeedbackRequest({this.feedbackDetail, this.image, this.productId});

  FeedbackRequest.fromJson(Map<String, dynamic> json) {
    feedbackDetail = json['feedbackDetail'];
    image = json['image'].cast<String>();
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedbackDetail'] = this.feedbackDetail;
    data['image'] = this.image;
    data['productId'] = this.productId;
    return data;
  }
}
