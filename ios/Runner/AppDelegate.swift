import UIKit
import Flutter
import YandexMapsMobile
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Yandex Map API kalitini sozlash
    YMKMapKit.setApiKey("f46b85e7-283f-4ee0-a95d-d5e511ac26ac") // Your API key
    GeneratedPluginRegistrant.register(with: self)

    // APNs uchun ruxsat so‘rash
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        } else {
            print("Push notification ruxsat berilmadi: \(error?.localizedDescription ?? "Noma'lum xatolik")")
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Qurilmani APNs-ga ro‘yxatdan o‘tkazish muvaffaqiyatli bo‘lsa
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
    print("Device Token: \(tokenString)")
  }

  // Xatolik bo‘lsa
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("APNs ro‘yxatdan o‘tishda xatolik: \(error.localizedDescription)")
  }
}
