import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/profile/bloc/profile_bloc.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

import 'register_bloc.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

RegisterBloc _registerBloc = RegisterBloc();

String _currentSelectedValue = '';

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiApartmentRepository _apiApartmentRepository;
  UserData _userData;
  List<Apartment> listApartment = [];
  Apartment apartment;

  getAllApartment() async {
    listApartment = await _apiApartmentRepository.getAllApartments();
    setState(() {});
    return listApartment;
  }

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
    _registerBloc.updateStreamData(_userData);
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
            _ApartmentDropdown(
                listApartment: listApartment, userData: _userData),
            SizedBox(
              height: 10,
            ),
            _FullNameInput(data: _userData),
            SizedBox(
              height: 10,
            ),
            _DobInput(),
            SizedBox(
              height: 10,
            ),
            _GenderInput(),
            SizedBox(
              height: 10,
            ),
            _PhoneNumberInput(),
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

class _SubmitUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.validateResult$,
      builder: (context, snapshot) => RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            elevation: 30,
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: LoaderPage())),
          );
          _registerBloc.updateProfile().then((success) {
            print(success);
            if (success) {
              //Close modal and pop to login
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteConstant.homeRoute, (r) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Update profile success"),
                ),
              );
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Update profile fail"),
                ),
              );
            }
          });
        },
        color: AppColors.indianRed,
        child: Text(
          R.strings.updateInfoTitle,
          style: whiteText,
        ),
      ),
    );
  }
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
    _fullNameController.text = widget.data.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.fullName$,
      builder: (context, snapshot) {
        return TextFormField(
          controller: _fullNameController,
          onChanged: _registerBloc.onFullNameChanged,
          decoration: InputDecoration(
            labelText: "Full Name",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            // errorText: snapshot.data != null && !snapshot.data
            //     ? 'Required field'
            //     : null,
          ),
        );
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.phoneNumber$,
      builder: (context, snapshot) {
        return TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onChanged: _registerBloc.onPhoneNumberChanged,
          decoration: InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              errorText: snapshot.data != null && !snapshot.data
                  ? 'Incorect Phone Number => Must be a Vietnamese\'s Phone Number'
                  : null),
        );
      },
    );
  }
}

class _GenderInput extends StatefulWidget {
  @override
  State<_GenderInput> createState() => _GenderInputState();
}

class _GenderInputState extends State<_GenderInput> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.gender$,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: _registerBloc.onGenderChanged,
          decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              errorText: snapshot.data != null && !snapshot.data
                  ? 'Required field'
                  : null),
        );
      },
    );
  }
}

class _DobInput extends StatefulWidget {
  @override
  __DobInputState createState() => __DobInputState();
}

class __DobInputState extends State<_DobInput> {
  var _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.dob$,
      builder: (context, snapshot) {
        return TextFormField(
          controller: _dobController,
          onChanged: _registerBloc.onDobChanged,
          readOnly: true,
          decoration: InputDecoration(
            labelText: R.strings.dob,
            border: OutlineInputBorder(),
            errorText: snapshot.data != null && !snapshot.data
                ? 'Required field'
                : null,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          onTap: () => _selectDate(context),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateFormat _dateFormat = DateFormat("dd/MM/yyyy");
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      _registerBloc.onDobChanged(DateFormat("MM/dd/yyyy").format(picked));
      setState(() {
        selectedDate = picked;
        debugPrint('selectedDate: $selectedDate');
        _dobController.text = _dateFormat.format(selectedDate);
      });
    }
  }
}

class _EmailInput extends StatefulWidget {
  final UserData userData;

  const _EmailInput({Key key, @required this.userData}) : super(key: key);

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _registerBloc.email$,
      builder: (context, snapshot) => TextFormField(
        onChanged: _registerBloc.onEmailChanged,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            errorText: snapshot.data != null && !snapshot.data
                ? 'Enter invalid email address'
                : null),
      ),
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
    super.initState();
    _currentSelectedValue = widget.userData.apartmentId;
    
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            //errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          isEmpty: _currentSelectedValue.isEmpty,
          child: StreamBuilder(
              stream: _registerBloc.combobox$,
              builder: (context, snapshot) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentSelectedValue.isNotEmpty
                        ? _currentSelectedValue
                        : null,
                    hint: Text("Apartment"),
                    isDense: true,
                    onChanged: (String newValue) {
                      _registerBloc.onComboboxChanged(newValue);
                      setState(() {
                        _currentSelectedValue = newValue;
                      });
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
