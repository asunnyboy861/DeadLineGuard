import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Bindable var item: ComplianceItem
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard
                detailCard
                if purchaseManager.hasDocumentAttachment {
                    documentsCard
                }
                if purchaseManager.hasAuditLog {
                    auditLogCard
                }
                actionsCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditComplianceItemView(item: item)
        }
        .alert("Delete Deadline?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) { deleteItem() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var headerCard: some View {
        VStack(spacing: 12) {
            Image(systemName: item.category.icon)
                .font(.system(size: 40))
                .foregroundStyle(categoryColor)

            Text(item.name)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Label {
                    Text(item.dueDate, style: .date)
                } icon: {
                    Image(systemName: "calendar")
                }
                Label(item.recurrence.rawValue, systemImage: "arrow.clockwise")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            statusView
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    @ViewBuilder
    private var statusView: some View {
        if item.isOverdue {
            Text("OVERDUE - \(abs(item.daysUntilDue)) days past due")
                .font(.headline)
                .foregroundStyle(.red)
        } else if item.status == .completed {
            Text("Completed")
                .font(.headline)
                .foregroundStyle(.green)
        } else {
            Text("\(item.daysUntilDue) days remaining")
                .font(.headline)
                .foregroundStyle(item.daysUntilDue <= 7 ? .orange : .blue)
        }
    }

    private var detailCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)

            if !item.responsibleParty.isEmpty {
                LabeledContent("Responsible", value: item.responsibleParty)
            }
            LabeledContent("Category", value: item.category.rawValue)
            LabeledContent("Recurrence", value: item.recurrence.rawValue)
            LabeledContent("Created", value: DateHelper.format(item.createdAt))

            if !item.notes.isEmpty {
                Divider()
                Text("Notes")
                    .font(.headline)
                Text(item.notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var documentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Documents")
                .font(.headline)

            if item.documents.isEmpty {
                Text("No documents attached")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(item.documents) { doc in
                    HStack {
                        Image(systemName: "doc.fill")
                        Text(doc.name)
                        Spacer()
                        Text(doc.fileType)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var auditLogCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Audit Log")
                .font(.headline)

            if item.auditLogs.isEmpty {
                Text("No activity recorded")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(item.auditLogs.sorted { $0.timestamp > $1.timestamp }) { log in
                    HStack {
                        Text(log.action)
                            .font(.subheadline.bold())
                        Spacer()
                        Text(log.timestamp, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !log.details.isEmpty {
                        Text(log.details)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var actionsCard: some View {
        VStack(spacing: 12) {
            if item.status != .completed {
                Button(action: markCompleted) {
                    Label("Mark as Completed", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }

            if item.status == .completed && item.recurrence != .none {
                Button(action: createNextOccurrence) {
                    Label("Create Next Occurrence", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private var categoryColor: Color {
        switch item.category {
        case .tax: return .blue
        case .license: return .purple
        case .report: return .teal
        case .insurance: return .green
        case .employee: return .orange
        case .other: return .gray
        }
    }

    private func markCompleted() {
        item.status = .completed
        item.completedAt = Date()
        item.updatedAt = Date()

        let log = AuditLog(action: "Completed", details: "Marked as completed")
        log.item = item
        modelContext.insert(log)

        NotificationService.shared.cancelReminders(for: item)
        try? modelContext.save()
    }

    private func createNextOccurrence() {
        guard let nextDate = item.recurrence.nextDate(from: item.dueDate) else { return }

        let nextItem = ComplianceItem(
            name: item.name,
            category: item.category,
            dueDate: nextDate,
            recurrence: item.recurrence,
            responsibleParty: item.responsibleParty
        )
        nextItem.notes = item.notes
        modelContext.insert(nextItem)

        let log = AuditLog(action: "Recurring Created", details: "Next occurrence created for \(DateHelper.format(nextDate))")
        log.item = nextItem
        modelContext.insert(log)

        try? modelContext.save()

        Task {
            let config = purchaseManager.isPro ? NotificationService.ReminderConfig.default : NotificationService.ReminderConfig.free
            await NotificationService.shared.scheduleReminders(for: nextItem, config: config)
        }
    }

    private func deleteItem() {
        NotificationService.shared.cancelReminders(for: item)
        modelContext.delete(item)
        try? modelContext.save()
    }
}
