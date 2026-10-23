import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thingsboard_app/config/routes/router.dart';
import 'package:thingsboard_app/config/themes/imex_theme.dart';
import 'package:thingsboard_app/config/themes/tb_theme.dart';
import 'package:thingsboard_app/generated/l10n.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/utils/services/layouts/i_layout_service.dart';
import 'package:toastification/toastification.dart';

class ThingsboardApp extends StatefulWidget {
  const ThingsboardApp({super.key});

  @override
  State<StatefulWidget> createState() => _ThingsBoardAppState();
}

class _ThingsBoardAppState extends State<ThingsboardApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<ILayoutService>().setDeviceScreenSize(
        MediaQuery.of(context).size,
        orientation: MediaQuery.of(context).orientation,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // the iMEX web pages' colour theme and light / dark mode (see ImexThemeController)
    return ValueListenableBuilder<ImexPalette>(
      valueListenable: getIt<ImexThemeController>(),
      builder: (context, palette, _) => _buildApp(palette),
    );
  }

  Widget _buildApp(ImexPalette palette) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        onGenerateTitle: (BuildContext context) => S.of(context).appTitle,
        // the palette is already light or dark, as the pages show it
        themeMode: ThemeMode.light,
        theme: buildTbTheme(palette),
        // system bars of screens without an app bar (sign-in); app bars, dashboards and the
        // tab pages set their own (see ImexPalette)
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: palette.screenBars,
          child: child!,
        ),
        navigatorKey: getIt<ThingsboardAppRouter>().navigatorKey,
       onGenerateRoute: getIt<ThingsboardAppRouter>().router.generator,
        navigatorObservers: [
          getIt<ThingsboardAppRouter>().tbContext.routeObserver,
        ],
      ),
    );
  }
}
