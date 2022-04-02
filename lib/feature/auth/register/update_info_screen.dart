import 'package:flutter/material.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/references/user_preference.dart';
import 'package:lcp_mobile/resources/R.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/route/route_constants.dart';
import 'package:lcp_mobile/widget/bottom_dialog.dart';
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
  List<Apartment> listApartment;
  Apartment apartment;

  getAllApartment() async {
    listApartment = await _apiApartmentRepository.getAllApartments();
  }

  getApartmentById(String id) async {
    apartment = await _apiApartmentRepository.getApartmentById(id);
  }

  @override
  void initState() {
    super.initState();
    _userData = UserPreferences.getUser();
    _apiApartmentRepository = new ApiApartmentRepository();
    getAllApartment();
    getApartmentById('AP001');
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
            //TODO need map all info to user update
            _ApartmentDropdown(listApartment:listApartment),
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

class _SubmitRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _registerBloc.register(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return LoaderPage();
        }

        return StreamBuilder<bool>(
          stream: _registerBloc.validateResult$,
          builder: (context, snapshot) => RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            onPressed: () async {
              if (snapshot.data != null && snapshot.data) {
                showModalBottomSheet(
                  context: context,
                  elevation: 30,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(child: LoaderPage())),
                );

                _registerBloc.register().then((success) {
                  if (success) {
                    Navigator.pushReplacementNamed(
                        context, RouteConstant.loginRoute);
                  }
                });
              } else {
                print('Update Info failed');
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Update Info failed"),
                ));
              }
            },
            color: AppColors.indianRed,
            child: Text(
              R.strings.updateInfoTitle,
              style: whiteText,
            ),
          ),
        );
      },
    );
  }
}

class _FullNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.fullName$,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: _registerBloc.onFullNameChanged,
          decoration: InputDecoration(
              labelText: 'FullName',
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

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.fullName$,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: _registerBloc.onFullNameChanged,
          decoration: InputDecoration(
              labelText: 'Phone number',
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

class _GenderInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _registerBloc.fullName$,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: _registerBloc.onFullNameChanged,
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

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        debugPrint('selectedDate: $selectedDate');
        _dobController.text = selectedDate.toString();
      });
    }
  }
}

class _EmailInput extends StatelessWidget {
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

  const _ApartmentDropdown({Key key, @required this.listApartment})
      : super(key: key);
  @override
  __ApartmentDropdownState createState() => __ApartmentDropdownState();

}

class __ApartmentDropdownState extends State<_ApartmentDropdown> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),

            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
          isEmpty: _currentSelectedValue == '',
          child: StreamBuilder(
              stream: _registerBloc.combobox$,
              builder: (context, snapshot) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentSelectedValue != ''
                        ? _currentSelectedValue
                        : null,
                    hint: Text("Apartment"),
                    isDense: true,
                    onChanged: (String newValue) {
                      _registerBloc.onComboboxChanged;
                      setState(() {
                        _currentSelectedValue = newValue;
                        state.didChange(newValue);
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
