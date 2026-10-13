abstract final class ThingsboardAppConstants {
  static const thingsBoardApiEndpoint = "https://iserv-demov2.ithena.app";
  static const thingsboardOAuth2CallbackUrlScheme = "ai.ithena.imex.auth";
  static const thingsboardIOSAppSecret = String.fromEnvironment('thingsboardIosAppSecret');
  static const thingsboardAndroidAppSecret = "ejVsZkppRXNWYkZBQ3lsVkIxUnVaaXhXbkoxeGloU0tWNHJNMWN2WEZQWWVIZ2hDRlBnd2RlRHBJalZtWGphQg==";
  static const ignoreRegionSelection = thingsBoardApiEndpoint != '';
  static const supportManualPdfUrl = 'https://ithena.ai/imex/mobilehelp.pdf';
  static const showSupportManual = false;
}
