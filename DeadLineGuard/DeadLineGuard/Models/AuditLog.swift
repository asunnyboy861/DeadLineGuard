import Foundation
import SwiftData

@Model
final class AuditLog {
    var id: UUID = UUID()
    var action: String = ""
    var timestamp: Date = Date()
    var details: String = ""
    var item: ComplianceItem?

    init(action: String, details: String = "") {
        self.id = UUID()
        self.action = action
        self.timestamp = Date()
        self.details = details
    }
}
