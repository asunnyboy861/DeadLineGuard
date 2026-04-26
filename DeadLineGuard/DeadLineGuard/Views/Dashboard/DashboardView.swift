import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \ComplianceItem.dueDate) var items: [ComplianceItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddSheet = false

    var overdueItems: [ComplianceItem] {
        items.filter { $0.isOverdue }
    }

    var upcomingItems: [ComplianceItem] {
        items.filter { !$0.isOverdue && $0.status != .completed }
            .sorted { $0.daysUntilDue < $1.daysUntilDue }
    }

    var completedItems: [ComplianceItem] {
        items.filter { $0.status == .completed }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    StatsRowView(overdue: overdueItems.count,
                                 upcoming: upcomingItems.count,
                                 total: items.count)

                    if !overdueItems.isEmpty {
                        SectionHeader(title: "Overdue", count: overdueItems.count, color: .red)
                        ForEach(overdueItems) { item in
                            NavigationLink(value: item) {
                                ComplianceItemCard(item: item, style: .overdue)
                            }
                        }
                    }

                    if !upcomingItems.isEmpty {
                        SectionHeader(title: "Upcoming", count: upcomingItems.count, color: .blue)
                        ForEach(upcomingItems.prefix(5)) { item in
                            NavigationLink(value: item) {
                                ComplianceItemCard(item: item, style: .upcoming)
                            }
                        }
                    }

                    if items.isEmpty {
                        EmptyStateView()
                    }
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("DeadLineGuard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddComplianceItemView()
            }
            .navigationDestination(for: ComplianceItem.self) { item in
                ItemDetailView(item: item)
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    let count: Int
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(color)
            Text("(\(count))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
