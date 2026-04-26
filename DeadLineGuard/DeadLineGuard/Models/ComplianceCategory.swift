import Foundation

enum ComplianceCategory: String, Codable, CaseIterable {
    case tax = "Tax"
    case license = "License"
    case report = "Report"
    case insurance = "Insurance"
    case employee = "Employee"
    case other = "Other"

    var icon: String {
        switch self {
        case .tax: return "dollarsign.circle.fill"
        case .license: return "id.card.fill"
        case .report: return "doc.text.fill"
        case .insurance: return "shield.fill"
        case .employee: return "person.2.fill"
        case .other: return "folder.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .tax: return "#007AFF"
        case .license: return "#AF52DE"
        case .report: return "#5AC8FA"
        case .insurance: return "#34C759"
        case .employee: return "#FF9500"
        case .other: return "#8E8E93"
        }
    }
}
