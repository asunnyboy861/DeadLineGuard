import Foundation
import SwiftData

@Model
final class ComplianceItem {
    var id: UUID = UUID()
    var name: String = ""
    var category: ComplianceCategory = ComplianceCategory.other
    var dueDate: Date = Date()
    var recurrence: RecurrenceRule = RecurrenceRule.none
    var responsibleParty: String = ""
    var status: ItemStatus = ItemStatus.pending
    var notes: String = ""
    var completedAt: Date?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    @Relationship(deleteRule: .cascade, inverse: \DocumentAttachment.item)
    var documents: [DocumentAttachment] = []

    @Relationship(deleteRule: .cascade, inverse: \AuditLog.item)
    var auditLogs: [AuditLog] = []

    var isOverdue: Bool {
        status != .completed && dueDate < Date()
    }

    var daysUntilDue: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }

    init(name: String, category: ComplianceCategory, dueDate: Date,
         recurrence: RecurrenceRule = .none, responsibleParty: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.dueDate = dueDate
        self.recurrence = recurrence
        self.responsibleParty = responsibleParty
        self.status = .pending
        self.notes = ""
        self.completedAt = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
