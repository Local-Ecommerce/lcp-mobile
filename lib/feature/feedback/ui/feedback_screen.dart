import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/feature/auth/register/bloc/register_bloc.dart';
import 'package:lcp_mobile/feature/cart/repository/api_cart_repository.dart';
import 'package:lcp_mobile/feature/discover/model/product.dart';
import 'package:lcp_mobile/feature/feedback/model/feedback.dart';
import 'package:lcp_mobile/feature/feedback/repository/api_feedback_repository.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/resources.dart';

class FeedbackScreen extends StatefulWidget {
  final dynamic product;

  const FeedbackScreen({Key key, this.product}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _imageFile;
  Product product;
  List<File> _lstImage = [];
  List<String> _lstImageBase64 = [];
  String name;
  ApiDiscoverRepository _apiDiscoverRepository;
  ApiFeedBackRepository _apiFeedBackRepository;
  FeedbackRequest _feedbackRequest;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      pickedFile.path != null
          ? _imageFile = File(pickedFile.path)
          : _imageFile = null;
      _lstImage.add(_imageFile);
      String base64Image = base64Encode(_imageFile.readAsBytesSync());
      _lstImageBase64.add(base64Image);
      print(_lstImageBase64[0].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _apiFeedBackRepository = new ApiFeedBackRepository();
    _apiDiscoverRepository = new ApiDiscoverRepository();
    _feedbackRequest = new FeedbackRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Center(
          child: Text(
            "Báo cáo đơn hàng",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildImageList(context),
            SizedBox(
              height: 10,
            ),
            buildProductName(context),
            SizedBox(
              height: 10,
            ),
            buildContentField(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Container(padding: EdgeInsets.all(14.0), child: _buildSubmitButton()),
    );
  }

  void createSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildImageList(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height * 0.3,
        width: width * 0.9,
        child: GridView.builder(
            itemCount: _lstImage.length + 1,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                          icon: Icon(Icons.add_a_photo), onPressed: pickImage))
                  : Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(_lstImage[index - 1]),
                              fit: BoxFit.cover)));
            }),
      ),
    );
  }

  Widget buildProductName(BuildContext context) {
    var _theme = Theme.of(context);
    return TextFormField(
      minLines: 3,
      maxLines: null,
      initialValue:  widget.product["ProductName"],
      style: _theme.textTheme.bodyText1.copyWith(
          fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 17),
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Tên sản phẩm",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(),
      ),
    );
  }

  TextEditingController _contentController = TextEditingController();

  Widget buildContentField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        controller: _contentController,
        minLines: 6,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (value) =>
            context.bloc<LoginBloc>().add(FeedBackChanged(feedback: value)),
        decoration: InputDecoration(
          labelText: 'Nội dung',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          errorText: state.isFeedBackInvalid != null && state.isFeedBackInvalid
              ? 'Báo cáo không được để trống'
              : null,
        ),
      );
    });
  }

  Widget _buildSubmitButton() {
    return BlocListener(
      bloc: context.bloc<LoginBloc>(),
      listener: (context, state) {
        if (state is FeedBackFinishedState) {
          if (state.isSuccess) {
            Fluttertoast.showToast(
              msg: "Gửi báo cáo thành công", // message
              toastLength: Toast.LENGTH_LONG, // length
              gravity: ToastGravity.CENTER, // location
            );
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(
              msg: "Gửi báo cáo thất bại", // message
              toastLength: Toast.LENGTH_LONG, // length
              gravity: ToastGravity.CENTER, // location
            );
          }
        }
      },
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          context
              .bloc<LoginBloc>()
              .add(ImageFeedBackChanged(images: _lstImageBase64));
          context
              .bloc<LoginBloc>()
              .add(ProductIdChanged(productId: widget.product["ProductId"]));
          setState(() {
            context.bloc<LoginBloc>().add(FeedBackSubmitted());
          });
        },
        color: AppColors.indianRed,
        child: Text(
          ApiStrings.feedback,
          style: whiteText,
        ),
      ),
    );
  }
}
