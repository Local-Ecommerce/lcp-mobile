import 'dart:async';

mixin ValidatorsTransformer {

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'(84|0[3|5|7|8|9])+([0-9]{8})\b'
  );

  static bool isValidPhone(String phoneNum) {
    return _phoneRegExp.hasMatch(phoneNum);
  }

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length > 4;
  }

  static bool isValidDate(DateTime date) {
    if (date.day.compareTo(DateTime.now().day) > 0) {
      return false;
    }
    return true;
  }

  final validateDate =
  StreamTransformer<DateTime, bool>.fromHandlers(handleData: (date, sink) {
    if (isValidDate(date)) {
      sink.add(true);
    } else {
      sink.add(false);
    }
  });

  final validatePhoneNum =
  StreamTransformer<String, bool>.fromHandlers(handleData: (phoneNum, sink) {
    if (isValidEmail(phoneNum)) {
      sink.add(true);
    } else {
      sink.add(false);
    }
  });

  final validateEmail =
  StreamTransformer<String, bool>.fromHandlers(handleData: (email, sink) {
    if (isValidEmail(email)) {
      sink.add(true);
    } else {
      sink.add(false);
    }
  });

  final validateRequireField =
  StreamTransformer<String, bool>.fromHandlers(handleData: (email, sink) {
    if (email.isNotEmpty) {
      sink.add(true);
    } else {
      sink.add(false);
    }
  });

  final validatePassword = StreamTransformer<String, bool>.fromHandlers(
      handleData: (password, sink) {
        if (isValidPassword(password)) {
          sink.add(true);
        } else {
          sink.add(false);
        }
      });
}
