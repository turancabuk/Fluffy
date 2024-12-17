import UserNotifications
import CoreLocation

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func scheduleDailyWeatherNotification(summary: String, temp: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Daily Weather"
        content.body = "\(summary)\nTemperature: \(temp)"
        content.sound = .default
        
        // Bildirim için saat ayarı (08:00)
        var dateComponents = DateComponents()
        dateComponents.hour   = 08
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dailyWeather",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
