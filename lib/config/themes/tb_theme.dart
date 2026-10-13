import 'package:flutter/material.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

const int _tbPrimaryColorValue = 0xFF0580C7; // ITHENA Blue
const Color _tbPrimaryColor = Color(_tbPrimaryColorValue);
const Color _tbSecondaryColor = Color(0xFF04568A); // ITHENA Deep Blue
const Color _tbDarkPrimaryColor = Color(0xFF4FA8DC); // Lighter blue for dark mode
const Color _tbGreyColor = Color(0xFFC3C6C9); // ITHENA Grey
const Color _tbDarkGreyColor = Color(0xFF6E757C); // Darker ITHENA Grey for text on white

Color get appPrimaryColor => _tbPrimaryColor;


Typography tbTypography = Typography.material2018();

const tbMatBlue = MaterialColor(_tbPrimaryColorValue, <int, Color>{
  50: Color(0xFFE1F0F8),
  100: Color(0xFFB4D9EE),
  200: Color(0xFF82C0E3),
  300: Color(0xFF50A6D8),
  400: Color(0xFF2B93CF),
  500: _tbPrimaryColor,
  600: Color(0xFF0478C1),
  700: Color(0xFF046DBA),
  800: Color(0xFF0363B2),
  900: Color(0xFF0250A5),
});

const tbDarkMatBlue = tbMatBlue;

final ThemeData theme = ThemeData(primarySwatch: tbMatBlue);

ThemeData tbTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: tbMatBlue,
  colorScheme: theme.colorScheme.copyWith(
    primary: _tbPrimaryColor,
    secondary: _tbSecondaryColor,
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: tbTypography.black,
  primaryTextTheme: tbTypography.black,
  typography: tbTypography,

  appBarTheme: const AppBarTheme(
    backgroundColor: _tbPrimaryColor,
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
    backgroundColor: Colors.white,
    selectedItemColor: _tbPrimaryColor,
    unselectedItemColor: _tbDarkGreyColor,
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
  primarySwatch: tbDarkMatBlue,
  brightness: Brightness.dark,
);

ThemeData tbDarkTheme = ThemeData(
  primarySwatch: tbDarkMatBlue,
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