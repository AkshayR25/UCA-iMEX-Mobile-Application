import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:thingsboard_app/core/logger/tb_logger.dart';
import 'package:thingsboard_app/utils/services/local_database/i_local_database_service.dart';

/// The colours the iMEX web pages are showing (Configuration › Look & feel colour
/// theme + this phone's light / dark mode), as read from a dashboard page.
///
/// Defaults are the web kit's fallbacks for the "iMEX Blue" theme in light mode.
@immutable
class ImexPalette extends ThemeExtension<ImexPalette> {
  const ImexPalette({
    this.isDark = false,
    this.themeId = 'blue',
    this.bar = const Color(0xFF0F2B57),
    this.barDeep = const Color(0xFF0A1F44),
    this.accent = const Color(0xFF38BDF8),
    this.primary = const Color(0xFF2563EB),
    this.page = const Color(0xFFF4F6FA),
    this.surface = const Color(0xFFFFFFFF),
    this.text = const Color(0xFF0F172A),
    this.muted = const Color(0xFF5B6B82),
    this.line = const Color(0xFFE3E8EF),
  });

  /// From the bridge snapshot (keys as sent by [imexThemeBridgeJs]) or the cache.
  factory ImexPalette.fromJson(Map<String, dynamic> json) {
    const d = ImexPalette();
    return ImexPalette(
      isDark: json['mode'] == 'dark',
      themeId: (json['theme'] as String?)?.isNotEmpty == true
          ? json['theme'] as String
          : d.themeId,
      bar: parseCssColor(json['n']) ?? d.bar,
      barDeep: parseCssColor(json['m3']) ?? d.barDeep,
      accent: parseCssColor(json['a']) ?? d.accent,
      primary: parseCssColor(json['p']) ?? d.primary,
      page: parseCssColor(json['bg']) ?? d.page,
      surface: parseCssColor(json['surface']) ?? d.surface,
      text: parseCssColor(json['text']) ?? d.text,
      muted: parseCssColor(json['muted']) ?? d.muted,
      line: parseCssColor(json['line']) ?? d.line,
    );
  }

  final bool isDark;
  final String themeId;

  /// --imx-n: page header / menu; the app's tab bar, status bar and app bars
  final Color bar;

  /// --imx-m3: the darkest menu shade; Android navigation bar
  final Color barDeep;

  /// --imx-a: accent; the selected tab
  final Color accent;

  /// --imx-p: primary actions (buttons, links)
  final Color primary;

  /// --imx-bg: behind the pages
  final Color page;

  final Color surface;
  final Color text;
  final Color muted;
  final Color line;

  /// Text / icon colour that reads on [bar].
  Color get onBar => onColor(bar);

  // Native chrome. The web keeps its page header dark ([bar]) in both modes; the app's own
  // bars are dark in dark mode and light in light mode.

  /// Behind native screens (sign-in, Profile, lists).
  Color get screen => isDark ? page : Colors.white;

  /// Native app bars (Profile, Change password, lists).
  Color get appBar => isDark ? bar : Colors.white;

  /// The bottom tab bar.
  Color get tabBar => isDark ? bar : Colors.white;

  Color get tabSelected => isDark ? accent : primary;

  Color get tabUnselected => isDark ? onBar.withValues(alpha: 0.7) : muted;

  /// Native screens without an app bar (sign-in): status and navigation bar in the screen's colour.
  SystemUiOverlayStyle get screenBars => systemBars(top: screen, bottom: screen);

  /// Native screens with an app bar.
  SystemUiOverlayStyle get appBarBars => systemBars(top: appBar, bottom: screen);

  /// A dashboard page: the status bar blends with the web's own (dark) page header.
  SystemUiOverlayStyle get dashboardBars => systemBars(top: bar, bottom: page);

  /// The tab pages: the navigation bar continues the tab bar.
  SystemUiOverlayStyle get tabsBars => systemBars(top: bar, bottom: tabBar);

  /// Status bar [top] and navigation bar [bottom], each with icons that read on it.
  static SystemUiOverlayStyle systemBars({
    required Color top,
    required Color bottom,
  }) {
    final darkTop = ThemeData.estimateBrightnessForColor(top) == Brightness.dark;
    final darkBottom =
        ThemeData.estimateBrightnessForColor(bottom) == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: top,
      // Android icons
      statusBarIconBrightness: darkTop ? Brightness.light : Brightness.dark,
      // iOS: the bar's own brightness
      statusBarBrightness: darkTop ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: bottom,
      systemNavigationBarDividerColor: bottom,
      systemNavigationBarIconBrightness:
          darkBottom ? Brightness.light : Brightness.dark,
    );
  }

  Map<String, dynamic> toJson() => {
        'mode': isDark ? 'dark' : 'light',
        'theme': themeId,
        'n': _hex(bar),
        'm3': _hex(barDeep),
        'a': _hex(accent),
        'p': _hex(primary),
        'bg': _hex(page),
        'surface': _hex(surface),
        'text': _hex(text),
        'muted': _hex(muted),
        'line': _hex(line),
      };

  @override
  ImexPalette copyWith({bool? isDark, String? themeId}) => ImexPalette(
        isDark: isDark ?? this.isDark,
        themeId: themeId ?? this.themeId,
        bar: bar,
        barDeep: barDeep,
        accent: accent,
        primary: primary,
        page: page,
        surface: surface,
        text: text,
        muted: muted,
        line: line,
      );

  @override
  ImexPalette lerp(ImexPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return ImexPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      themeId: t < 0.5 ? themeId : other.themeId,
      bar: l(bar, other.bar),
      barDeep: l(barDeep, other.barDeep),
      accent: l(accent, other.accent),
      primary: l(primary, other.primary),
      page: l(page, other.page),
      surface: l(surface, other.surface),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      line: l(line, other.line),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ImexPalette && jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;

  static Color onColor(Color c) =>
      ThemeData.estimateBrightnessForColor(c) == Brightness.dark
          ? Colors.white
          : const Color(0xFF0F172A);

  static String _hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}

/// '#RGB', '#RRGGBB', '#RRGGBBAA', 'rgb(r, g, b)' or 'rgba(r, g, b, a)'; null if not one of those.
Color? parseCssColor(Object? value) {
  if (value is! String) return null;
  final s = value.trim().toLowerCase();
  if (s.startsWith('#')) {
    var h = s.substring(1);
    if (h.length == 3) h = h.split('').map((c) => '$c$c').join();
    if (h.length == 8) h = h.substring(6) + h.substring(0, 6);
    if (h.length == 6) h = 'ff$h';
    final v = h.length == 8 ? int.tryParse(h, radix: 16) : null;
    return v == null ? null : Color(v);
  }
  final m = RegExp(r'^rgba?\(([^)]+)\)$').firstMatch(s);
  if (m == null) return null;
  final parts = m.group(1)!.split(RegExp(r'[,\s/]+')).where((e) => e.isNotEmpty);
  final n = parts.map(double.tryParse).toList();
  if (n.length < 3 || n.take(3).any((e) => e == null)) return null;
  final a = n.length > 3 && n[3] != null ? n[3]!.clamp(0.0, 1.0) : 1.0;
  return Color.fromARGB(
    (a * 255).round(),
    n[0]!.round().clamp(0, 255),
    n[1]!.round().clamp(0, 255),
    n[2]!.round().clamp(0, 255),
  );
}

/// Holds the iMEX look for the whole app: the native theme, the system bars and the
/// light / dark mode of every open dashboard follow it.
class ImexThemeController extends ValueNotifier<ImexPalette> {
  ImexThemeController({required this.databaseService, required this.logger})
      : super(const ImexPalette());

  final ILocalDatabaseService databaseService;
  final TbLogger logger;

  final _webViews = <InAppWebViewController>{};

  /// The last look a page reported, from the previous run.
  Future<void> load() async {
    try {
      final raw = await databaseService.getImexTheme();
      if (raw != null) {
        value = ImexPalette.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (e) {
      logger.error('ImexThemeController::load() $e');
    }
  }

  void attach(InAppWebViewController webView) => _webViews.add(webView);

  void detach(InAppWebViewController webView) => _webViews.remove(webView);

  /// A dashboard page reported its look, or that the user switched its mode
  /// (the 'imxThemeHandler' bridge call).
  void onSnapshot(InAppWebViewController source, Object? data) {
    if (data is! Map) return;
    final json = Map<String, dynamic>.from(data);

    // The user switched Dark mode on one page (More): the other open pages follow without a
    // reload. Only this explicit switch is passed on; a page settling into its mode while it
    // loads is not, so a loading page never overrides the user's choice.
    final modeSet = json['modeSet'];
    if (modeSet == 'dark' || modeSet == 'light') {
      logger.debug('ImexThemeController: mode switched to $modeSet');
      for (final webView in _webViews.where((w) => w != source)) {
        webView
            .evaluateJavascript(
              source: "window.__imxApplyMode && window.__imxApplyMode('$modeSet');",
            )
            .catchError((Object e) => null);
      }
      return;
    }

    final next = ImexPalette.fromJson(json);
    if (next == value) return;
    logger.debug('ImexThemeController: ${next.toJson()}');
    value = next;
    databaseService.setImexTheme(jsonEncode(next.toJson()));
  }
}

/// Injected into every dashboard page. Reads the colours the iMEX shell applied
/// (the CSS variables on `<html>`, resolved by the browser, so presets, color-mix() values
/// and unset variables all come out as plain colours) and sends them to the app; again
/// whenever the mode or the theme changes. Pages without the iMEX shell send nothing.
const imexThemeBridgeJs = '''
(function () {
  if (window.__imxAppBridge) { window.__imxAppBridge(); return; }
  var H = document.documentElement, timer = null;
  var VARS = {
    n: ['--imx-n', '#0F2B57'], m3: ['--imx-m3', '#0A1F44'], a: ['--imx-a', '#38BDF8'],
    p: ['--imx-p', '#2563EB'], bg: ['--imx-bg', '#F4F6FA'], surface: ['--imx-surface', '#FFFFFF'],
    text: ['--imx-text', '#0F172A'], muted: ['--imx-muted', '#5B6B82'], line: ['--imx-line', '#E3E8EF']
  };
  var cv = document.createElement('canvas'); cv.width = cv.height = 1;
  var cx = cv.getContext('2d', { willReadFrequently: true });
  function hex(css) {
    try {
      cx.clearRect(0, 0, 1, 1); cx.fillStyle = '#000'; cx.fillStyle = css; cx.fillRect(0, 0, 1, 1);
      var d = cx.getImageData(0, 0, 1, 1).data;
      return '#' + [d[0], d[1], d[2]].map(function (x) { return ('0' + x.toString(16)).slice(-2); }).join('');
    } catch (e) { return ''; }
  }
  function snap() {
    var probe = document.createElement('div');
    probe.style.cssText = 'position:absolute;width:0;height:0;visibility:hidden;pointer-events:none';
    (document.body || H).appendChild(probe);
    var out = { mode: H.getAttribute('data-imx-mode') || '', theme: H.getAttribute('data-imx-theme') || '' };
    Object.keys(VARS).forEach(function (k) {
      probe.style.backgroundColor = 'var(' + VARS[k][0] + ', ' + VARS[k][1] + ')';
      out[k] = hex(getComputedStyle(probe).backgroundColor);
    });
    probe.remove();
    return out;
  }
  function post(data) {
    try { window.flutter_inappwebview.callHandler('imxThemeHandler', data); } catch (e) { /* no bridge */ }
  }
  // The page's own switch (More > Dark mode) calls __imexApp.setMode: report that one call as the
  // user's choice. The shell may (re)create __imexApp at any time, so the hook is re-checked often.
  function hook() {
    var A = window.__imexApp;
    if (!A || typeof A.setMode !== 'function' || A.setMode.__imxApp) return;
    var original = A.setMode;
    var wrapped = function (mode) {
      var r = original.apply(this, arguments);
      post({ modeSet: mode });
      return r;
    };
    wrapped.__imxApp = true;
    A.setMode = wrapped;
    // the app applies another page's switch here, without reporting it back
    window.__imxApplyMode = function (mode) { original.call(A, mode); };
  }
  function send() {
    timer = null;
    hook();
    if (!H.getAttribute('data-imx-mode')) return;
    post(snap());
  }
  function later() { hook(); if (timer) clearTimeout(timer); timer = setTimeout(send, 150); }
  window.__imxAppBridge = later;
  window.addEventListener('imx-mode-changed', later);
  window.addEventListener('imex-app:config', later);
  new MutationObserver(later).observe(H, { attributes: true, attributeFilter: ['data-imx-mode', 'data-imx-theme', 'style'] });
  later();
})();
''';
