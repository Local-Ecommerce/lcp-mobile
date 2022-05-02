import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';

import '../bloc/register_bloc.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

String _currentSelectedValue = '';

String _currentGenderValue = '';

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiApartmentRepository _apiApartmentRepository;
  UserData _userData;
  List<Apartment> listApartment = [];
  Apartment apartment;
  File image;

  getApartmentById(String id) async {
    listApartment = await _apiApartmentRepository.getApartmentById(id);
    setState(() {});
    return listApartment;
  }

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
    _apiApartmentRepository = new ApiApartmentRepository();
    getApartmentById(_userData.apartmentId);
  }

  Widget _buildAccountStatus(int status) {
    switch (status) {
      case 14001:
        return Text("Đã được xác nhận",
            style: TextStyle(color: AppColors.green, fontSize: 16));
        break;
      case 14003:
        return Text("Đã bị từ chối",
            style: TextStyle(color: AppColors.red, fontSize: 16));
        break;
      case 14004:
        return Text("Chưa xác thực",
            style: TextStyle(color: AppColors.darkGoldenRod, fontSize: 16));
        break;
      case 14005:
        return Text("Đã bị vô hiệu hóa",
            style: TextStyle(color: AppColors.orange, fontSize: 16));
        break;
      default:
        return Container();
    }
  }

  Widget buildButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(fontSize: 20),
        ),
        child: Row(
          children: [
            Icon(Icons.image_outlined),
            const SizedBox(width: 16),
            Text('Chọn ảnh đại diện')
          ],
        ),
        onPressed: () async {
          final image =
              await ImagePicker().getImage(source: ImageSource.gallery);
          if (image == null) return;

          File _imageFile = File(image.path);
          setState(() {
            this.image = _imageFile;
            String base64Image = base64Encode(_imageFile.readAsBytesSync());
            context
                .bloc<RegisterBloc>()
                .add(ImageChanged(profileImage: base64Image));
          });
        },
      );
    });
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
            R.strings.updateInfoTitle,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAccountStatus(_userData.status),
            Center(
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: image == null
                        ? _userData.profileImage.isNotEmpty
                            ? NetworkImage(_userData.profileImage)
                            : AssetImage(
                                "assets/images/default-user-image.png",
                              )
                        : FileImage(image),
                    fit: BoxFit.cover,
                    width: 128,
                    height: 128,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            buildButton(),
            SizedBox(
              height: 5,
            ),
            _ApartmentDropdown(
                listApartment: listApartment, userData: _userData),
            SizedBox(
              height: 10,
            ),
            _FullNameInput(data: _userData),
            SizedBox(
              height: 10,
            ),
            _DeliveryAddressInput(data: _userData),
            SizedBox(
              height: 10,
            ),
            _DobInput(data: _userData),
            SizedBox(
              height: 10,
            ),
            _GenderInput(data: _userData),
            SizedBox(
              height: 10,
            ),
            _PhoneNumberInput(data: _userData),
            SizedBox(
              height: 20,
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

class _ImageInput extends StatefulWidget {
  final File image;

  const _ImageInput({Key key, this.image}) : super(key: key);
  @override
  State<_ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<_ImageInput> {
  Future pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return;

    File _imageFile = File(image.path);
    setState(() {
      String base64Image = base64Encode(_imageFile.readAsBytesSync());
      print("Sauce là:");
      print(base64Image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(56),
        primary: Colors.white,
        onPrimary: Colors.black,
        textStyle: TextStyle(fontSize: 20),
      ),
      child: Row(
        children: [
          Icon(Icons.image_outlined),
          const SizedBox(width: 16),
          Text('Chọn ảnh đại diện')
        ],
      ),
      onPressed: pickImage,
    );
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
              Navigator.pushReplacementNamed(
                  context, RouteConstant.updateProfileRoute);
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
              context.bloc<RegisterBloc>().add(UpdateSubmitted());
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'))
        ],
      );
    },
  );
}

class _FullNameInput extends StatefulWidget {
  final UserData data;

  const _FullNameInput({Key key, @required this.data}) : super(key: key);

  @override
  State<_FullNameInput> createState() => _FullNameInputState();
}

class _FullNameInputState extends State<_FullNameInput> {
  final _fullNameController = TextEditingController();

  @override
  void initState() {
    if (widget.data.fullName != null) {
      context
          .bloc<RegisterBloc>()
          .add(FullnameChanged(fullname: widget.data.fullName));
      _fullNameController.text =
          widget.data.fullName != null ? widget.data.fullName : '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.fullname != current.fullname;
      },
      builder: (context, state) {
        return TextFormField(
          controller: _fullNameController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(FullnameChanged(fullname: value)),
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

class _DeliveryAddressInput extends StatefulWidget {
  final UserData data;

  const _DeliveryAddressInput({Key key, @required this.data}) : super(key: key);

  @override
  State<_DeliveryAddressInput> createState() => _DeliveryAddressInputState();
}

class _DeliveryAddressInputState extends State<_DeliveryAddressInput> {
  final _deliveryController = TextEditingController();

  @override
  void initState() {
    if (widget.data.deliveryAddress != null) {
      _deliveryController.text = widget.data.deliveryAddress;
      context.bloc<RegisterBloc>().add(
          DeliveryAddressChanged(deliveryAddress: widget.data.deliveryAddress));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.deliveryAddress != current.deliveryAddress;
      },
      builder: (context, state) {
        return TextFormField(
          controller: _deliveryController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(DeliveryAddressChanged(deliveryAddress: value)),
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

class _PhoneNumberInput extends StatefulWidget {
  final UserData data;

  const _PhoneNumberInput({Key key, @required this.data}) : super(key: key);
  @override
  State<_PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<_PhoneNumberInput> {
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    if (widget.data.phoneNumber != null) {
      _phoneNumberController.text = widget.data.phoneNumber;
      context
          .bloc<RegisterBloc>()
          .add(PhoneNumberChanged(phonenum: widget.data.phoneNumber));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) {
        return previous.phonenum != current.phonenum;
      },
      builder: (context, state) {
        return TextFormField(
          controller: _phoneNumberController,
          onChanged: (value) => context
              .bloc<RegisterBloc>()
              .add(PhoneNumberChanged(phonenum: value)),
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
                  ? 'Số Điện Thoại không được trống'
                  : null),
        );
      },
    );
  }
}

class _GenderInput extends StatefulWidget {
  final UserData data;

  const _GenderInput({Key key, @required this.data}) : super(key: key);

  @override
  State<_GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<_GenderInput> {
  final _genderController = TextEditingController();

  @override
  void initState() {
    if (widget.data.gender != null) {
      _currentGenderValue = widget.data.gender;
      context
          .bloc<RegisterBloc>()
          .add(GenderChanged(gender: widget.data.gender));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Giới tính',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          isEmpty: _currentSelectedValue.isEmpty,
          child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentGenderValue,
                hint: Text("Giới tính"),
                isDense: true,
                onChanged: (value) => {
                  context
                      .bloc<RegisterBloc>()
                      .add(GenderChanged(gender: value)),
                  setState(() {
                    _currentGenderValue = value;
                  })
                },
                items: genderList.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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

class _ApartmentDropdown extends StatefulWidget {
  final List<Apartment> listApartment;
  final UserData userData;

  const _ApartmentDropdown(
      {Key key, @required this.listApartment, @required this.userData})
      : super(key: key);
  @override
  __ApartmentDropdownState createState() => __ApartmentDropdownState();
}

class __ApartmentDropdownState extends State<_ApartmentDropdown> {
  @override
  void initState() {
    if (widget.userData.apartmentId != null) {
      _currentSelectedValue = widget.userData.apartmentId;
      context
          .bloc<RegisterBloc>()
          .add(ApartmentChanged(apartment: widget.userData.apartmentId));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Chung cư',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          isEmpty: _currentSelectedValue.isEmpty,
          child: BlocBuilder<RegisterBloc, RegisterState>(
              //stream: _registerBloc.combobox$,
              builder: (context, state) {
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
                      .add(ApartmentChanged(apartment: value)),
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

class _DobInput extends StatefulWidget {
  final UserData data;

  const _DobInput({Key key, @required this.data}) : super(key: key);

  @override
  __DobInputState createState() => __DobInputState();
}

class __DobInputState extends State<_DobInput> {
  var _dobController = TextEditingController();

  @override
  void initState() {
    if (widget.data.dob != null) {
      _dobController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.data.dob));
      context.bloc<RegisterBloc>().add(DobChanged(dob: widget.data.dob));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          controller: _dobController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Ngày sinh",
            border: OutlineInputBorder(),
            errorText: state.isDobInvalid != null && state.isDobInvalid
                ? 'Ngày sinh không hợp lệ!'
                : null,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          onTap: () => _selectDate(context, state),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, RegisterState state) async {
    DateTime selectedDate = DateTime.now();
    DateFormat _dateFormat = DateFormat("dd/MM/yyyy");
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = _dateFormat.format(selectedDate);
        context
            .bloc<RegisterBloc>()
            .add(DobChanged(dob: DateFormat("yyyy-MM-dd").format(picked)));
      });
    }
  }
}
