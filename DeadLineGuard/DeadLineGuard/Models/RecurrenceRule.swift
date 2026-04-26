import Foundation

enum RecurrenceRule: String, Codable, CaseIterable {
    case none = "One-time"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case semiAnnual = "Semi-Annual"
    case annual = "Annual"
    case biennial = "Biennial"

    func nextDate(from date: Date) -> Date? {
        guard self != .none else { return nil }
        let calendar = Calendar.current
        switch self {
        case .monthly: return calendar.date(byAdding: .month, value: 1, to: date)
        case .quarterly: return calendar.date(byAdding: .month, value: 3, to: date)
        case .semiAnnual: return calendar.date(byAdding: .month, value: 6, to: date)
        case .annual: return calendar.date(byAdding: .year, value: 1, to: date)
        case .biennial: return calendar.date(byAdding: .year, value: 2, to: date)
        case .none: return nil
        }
    }
}
