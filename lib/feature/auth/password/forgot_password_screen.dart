import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/resources/resources.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
        title: Center(
          child: Text(
            R.strings.forgotPassword,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: bodyContent(),
    );
  }

  Widget bodyContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 30.0,
          ),
          _EmailInput(),
          SizedBox(
            height: 15.0,
          ),
          _SubmitForgotPassword(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        return previous.email != current.email;
      },
      builder: (context, state) {
        return TextFormField(
          initialValue: state.email,
          onChanged: (value) =>
              context.bloc<LoginBloc>().add(EmailLoginChanged(email: value.trim())),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'Email',
              helperText: '',
              icon: const Icon(Icons.email),
              errorText: state.isEmailInvalid != null && state.isEmailInvalid
                  ? 'Email không hợp lệ'
                  : null),
        );
      },
    );
  }
}

class _SubmitForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: context.bloc<LoginBloc>(),
      listener: (context, state) {
        if (state is ForgotFinishedState) {
          if (state.isSuccess) {
            Navigator.of(context)
              ..pop()
              ..pop();
            Fluttertoast.showToast(
              msg:
                  "Đã gửi 1 thông báo đổi mật khẩu tới email của bạn!", // message
              toastLength: Toast.LENGTH_LONG, // length
              gravity: ToastGravity.CENTER, // location
            );
          } else {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "Vui lòng kiểm tra lại thông tin đã nhập!", // message
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
          context.bloc<LoginBloc>().add(ResetPassSubmitted());
        },
        color: AppColors.indianRed,
        child: Text(
          R.strings.forgotPassword,
          style: whiteText,
        ),
      ),
    );
  }
}


