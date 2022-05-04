import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

import '../../../apartment/model/apartment.dart';
import '../../../apartment/repository/api_apartment_repository.dart';
import '../bloc/register_bloc.dart';

class UpdateGoogleScreen extends StatefulWidget {
  @override
  _UpdateGoogleScreenState createState() => _UpdateGoogleScreenState();
}

String _currentSelectedValue = '';

class _UpdateGoogleScreenState extends State<UpdateGoogleScreen> {
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
            _SubmitUpdate(),
          ],
        ),
      ),
    );
  }

  void createSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SubmitUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: context.bloc<RegisterBloc>(),
        listener: (context, state) {
          print(state);
          if (state is UpdateFinishedState) {
            if (state.isSuccess) {
              String successMessage = 'Cập nhật thành công!';
              Navigator.pushReplacementNamed(context, RouteConstant.homeRoute);
              Fluttertoast.showToast(
                msg: successMessage, // message
                toastLength: Toast.LENGTH_LONG, // length
                gravity: ToastGravity.CENTER, // location
              );
            } else {
              String faildMessage = 'Cập nhật thất bại!';
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onPressed: () {
            _showDialog(context,
                "Cập nhật thông tin sẽ thay đổi trạng thái tài khoản thành chờ duyệt!");
          },
          color: AppColors.indianRed,
          child: Text(
            R.strings.updateInfoTitle,
            style: whiteText,
          ),
        ));
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
              context.bloc<RegisterBloc>().add(UpdateGoogleSubmitted());
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
        if (state is UpdateFinishedState) _deliveryAddressController.clear();
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
        if (state is UpdateFinishedState) _phoneNumberController.clear();
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
        if (state is UpdateFinishedState) _fullNameController.clear();
        return TextFormField(
          controller: _fullNameController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(FullnameChanged(fullname: value.trim())),
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
            if (state is UpdateFinishedState) _currentSelectedValue = '';
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
