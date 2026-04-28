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
        VStack(spacing: 0) {
            // Page Content with TabView (no index display)
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    pageContent(for: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Page Control (below content, not overlapping)
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding(.vertical, 16)

            // Button Area (fixed at bottom with safe area)
            VStack(spacing: 0) {
                if currentPage == pages.count - 1 {
                    Button(action: {
                        hasCompletedOnboarding = true
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .background(Color.accentColor)
                    .cornerRadius(12)
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private func pageContent(for index: Int) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: pages[index].icon)
                .font(.system(size: 80))
                .foregroundStyle(Color.accentColor)
                .padding(.bottom, 16)

            Text(pages[index].title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text(pages[index].subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
}

#Preview {
    OnboardingView()
}