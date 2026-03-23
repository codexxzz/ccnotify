import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    let title: String
    let message: String

    init(title: String, message: String) {
        self.title = title
        self.message = message
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                fputs("Error: \(error.localizedDescription)\n", stderr)
                DispatchQueue.main.async { NSApp.terminate(nil) }
                return
            }

            if !granted {
                fputs("Notification permission denied. Enable in System Settings > Notifications > ccnotify.\n", stderr)
                DispatchQueue.main.async { NSApp.terminate(nil) }
                return
            }

            let content = UNMutableNotificationContent()
            content.title = self.title
            content.body = self.message
            content.sound = .default

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )

            center.add(request) { error in
                if let error = error {
                    fputs("Notification error: \(error.localizedDescription)\n", stderr)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    NSApp.terminate(nil)
                }
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

var title = "ccnotify"
var message = ""
var args = Array(CommandLine.arguments.dropFirst())

if args.count >= 2, args[0] == "-t" {
    title = args[1]
    args = Array(args.dropFirst(2))
}

message = args.joined(separator: " ")

guard !message.isEmpty else {
    fputs("Usage: ccnotify [-t \"title\"] \"message\"\n", stderr)
    exit(1)
}

let app = NSApplication.shared
let delegate = AppDelegate(title: title, message: message)
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
