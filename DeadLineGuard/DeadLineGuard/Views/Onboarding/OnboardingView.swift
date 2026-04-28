import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    private let pages = [
        OnboardingPage(icon: "shield.checkered", title: "Never Miss a Deadline",
                       subtitle: "Track all your compliance deadlines in one place. Get timely reminders before they're due."),
        OnboardingPage(icon: "bell.badge.fill", title: "Smart Reminders",
                       subtitle: "Multi-stage alerts at 30, 14, 7, and 1 day before each deadline. Never be caught off guard."),
        OnboardingPage(icon: "list.bullet.clipboard", title: "Stay Organized",
                       subtitle: "Categorize by type, assign responsible parties, and attach documents. Full audit trail included."),
    ]

    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<pages.count, id: \.self) { index in
                VStack(spacing: 24) {
                    Spacer()
                    Image(systemName: pages[index].icon)
                        .font(.system(size: 70))
                        .foregroundStyle(Color.accentColor)
                    Text(pages[index].title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    Text(pages[index].subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Spacer()

                    if index == pages.count - 1 {
                        Button(action: { hasCompletedOnboarding = true }) {
                            Text("Get Started")
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.horizontal, 32)
                    } else {
                        Button(action: { currentPage += 1 }) {
                            Text("Continue")
                                .bold()
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.horizontal, 32)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
}
