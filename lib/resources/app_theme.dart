import 'package:flutter/material.dart';

import 'colors.dart';

const minorText = TextStyle(
  color: Color.fromRGBO(128, 128, 128, 1),
  fontSize: 16,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);

const minorTextBold = TextStyle(
  color: Color.fromRGBO(128, 128, 128, 1),
  fontSize: 16,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const smallText = TextStyle(
  color: Colors.grey,
  fontSize: 12,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);

const minorTextWhite = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);

const headingText = TextStyle(
  color: AppColors.black,
  fontSize: 24,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const headingTextWhite = TextStyle(
  color: AppColors.white,
  fontSize: 24,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const headingText1 = TextStyle(
  color: AppColors.black,
  fontSize: 30,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.bold,
);

const whiteText = TextStyle(
  color: AppColors.white,
  fontSize: 16,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);

const boldTextMedium = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

const textMedium = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
const textMediumWhite =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);

class AppSizes {
  static const int splashScreenTitleFontSize = 48;
  static const int titleFontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
  static const double textFieldRadius = 4.0;
  static const EdgeInsets bottomSheetPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const app_bar_size = 56.0;
  static const app_bar_expanded_size = 180.0;
  static const tile_width = 148.0;
  static const tile_height = 276.0;
}
