import 'package:flutter/material.dart';
import 'package:thingsboard_app/config/themes/imex_theme.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/utils/transition/page_transitions.dart';

/// The primary colour of the iMEX web theme currently in effect.
Color get appPrimaryColor => getIt<ImexThemeController>().value.primary;

Typography tbTypography = Typography.material2018();

/// The app's theme, built from the colours the iMEX web pages show
/// (Configuration › Look & feel, and this phone's light / dark mode).
ThemeData buildTbTheme(ImexPalette p) {
  final dark = p.isDark;
  final onAppBar = ImexPalette.onColor(p.appBar);
  final surface = dark ? p.surface : Colors.white;
  final base = ThemeData(
    useMaterial3: false,
    brightness: dark ? Brightness.dark : Brightness.light,
  );

  return ThemeData(
    useMaterial3: false,
    brightness: dark ? Brightness.dark : Brightness.light,
    primaryColor: p.primary,
    colorScheme: base.colorScheme.copyWith(
      primary: p.primary,
      onPrimary: ImexPalette.onColor(p.primary),
      secondary: p.primary,
      onSecondary: ImexPalette.onColor(p.primary),
      surface: surface,
      onSurface: dark ? p.text : const Color(0xDE000000),
      outline: p.line,
    ),
    scaffoldBackgroundColor: p.screen,
    canvasColor: surface,
    dividerColor: p.line,
    textTheme: dark ? tbTypography.white : tbTypography.black,
    primaryTextTheme: dark ? tbTypography.white : tbTypography.black,
    typography: tbTypography,
    extensions: [p],

    // native app bars: dark in dark mode, light in light mode
    appBarTheme: AppBarTheme(
      backgroundColor: p.appBar,
      foregroundColor: onAppBar,
      iconTheme: IconThemeData(color: onAppBar),
      actionsIconTheme: IconThemeData(color: onAppBar),
      systemOverlayStyle: p.appBarBars,
      titleTextStyle: TextStyle(
        color: onAppBar,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      toolbarTextStyle: TextStyle(color: onAppBar),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    dialogTheme: DialogThemeData(backgroundColor: surface),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: p.tabBar,
      selectedItemColor: p.tabSelected,
      unselectedItemColor: p.tabUnselected,
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
}
