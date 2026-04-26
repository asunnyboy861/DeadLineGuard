import SwiftUI
import StoreKit

struct PaywallView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProductID: String = ProductID.yearly

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    pricingSection
                    legalSection
                    purchaseButton
                    restoreButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Upgrade to Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "shield.checkered")
                .font(.system(size: 50))
                .foregroundStyle(Color.accentColor)
            Text("Unlock DeadLineGuard Pro")
                .font(.title2.bold())
            Text("Never miss a compliance deadline again")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(spacing: 12) {
            FeatureRow(icon: "infinity", title: "Unlimited Deadlines", subtitle: "No 3-item limit")
            FeatureRow(icon: "bell.badge.fill", title: "Multi-Stage Reminders", subtitle: "30, 14, 7, 1 day alerts")
            FeatureRow(icon: "paperclip", title: "Document Attachments", subtitle: "Attach receipts & certificates")
            FeatureRow(icon: "list.bullet.clipboard", title: "Audit Trail", subtitle: "Full activity history")
            FeatureRow(icon: "calendar", title: "Calendar View", subtitle: "Visual deadline overview")
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var pricingSection: some View {
        VStack(spacing: 12) {
            if let monthly = purchaseManager.monthlyProduct {
                PricingOption(
                    product: monthly,
                    isSelected: selectedProductID == ProductID.monthly,
                    badge: nil
                ) {
                    selectedProductID = ProductID.monthly
                }
            }

            if let yearly = purchaseManager.yearlyProduct {
                PricingOption(
                    product: yearly,
                    isSelected: selectedProductID == ProductID.yearly,
                    badge: "BEST VALUE"
                ) {
                    selectedProductID = ProductID.yearly
                }
            }

            if let lifetime = purchaseManager.lifetimeProduct {
                PricingOption(
                    product: lifetime,
                    isSelected: selectedProductID == ProductID.lifetime,
                    badge: "ONE-TIME"
                ) {
                    selectedProductID = ProductID.lifetime
                }
            }
        }
    }

    private var legalSection: some View {
        VStack(spacing: 8) {
            Text("Subscription automatically renews unless canceled at least 24 hours before the end of the current period. Manage or cancel in Settings > Apple ID > Subscriptions.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Link("Privacy Policy", destination: URL(string: Constants.privacyURL)!)
                Link("Terms of Use", destination: URL(string: Constants.termsURL)!)
            }
            .font(.caption)
        }
        .padding(.horizontal, 8)
    }

    private var purchaseButton: some View {
        Button(action: purchase) {
            if purchaseManager.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text("Subscribe")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(purchaseManager.isLoading)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task { await purchaseManager.restorePurchases() }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private func purchase() {
        guard let product = purchaseManager.products.first(where: { $0.id == selectedProductID }) else { return }
        Task {
            let success = await purchaseManager.purchase(product)
            if success {
                dismiss()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline.bold())
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(.green)
        }
    }
}

struct PricingOption: View {
    let product: Product
    let isSelected: Bool
    let badge: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayPrice)
                            .font(.title3.bold())
                        if let badge {
                            Text(badge)
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.green, in: Capsule())
                                .foregroundStyle(.white)
                        }
                    }
                    Text(product.subscription?.subscriptionPeriod.value == 12 ? "per year" :
                         product.subscription?.subscriptionPeriod.value == 1 ? "per month" : "one-time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            }
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
