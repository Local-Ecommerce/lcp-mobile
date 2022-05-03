import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/resources/resources.dart';

import '../../../apartment/model/apartment.dart';
import '../../../apartment/repository/api_apartment_repository.dart';
import '../bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

String _currentSelectedValue = '';

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiApartmentRepository _apiApartmentRepository;

  List<Apartment> listApartment = [];

  getAllApartment() async {
    listApartment = await _apiApartmentRepository.getAllApartments();
    setState(() {});
    return listApartment;
  }

  @override
  void initState() {
    super.initState();
    _apiApartmentRepository = new ApiApartmentRepository();
    getAllApartment();
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
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Center(
            child: Text(
              R.strings.registerTitle,
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
            _EmailInput(),
            SizedBox(
              height: 10,
            ),
            _PasswordInput(),
            SizedBox(
              height: 10,
            ),
            _ConfirmPasswordInput(),
            SizedBox(
              height: 10,
            ),
            _FullNameInput(),
            SizedBox(
              height: 10,
            ),
            _PhoneNumberInput(),
            SizedBox(
              height: 10,
            ),
            _ApartmentDropdown(listApartment: listApartment),
            SizedBox(
              height: 10,
            ),
            _DeliveryAddressInput(),
            SizedBox(
              height: 10,
            ),
            _SubmitRegister(),
          ],
        ),
      ),
    );
  }

  void createSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SubmitRegister extends StatefulWidget {
  @override
  State<_SubmitRegister> createState() => _SubmitRegisterState();
}

class _SubmitRegisterState extends State<_SubmitRegister> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: context.bloc<RegisterBloc>(),
      listener: (context, state) {
        if (state is RegisFinishedState) {
          if (state.isSuccess) {
            String successMessage = 'Đăng ký thành công!';
            Navigator.of(context)..pop();
            Fluttertoast.showToast(
              msg: successMessage, // message
              toastLength: Toast.LENGTH_LONG, // length
              gravity: ToastGravity.CENTER, // location
            );
          } else {
            String faildMessage = 'Đăng ký thất bại!';
            Fluttertoast.showToast(
              msg: faildMessage, // message
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
          setState(() {
            context.bloc<RegisterBloc>().add(Submitted());
          });
        },
        color: AppColors.indianRed,
        child: Text(
          R.strings.registerTitle,
          style: whiteText,
        ),
      ),
    );
  }
}

Future<void> _showDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _DeliveryAddressInput extends StatelessWidget {
  final _deliveryAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.deliveryAddress != current.deliveryAddress;
      },
      builder: (context, state) {
        if (state is RegisFinishedState) _deliveryAddressController.clear();
        return TextFormField(
          controller: _deliveryAddressController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(DeliveryAddressChanged(deliveryAddress: value.trim())),
          decoration: InputDecoration(
              labelText: 'Địa chỉ',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(),
              errorText: state.isDeliveryAddressInvalid != null &&
                      state.isDeliveryAddressInvalid
                  ? 'Địa chỉ không được trống'
                  : null),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  final _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.phonenum != current.phonenum;
      },
      builder: (context, state) {
        if (state is RegisFinishedState) _phoneNumberController.clear();
        return TextFormField(
          controller: _phoneNumberController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(PhoneNumberChanged(phonenum: value.trim())),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
              labelText: 'Số Điện Thoại',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(),
              errorText: state.isPhoneNumberInvalid != null &&
                      state.isPhoneNumberInvalid
                  ? 'Số điện thoại không hợp lệ!'
                  : null),
        );
      },
    );
  }
}

class _FullNameInput extends StatelessWidget {
  final _fullNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.fullname != current.fullname;
      },
      builder: (context, state) {
        if (state is RegisFinishedState) _fullNameController.clear();
        return TextFormField(
          controller: _fullNameController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(FullnameChanged(fullname: value.trim())),
          keyboardType: TextInputType.name,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
          ],
          decoration: InputDecoration(
              labelText: 'Họ và Tên',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(),
              errorText:
                  state.isFullNameInvalid != null && state.isFullNameInvalid
                      ? 'Tên không được trống'
                      : null),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.email != current.email;
      },
      builder: (context, state) {
        if (state is RegisFinishedState) {
          _emailController.clear();
        }
        return TextFormField(
          controller: _emailController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(EmailChanged(email: value.trim())),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(),
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
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        if (state is RegisFinishedState) {
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
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(ConFirmPasswordRegisterChanged(confirmPassword: value)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Xác nhận mật khẩu',
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

class _ApartmentDropdown extends StatefulWidget {
  final List<Apartment> listApartment;
  const _ApartmentDropdown({Key key, @required this.listApartment})
      : super(key: key);
  @override
  __ApartmentDropdownState createState() => __ApartmentDropdownState();
}

class __ApartmentDropdownState extends State<_ApartmentDropdown> {
  @override
  void initState() {
    super.initState();
    _currentSelectedValue = '';
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
          ),
          isEmpty: _currentSelectedValue.isEmpty,
          child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
            if (state is RegisFinishedState) _currentSelectedValue = '';
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentSelectedValue.isNotEmpty
                    ? _currentSelectedValue
                    : null,
                hint: Text("Chung Cư"),
                isDense: true,
                onChanged: (value) => {
                  context
                      .bloc<RegisterBloc>()
                      .add(ApartmentChanged(apartment: value.trim())),
                  setState(() {
                    _currentSelectedValue = value;
                  })
                },
                items: widget.listApartment.map((value) {
                  return DropdownMenuItem<String>(
                    value: value.apartmentId,
                    child: Text(value.apartmentName),
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }
}
