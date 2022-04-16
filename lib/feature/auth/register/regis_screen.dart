import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcp_mobile/resources/resources.dart';
import 'package:lcp_mobile/widget/loader_widget.dart';

import '../../apartment/model/apartment.dart';
import '../../apartment/repository/api_apartment_repository.dart';
import 'register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

RegisterBloc _registerBloc = RegisterBloc();

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
        title: Center(
          child: Text(
            R.strings.registerTitle,
            style: TextStyle(color: Colors.black),
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
            _ApartmentDropdown(listApartment: listApartment),
            SizedBox(
              height: 10,
            ),
            _FullNameInput(),
            SizedBox(
              height: 10,
            ),
            _DobInput(),
            SizedBox(
              height: 10,
            ),
            _EmailInput(),
            SizedBox(
              height: 10,
            ),
            _PasswordInput(),
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
    return StreamBuilder<bool>(
      stream: _registerBloc.validateResult$,
      builder: (context, snapshot) => RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
            _registerBloc.register().then((value) {
              if (value) {
                //Close modal and pop to login
                Navigator.of(context)..pop()..pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Register success"),
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Register failed"),
                  ),
                );
              }
            });
          }
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _registerBloc.password$,
      builder: (context, snapshot) => TextFormField(
        onChanged: _registerBloc.onPasswordChanged,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            errorText: snapshot.data != null && !snapshot.data
                ? 'Invalid password, please enter more than 4 characters'
                : null),
      ),
    );
  }

  // class _ConfirmPasswordInput extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder(
  //     stream: _registerBloc.password$,
  //     builder: (context, snapshot) => TextFormField(
  //       onChanged: _registerBloc.onPasswordChanged,
  //       obscureText: true,
  //       keyboardType: TextInputType.visiblePassword,
  //       decoration: InputDecoration(
  //           labelText: 'Confirm Password',
  //           border: OutlineInputBorder(),
  //           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
  //           errorText: snapshot.data != null && !snapshot.data
  //               ? 'Invalid password, please enter more than 4 characters'
  //               : null),
  //     ),
  //   );
  // }
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
          child: StreamBuilder<String>(
              stream: _registerBloc.combobox$,
              builder: (context, snapshot) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: snapshot.hasData ? snapshot.data : null,
                    hint: Text("Apartment"),
                    isDense: true,
                    onChanged: _registerBloc.onComboboxChanged,
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
