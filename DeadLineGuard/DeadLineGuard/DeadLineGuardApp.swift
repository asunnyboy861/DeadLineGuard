import SwiftUI
import SwiftData

@main
struct DeadLineGuardApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                        .environmentObject(purchaseManager)
                } else {
                    OnboardingView()
                }
            }
            .task {
                _ = try? await NotificationService.shared.requestAuthorization()
            }
        }
        .modelContainer(for: [ComplianceItem.self, DocumentAttachment.self, AuditLog.self])
    }
}

struct MainTabView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)
            ItemListView()
                .tabItem {
                    Label("Items", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(1)
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            SettingsView(purchaseManager: purchaseManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }
}
