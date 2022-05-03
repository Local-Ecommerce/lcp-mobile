import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/feature/auth/login/bloc/login_bloc.dart';
import 'package:lcp_mobile/feature/auth/register/bloc/register_bloc.dart';
import 'package:lcp_mobile/feature/profile/bloc/profile_bloc.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
              R.strings.changePassword,
              style: TextStyle(color: Colors.black),
            ),
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
          _PasswordInput(),
          SizedBox(
            height: 15.0,
          ),
          _NewPasswordInput(),
          SizedBox(
            height: 15.0,
          ),
          _ConfirmPasswordInput(),
          SizedBox(
            height: 15,
          ),
          _SubmitChangePassword(),
        ],
      ),
    );
  }
}

class _NewPasswordInput extends StatelessWidget {
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.newPassword != current.newPassword,
      builder: (context, state) {
        if (state is ChangePasswordFinishedState) {
          _passwordController.clear();
        }
        return TextFormField(
          controller: _passwordController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(NewPasswordChanged(newPassword: value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật Khẩu Mới',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(),
            errorText:
                state.isNewPasswordInvalid != null && state.isNewPasswordInvalid
                    ? 'Mật khẩu ít nhất 6 chữ số'
                    : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        if (state is ChangePasswordFinishedState) {
          _passwordController.clear();
        }
        return TextFormField(
          controller: _passwordController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(PasswordChanged(password: value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mật Khẩu',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(),
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

class _ConfirmPasswordInput extends StatelessWidget {
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        if (state is RegisFinishedState) _confirmPasswordController.clear();
        return TextFormField(
          controller: _confirmPasswordController,
          onChanged: (value) => context.bloc<RegisterBloc>().add(
              ConfirmNewPasswordChanged(confirm: value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác Nhận Mật Khẩu',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(),
            errorText: state.isConfirmPasswordInvalid != null &&
                    state.isConfirmPasswordInvalid
                ? 'Phải trùng khớp mật khẩu!'
                : null,
          ),
        );
      },
    );
  }
}

class _SubmitChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: context.bloc<RegisterBloc>(),
      listener: (context, state) {
        if (state is ChangePasswordFinishedState) {
          if (state.isSuccess) {
            context.bloc<ProfileBloc>().add(LogoutEvent());
            Fluttertoast.showToast(
              msg: "Thay đổi mật khẩu thành công!", // message
              toastLength: Toast.LENGTH_LONG, // length
              gravity: ToastGravity.CENTER, // location
            );
          } else {
            Fluttertoast.showToast(
              msg: "Vui lòng kiểm tra lại thông tin vừa nhập!", // message
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
          context.bloc<RegisterBloc>().add(ChangePassSubmitted());
        },
        color: AppColors.indianRed,
        child: Text(
          R.strings.changePassword,
          style: whiteText,
        ),
      ),
    );
  }
}
