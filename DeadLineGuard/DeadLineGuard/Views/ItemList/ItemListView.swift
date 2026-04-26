import SwiftUI
import SwiftData

struct ItemListView: View {
    @Query(sort: \ComplianceItem.dueDate) var items: [ComplianceItem]
    @State private var selectedCategory: ComplianceCategory?
    @State private var selectedStatus: ItemStatus?
    @State private var showingAddSheet = false

    var filteredItems: [ComplianceItem] {
        items.filter { item in
            let categoryMatch = selectedCategory == nil || item.category == selectedCategory
            let statusMatch = selectedStatus == nil || item.status == selectedStatus
            return categoryMatch && statusMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilterView
                itemListContent
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("All Items")
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

    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(ComplianceCategory.allCases, id: \.self) { cat in
                    FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private var itemListContent: some View {
        List(filteredItems) { item in
            NavigationLink(value: item) {
                ComplianceItemCard(item: item, style: cardStyle(for: item))
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }

    private func cardStyle(for item: ComplianceItem) -> ComplianceItemCard.CardStyle {
        if item.isOverdue { return .overdue }
        if item.status == .completed { return .completed }
        return .upcoming
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        }
    }
}
