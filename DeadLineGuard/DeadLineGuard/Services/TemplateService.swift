import Foundation

struct ComplianceTemplate: Identifiable {
    let id = UUID()
    let name: String
    let category: ComplianceCategory
    let recurrence: RecurrenceRule
    let description: String

    static let usTemplates: [ComplianceTemplate] = [
        ComplianceTemplate(name: "Quarterly Estimated Tax (Q1)", category: .tax,
                           recurrence: .quarterly, description: "IRS Form 1040-ES - Due April 15"),
        ComplianceTemplate(name: "Quarterly Estimated Tax (Q2)", category: .tax,
                           recurrence: .quarterly, description: "IRS Form 1040-ES - Due June 15"),
        ComplianceTemplate(name: "Quarterly Estimated Tax (Q3)", category: .tax,
                           recurrence: .quarterly, description: "IRS Form 1040-ES - Due September 15"),
        ComplianceTemplate(name: "Quarterly Estimated Tax (Q4)", category: .tax,
                           recurrence: .quarterly, description: "IRS Form 1040-ES - Due January 15"),
        ComplianceTemplate(name: "S-Corp Annual Tax Return", category: .tax,
                           recurrence: .annual, description: "Form 1120-S - Due March 15"),
        ComplianceTemplate(name: "LLC Annual Tax Return", category: .tax,
                           recurrence: .annual, description: "Form 1065 - Due March 15"),
        ComplianceTemplate(name: "Sales Tax Filing", category: .tax,
                           recurrence: .monthly, description: "State-specific frequency varies"),
        ComplianceTemplate(name: "Annual Report / Statement of Information", category: .report,
                           recurrence: .annual, description: "State filing to maintain good standing"),
        ComplianceTemplate(name: "BOI Report (FinCEN)", category: .report,
                           recurrence: .none, description: "Beneficial Ownership Information - One-time + updates within 30 days"),
        ComplianceTemplate(name: "W-2 / W-3 Filing", category: .report,
                           recurrence: .annual, description: "Employee wage reporting - Due January 31"),
        ComplianceTemplate(name: "1099-NEC Filing", category: .report,
                           recurrence: .annual, description: "Contractor payment reporting - Due January 31"),
        ComplianceTemplate(name: "Business License Renewal", category: .license,
                           recurrence: .annual, description: "Local/city business license renewal"),
        ComplianceTemplate(name: "Professional License Renewal", category: .license,
                           recurrence: .biennial, description: "State professional license (varies by profession)"),
        ComplianceTemplate(name: "Workers' Compensation Renewal", category: .insurance,
                           recurrence: .annual, description: "Required in most states with employees"),
        ComplianceTemplate(name: "General Liability Insurance Renewal", category: .insurance,
                           recurrence: .annual, description: "Business liability coverage renewal"),
        ComplianceTemplate(name: "EEO-1 Report", category: .employee,
                           recurrence: .annual, description: "Equal Employment Opportunity filing (100+ employees)"),
    ]
}
