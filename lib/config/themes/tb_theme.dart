import 'package:flutter/material.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

const int _tbPrimaryColorValue = 0xFF000000; // Presrite Black
const Color _tbPrimaryColor = Color(_tbPrimaryColorValue);
const Color _tbSecondaryColor = Color(0xFF555555); // Presrite Grey
const Color _tbDarkPrimaryColor = Color(0xFF333333);
const Color _tbGreyColor = Color(0xFFB2B3B5);

Color get appPrimaryColor => _tbPrimaryColor;


Typography tbTypography = Typography.material2018();

const tbMatBlack = MaterialColor(_tbPrimaryColorValue, <int, Color>{
  50: Color(0xFFE8E8E8),
  100: Color(0xFFC5C5C5),
  200: Color(0xFF9F9F9F),
  300: Color(0xFF787878),
  400: Color(0xFF5B5B5B),
  500: Color(0xFF3D3D3D),
  600: Color(0xFF373737),
  700: Color(0xFF2F2F2F),
  800: Color(0xFF272727),
  900: Color(0xFF000000),
});

const tbDarkMatBlack = tbMatBlack;

final ThemeData theme = ThemeData(primarySwatch: tbMatBlack);

ThemeData tbTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: tbMatBlack,
  colorScheme: theme.colorScheme.copyWith(
    primary: _tbPrimaryColor,
    secondary: _tbSecondaryColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: tbTypography.black,
  primaryTextTheme: tbTypography.black,
  typography: tbTypography,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    toolbarTextStyle: TextStyle(color: Colors.white),
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: _tbGreyColor,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeOpenPageTransitionsBuilder(),
      TargetPlatform.android: FadeOpenPageTransitionsBuilder(),
    },
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: tbDarkMatBlack,
  brightness: Brightness.dark,
);

ThemeData tbDarkTheme = ThemeData(
  primarySwatch: tbDarkMatBlack,
  brightness: Brightness.dark,
  colorScheme: darkTheme.colorScheme.copyWith(
    primary: _tbDarkPrimaryColor,
    secondary: _tbSecondaryColor,
  ),
  scaffoldBackgroundColor: const Color(0xFF0D1B2A),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: _tbSecondaryColor,
    unselectedItemColor: _tbGreyColor.withValues(alpha: 0.5),
  ),
);