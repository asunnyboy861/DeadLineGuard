import SwiftUI

struct StatsRowView: View {
    let overdue: Int
    let upcoming: Int
    let total: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCardView(title: "Overdue", value: overdue, color: .red, icon: "exclamationmark.triangle.fill")
            StatCardView(title: "Upcoming", value: upcoming, color: .blue, icon: "clock.fill")
            StatCardView(title: "Total", value: total, color: .green, icon: "list.bullet.clipboard.fill")
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: Int
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text("\(value)")
                .font(.title.bold())
                .foregroundStyle(.primary)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}
