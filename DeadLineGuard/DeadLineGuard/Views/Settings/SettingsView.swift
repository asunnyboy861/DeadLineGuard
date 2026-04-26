import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @ObservedObject var purchaseManager: PurchaseManager
    @State private var showingPaywall = false
    @State private var showingFeedback = false

    var body: some View {
        NavigationStack {
            List {
                proSection
                notificationSection
                aboutSection
                resetSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
            .sheet(isPresented: $showingFeedback) {
                FeedbackView()
            }
        }
    }

    private var proSection: some View {
        Section {
            if purchaseManager.isPro {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("Pro Active")
                    Spacer()
                    Text(purchaseManager.purchasedProductIDs.first == ProductID.lifetime ? "Lifetime" : "Subscription")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Button(action: { showingPaywall = true }) {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Pro")
                    }
                }
            }

            Button(action: { Task { await purchaseManager.restorePurchases() } }) {
                Text("Restore Purchases")
            }
        } header: {
            Text("Subscription")
        }
    }

    private var notificationSection: some View {
        Section {
            Button(action: openNotificationSettings) {
                HStack {
                    Text("Notification Settings")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("Notifications")
        }
    }

    private var aboutSection: some View {
        Section {
            Link(destination: URL(string: Constants.privacyURL)!) {
                HStack {
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.secondary)
                }
            }
            Link(destination: URL(string: Constants.termsURL)!) {
                HStack {
                    Text("Terms of Use")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.secondary)
                }
            }
            Link(destination: URL(string: Constants.supportURL)!) {
                HStack {
                    Text("Support")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.secondary)
                }
            }
            Button(action: { showingFeedback = true }) {
                HStack {
                    Text("Send Feedback")
                    Spacer()
                    Image(systemName: "envelope")
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("About")
        } footer: {
            Text("Version 1.0.0")
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive, action: resetOnboarding) {
                Text("Reset Onboarding")
            }
        }
    }

    private func openNotificationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}
