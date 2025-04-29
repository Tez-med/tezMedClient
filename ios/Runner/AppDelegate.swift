import UIKit
import Flutter
import YandexMapsMobile
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    // Yandex Map API kalitini sozlash
    YMKMapKit.setApiKey("f46b85e7-283f-4ee0-a95d-d5e511ac26ac") // Your API key
    GeneratedPluginRegistrant.register(with: self)

    // APNs uchun ruxsat so‘rash
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions){_, _ in}
    }
    application.registerForRemoteNotifications()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                          didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // APNs tokenni Firebase-ga uzatish
    Messaging.messaging().apnsToken = deviceToken
    
    // Tokenni log qilib chiqarish
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("APNs token: \(tokenString)")
    
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
}

}
