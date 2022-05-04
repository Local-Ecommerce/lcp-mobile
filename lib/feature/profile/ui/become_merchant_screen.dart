import 'package:flutter/material.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/app_theme.dart';

class BecomeMerchantScreen extends StatefulWidget {
  @override
  _BecomeMerchantScreenState createState() => _BecomeMerchantScreenState();
}

class _BecomeMerchantScreenState extends State<BecomeMerchantScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Center(
            child: Text(
              "Cách trở thành người bán hàng",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Bước 1: Truy cập vào đường link này trên máy tính của bạn https://localcommercialplatform-merchant.netlify.app/login.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Bước 2: Khách hàng sử dụng tài khoản hiện tại để đăng nhập vào trang web.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Bước 3: Sau khi đăng nhập vào trang web, 1 yêu cầu sẽ được gửi đến hệ thống của chúng tôi, và sau khi được duyệt khách hàng sẽ trở thành người bán hàng.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
