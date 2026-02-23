import 'package:flutter/material.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

const int _tbPrimaryColorValue = 0xFF113262; // UCA Dark Blue
const Color _tbPrimaryColor = Color(_tbPrimaryColorValue);
const Color _tbSecondaryColor = Color(0xFF7EA0C3); // UCA Light Blue
const Color _tbDarkPrimaryColor = Color(0xFF7EA0C3); // Slightly lighter for dark mode
const Color _tbGreyColor = Color(0xFFB2B3B5);

Color get appPrimaryColor => _tbPrimaryColor;

const int _tbTextColorValue = 0xFF1F1F1F;
const Color _tbTextColor = Color(_tbTextColorValue);

Typography tbTypography = Typography.material2018();

const tbMatIndigo = MaterialColor(_tbPrimaryColorValue, <int, Color>{
  50: Color(0xFFE3EAF2),
  100: Color(0xFFB9CADF),
  200: Color(0xFF8BA7CA),
  300: Color(0xFF5C84B5),
  400: Color(0xFF3969A5),
  500: _tbPrimaryColor,
  600: Color(0xFF0F2E58),
  700: Color(0xFF0C274E),
  800: Color(0xFF0A2144),
  900: Color(0xFF061530),
});

const tbDarkMatIndigo = tbMatIndigo;

final ThemeData theme = ThemeData(primarySwatch: tbMatIndigo);

ThemeData tbTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: tbMatIndigo,
  colorScheme: theme.colorScheme.copyWith(
    primary: _tbPrimaryColor,
    secondary: _tbSecondaryColor,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  textTheme: tbTypography.black,
  primaryTextTheme: tbTypography.black,
  typography: tbTypography,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: _tbTextColor,
    iconTheme: IconThemeData(color: _tbTextColor),
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
  primarySwatch: tbDarkMatIndigo,
  brightness: Brightness.dark,
);

ThemeData tbDarkTheme = ThemeData(
  primarySwatch: tbDarkMatIndigo,
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