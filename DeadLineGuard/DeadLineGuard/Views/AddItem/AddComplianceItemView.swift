import SwiftUI
import SwiftData

struct AddComplianceItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var name = ""
    @State private var category: ComplianceCategory = .other
    @State private var dueDate = Date()
    @State private var recurrence: RecurrenceRule = .none
    @State private var responsibleParty = ""
    @State private var notes = ""
    @State private var showTemplatePicker = false
    @State private var showPaywall = false

    @Query var items: [ComplianceItem]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Button(action: { showTemplatePicker = true }) {
                        Label("Use Template", systemImage: "list.bullet.clipboard")
                    }

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

                    TextField("Responsible Party (optional)", text: $responsibleParty)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Add Deadline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(name.isEmpty)
                    .bold()
                }
            }
            .sheet(isPresented: $showTemplatePicker) {
                TemplatePickerView { template in
                    name = template.name
                    category = template.category
                    recurrence = template.recurrence
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private func saveItem() {
        let activeItems = items.filter { $0.status != .completed }
        if !purchaseManager.isPro && activeItems.count >= purchaseManager.maxFreeItems {
            showPaywall = true
            return
        }

        let item = ComplianceItem(
            name: name,
            category: category,
            dueDate: dueDate,
            recurrence: recurrence,
            responsibleParty: responsibleParty
        )
        item.notes = notes
        modelContext.insert(item)

        let log = AuditLog(action: "Created", details: "Deadline '\(name)' created")
        log.item = item
        modelContext.insert(log)

        try? modelContext.save()

        Task {
            let config = purchaseManager.isPro ? NotificationService.ReminderConfig.default : NotificationService.ReminderConfig.free
            await NotificationService.shared.scheduleReminders(for: item, config: config)
        }

        dismiss()
    }
}
