import SwiftUI

struct TemplatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (ComplianceTemplate) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(ComplianceTemplate.usTemplates) { template in
                    Button(action: {
                        onSelect(template)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: template.category.icon)
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 30)
                            VStack(alignment: .leading) {
                                Text(template.name)
                                    .foregroundStyle(.primary)
                                Text(template.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(template.recurrence.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
