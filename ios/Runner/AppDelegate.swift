import UIKit
import Flutter

// UIScene lifecycle (https://docs.flutter.dev/release/breaking-changes/uiscenedelegate):
// the UI belongs to the scene (SceneDelegate), so nothing here may touch the window or the
// FlutterViewController. Plugins and channels are registered once the engine exists.
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // must be set before launch finishes, so it stays here
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TbWebAuthHandler") {
      TbWebAuthHandler.register(with: registrar)
    }
  }
}
