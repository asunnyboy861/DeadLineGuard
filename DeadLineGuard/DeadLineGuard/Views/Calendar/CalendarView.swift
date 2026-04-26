import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query var items: [ComplianceItem]
    @State private var selectedDate = Date()

    private var calendar: Calendar { Calendar.current }

    private var itemsForSelectedDate: [ComplianceItem] {
        items.filter { calendar.isDate($0.dueDate, inSameDayAs: selectedDate) }
    }

    private var datesWithItems: Set<DateComponents> {
        Set(items.map { calendar.dateComponents([.year, .month, .day], from: $0.dueDate) })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal)

                Divider()

                if itemsForSelectedDate.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("No deadlines on this date")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(itemsForSelectedDate) { item in
                        NavigationLink(value: item) {
                            ComplianceItemCard(item: item, style: cardStyle(for: item))
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calendar")
        }
    }

    private func cardStyle(for item: ComplianceItem) -> ComplianceItemCard.CardStyle {
        if item.isOverdue { return .overdue }
        if item.status == .completed { return .completed }
        return .upcoming
    }
}
