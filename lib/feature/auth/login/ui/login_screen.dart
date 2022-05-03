import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/appbar.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';
import 'package:provider/provider.dart';

import '../../model/user_app.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserData _userData;

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(title: R.strings.loginTitle),
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
          _PasswordInput(),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.topRight,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                          context, RouteConstant.forgotPasswordRoute);
                    },
                  text: R.strings.forgotPassword,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 16))
            ])),
          ),
          SizedBox(
            height: 50,
          ),
          _SubmitLogin(userData: _userData),
          SizedBox(
            height: 18.0,
          ),
          Center(
            child: RichText(
                text: TextSpan(
                    text: 'Không có tài khoản/ ',
                    style: minorText,
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                              context, RouteConstant.registerRoute);
                        },
                      text: 'Đăng ký',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline))
                ])),
          ),
          SizedBox(
            height: 50.0,
          ),
          Center(child: Text('Hoặc đăng nhập với')),
          SizedBox(
            height: 30.0,
          ),
          _loginWithSocicalNetwork(),
        ],
      ),
    );
  }

  Widget _loginWithSocicalNetwork() {
    return Row(
      children: [
        Expanded(
            child: BlocListener(
          bloc: context.bloc<LoginBloc>(),
          listener: (context, state) {
            if (state is LoginFinishedState) {
              if (state.isSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteConstant.homeRoute, (r) => false);
              }
            }
          },
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: () {
              context.bloc<LoginBloc>().add(GoogleLogin());
            },
            color: AppColors.indianRed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.logo_google,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  R.strings.google,
                  style: whiteText,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void login() async {}

  void createSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}

class _EmailInput extends StatelessWidget {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        return previous.email != current.email;
      },
      builder: (context, state) {
        if (state is LoginFinishedState) {
          _emailController.clear();
        }
        return TextFormField(
          controller: _emailController,
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

class _PasswordInput extends StatelessWidget {
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        if (state is LoginFinishedState) {
          _passwordController.clear();
        }
        return TextFormField(
          controller: _passwordController,
          onChanged: (value) => context
              .bloc<LoginBloc>()
              .add(PasswordLoginChanged(password: value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật Khẩu',
            helperText: '',
            icon: const Icon(Icons.lock),
            errorText:
                state.isPasswordInvalid != null && state.isPasswordInvalid
                    ? 'Mật khẩu ít nhất 6 chữ số'
                    : null,
          ),
        );
      },
    );
  }
}

class _SubmitLogin extends StatefulWidget {
  final UserData userData;

  const _SubmitLogin({Key key, @required this.userData}) : super(key: key);

  @override
  State<_SubmitLogin> createState() => _SubmitLoginState();
}

class _SubmitLoginState extends State<_SubmitLogin> {
  bool isSuccess = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: context.bloc<LoginBloc>(),
        listener: (context, state) {
          if (state is LoginFinishedState) {
            if (state.isSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteConstant.homeRoute, (r) => false);
              Fluttertoast.showToast(
                msg: "Đăng nhập thành công!", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.CENTER, // location
              );
            } else {
              Fluttertoast.showToast(
                msg: "Đăng nhập thất bại!", // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.CENTER, // location
              );
            }
          } else if (state is UpdateInfoState) {
            if (state.isSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteConstant.updateProfileRoute, (r) => false);
            }
          }
        },
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            context.bloc<LoginBloc>().add(Submitted());
            setState(() {});
          },
          color: AppColors.indianRed,
          child: Text(
            R.strings.loginTitle,
            style: whiteText,
          ),
        ));
  }
}
