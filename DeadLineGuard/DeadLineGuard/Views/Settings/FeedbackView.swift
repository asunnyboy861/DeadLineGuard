import SwiftUI

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.accentColor)

                Text("Send Feedback")
                    .font(.title2.bold())

                Text("We'd love to hear from you! Send us your suggestions, bug reports, or feature requests.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Link(destination: URL(string: "mailto:\(Constants.contactEmail)?subject=DeadLineGuard%20Feedback")!) {
                    Text("Email Us")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                Link(destination: URL(string: Constants.feedbackURL)!) {
                    Text("Feedback Board")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
