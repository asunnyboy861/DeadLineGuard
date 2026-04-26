import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    struct ReminderConfig {
        let daysBefore: [Int]

        static let `default` = ReminderConfig(daysBefore: [30, 14, 7, 1])
        static let free = ReminderConfig(daysBefore: [1])
    }

    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .badge, .sound])
    }

    func scheduleReminders(for item: ComplianceItem, config: ReminderConfig = .default) async {
        for daysBefore in config.daysBefore {
            guard let triggerDate = Calendar.current.date(
                byAdding: .day, value: -daysBefore, to: item.dueDate
            ), triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = daysBefore <= 1 ? "Deadline Tomorrow!" : "Deadline Approaching"
            content.body = "\(item.name) is due in \(daysBefore) day\(daysBefore == 1 ? "" : "s")"
            content.sound = .default
            content.categoryIdentifier = "COMPLIANCE_REMINDER"
            content.userInfo = ["itemID": item.id.uuidString]

            let components = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute], from: triggerDate
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components, repeats: false
            )

            let identifier = "compliance_\(item.id.uuidString)_\(daysBefore)d"
            let request = UNNotificationRequest(
                identifier: identifier, content: content, trigger: trigger
            )

            try? await center.add(request)
        }

        scheduleOverdueReminder(for: item)
    }

    private func scheduleOverdueReminder(for item: ComplianceItem) {
        let content = UNMutableNotificationContent()
        content.title = "OVERDUE"
        content.body = "\(item.name) is PAST DUE! Take action now."
        content.sound = .defaultCritical
        content.categoryIdentifier = "COMPLIANCE_OVERDUE"

        guard let overdueDate = Calendar.current.date(
            byAdding: .hour, value: 1, to: item.dueDate
        ), overdueDate > Date() else { return }

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute], from: overdueDate
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components, repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "overdue_\(item.id.uuidString)",
            content: content, trigger: trigger
        )
        try? center.add(request)
    }

    func cancelReminders(for item: ComplianceItem) {
        let identifiers = [30, 14, 7, 1].map {
            "compliance_\(item.id.uuidString)_\($0)d"
        } + ["overdue_\(item.id.uuidString)"]
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
