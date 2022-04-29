import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/auth/register/register_bloc.dart';
import 'package:lcp_mobile/feature/feedback/model/feedback.dart';
import 'package:lcp_mobile/feature/feedback/repository/api_feedback_repository.dart';
import 'package:lcp_mobile/resources/api_strings.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

import '../../apartment/model/apartment.dart';
import '../../apartment/repository/api_apartment_repository.dart';

class FeedbackScreen extends StatefulWidget {
  final String productId;

  const FeedbackScreen({Key key, this.productId}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

RegisterBloc _registerBloc = RegisterBloc();

String _currentSelectedValue = '';

class _FeedbackScreenState extends State<FeedbackScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File _imageFile;
  List<File> _lstImage = [];
  List<String> _lstImageBase64 = [];
  ApiFeedBackRepository _apiFeedBackRepository;
  FeedbackRequest _feedbackRequest;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
      _lstImage.add(_imageFile);
      // String base64Image =
      //     "data:image/jpg;base64," + base64Encode(_imageFile.readAsBytesSync());
      String base64Image = base64Encode(_imageFile.readAsBytesSync());
      _lstImageBase64.add(base64Image);
      print(_lstImageBase64[0].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _apiFeedBackRepository = new ApiFeedBackRepository();
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
              // return Container(
              //     child: IconButton(
              //   icon: Icon(Icons.add_a_photo),
              //   onPressed: pickImage,
              // ));
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

  TextEditingController _contentController = TextEditingController();

  Widget buildContentField() {
    return TextFormField(
        controller: _contentController,
        minLines: 6,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (value) {
          if (value.isEmpty) {
            return 'Bạn hãy cho biết nội dung';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Nội dung',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        ));
  }

  Widget _buildSubmitButton() {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () async {
        _feedbackRequest.feedbackDetail = _contentController.text;
        _feedbackRequest.image = _lstImageBase64;
        _feedbackRequest.productId = widget.productId;
        if (await _apiFeedBackRepository.createFeedback(_feedbackRequest)) {
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
      },
      color: AppColors.indianRed,
      child: Text(
        ApiStrings.feedback,
        style: whiteText,
      ),
    );
  }
}
