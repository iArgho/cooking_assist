import Flutter
import FirebaseCore
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< Updated upstream
      FirebaseApp.configure()
=======
    FirebaseApp.configure()
>>>>>>> Stashed changes
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
