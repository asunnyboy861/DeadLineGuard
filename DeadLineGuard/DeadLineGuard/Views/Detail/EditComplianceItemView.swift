import SwiftUI
import SwiftData

struct EditComplianceItemView: View {
    @Bindable var item: ComplianceItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var name: String = ""
    @State private var category: ComplianceCategory = .other
    @State private var dueDate = Date()
    @State private var recurrence: RecurrenceRule = .none
    @State private var responsibleParty: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Deadline Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(ComplianceCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    Picker("Recurrence", selection: $recurrence) {
                        ForEach(RecurrenceRule.allCases, id: \.self) { rule in
                            Text(rule.rawValue).tag(rule)
                        }
                    }
                    TextField("Responsible Party", text: $responsibleParty)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Edit Deadline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                }
            }
            .onAppear {
                name = item.name
                category = item.category
                dueDate = item.dueDate
                recurrence = item.recurrence
                responsibleParty = item.responsibleParty
                notes = item.notes
            }
        }
    }

    private func saveChanges() {
        item.name = name
        item.category = category
        item.dueDate = dueDate
        item.recurrence = recurrence
        item.responsibleParty = responsibleParty
        item.notes = notes
        item.updatedAt = Date()

        let log = AuditLog(action: "Updated", details: "Deadline '\(name)' updated")
        log.item = item
        modelContext.insert(log)

        try? modelContext.save()

        NotificationService.shared.cancelReminders(for: item)
        Task {
            let config = purchaseManager.isPro ? NotificationService.ReminderConfig.default : NotificationService.ReminderConfig.free
            await NotificationService.shared.scheduleReminders(for: item, config: config)
        }

        dismiss()
    }
}
