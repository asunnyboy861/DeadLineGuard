import SwiftUI

struct ComplianceItemCard: View {
    let item: ComplianceItem
    let style: CardStyle

    enum CardStyle { case overdue, upcoming, completed }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.category.icon)
                .font(.title2)
                .foregroundStyle(categoryColor)
                .frame(width: 44, height: 44)
                .background(categoryColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)

                HStack {
                    Text(item.dueDate, style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if item.daysUntilDue <= 7 && item.daysUntilDue > 0 {
                        Text("\(item.daysUntilDue)d left")
                            .font(.caption.bold())
                            .foregroundStyle(.orange)
                    }
                }

                if !item.responsibleParty.isEmpty {
                    Label(item.responsibleParty, systemImage: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            statusBadge
        }
        .padding()
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch style {
        case .overdue:
            Text("OVERDUE")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.red, in: Capsule())
        case .upcoming:
            Circle()
                .fill(item.daysUntilDue <= 7 ? Color.orange : Color.blue)
                .frame(width: 12, height: 12)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
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

    private var cardBackground: Color {
        switch style {
        case .overdue: return Color.red.opacity(0.06)
        case .upcoming: return Color(.systemBackground)
        case .completed: return Color.green.opacity(0.06)
        }
    }
}
