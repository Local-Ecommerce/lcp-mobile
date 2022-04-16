import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lcp_mobile/resources/R.dart';

class CreditCard {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  MaterialColor color;
  String type;
  String image;

  CreditCard(
      {this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.isCvvFocused,
      this.color,
      this.type,
      this.image});
}

// List<CreditCard> creditCards = [
//   CreditCard(
//       cardNumber: "Thanh toán Momo",
//       expiryDate: "07/24",
//       cvvCode: "333",
//       cardHolderName: "Tran Quang Truong",
//       color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
//       image: R.icon.momo),
//   CreditCard(
//       cardNumber: "5500 0000 0000 0004",
//       expiryDate: "09/22",
//       cvvCode: "34",
//       cardHolderName: "Malayalam Sangam MN",
//       color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
//       image: R.icon.masterCard),
//   CreditCard(
//       cardNumber: "3400 0000 0000 009",
//       expiryDate: "05/15",
//       cvvCode: "65",
//       cardHolderName: "Gurmukhi MN",
//       color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
//       image: R.icon.amexCard),
// ];

List<CreditCard> creditCards = [
  CreditCard(
      cardNumber: "",
      expiryDate: "",
      cvvCode: "",
      type: "momo",
      cardHolderName: "Thanh toán Momo",
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      image: R.icon.momo),
  CreditCard(
      cardNumber: "",
      expiryDate: "",
      cvvCode: "",
      type: "cash",
      cardHolderName: "Thanh toán bằng tiền mặt",
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      image: R.icon.cash),
];
