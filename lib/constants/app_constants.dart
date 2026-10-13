abstract final class ThingsboardAppConstants {
  static const thingsBoardApiEndpoint = "http://192.168.1.10:8080";
  static const thingsboardOAuth2CallbackUrlScheme = "com.presrite.app.auth";
  static const thingsboardIOSAppSecret = String.fromEnvironment('thingsboardIosAppSecret');
  static const thingsboardAndroidAppSecret = "ejVsZkppRXNWYkZBQ3lsVkIxUnVaaXhXbkoxeGloU0tWNHJNMWN2WEZQWWVIZ2hDRlBnd2RlRHBJalZtWGphQg==";
  static const ignoreRegionSelection = thingsBoardApiEndpoint != '';
  static const supportManualPdfUrl = 'https://ithena.ai/presrite/mobilehelp.pdf';
}
