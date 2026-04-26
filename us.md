# DeadLineGuard - iOS App Development Guide

## Executive Summary

**DeadLineGuard** is a native iOS compliance deadline tracker designed for U.S. small business owners who face 12-20 compliance deadlines per year. Missing a single deadline can result in $500+ fines or business suspension. DeadLineGuard provides multi-stage reminders (30/14/7/1 day), compliance templates, document attachment, audit trail, and auto-recurring deadline creation — all in a mobile-first experience at 6x lower cost than web-only competitors.

**Product Vision**: Be the ONLY native iOS app that combines compliance-specific templates, document attachment, audit trail, and multi-stage reminders at a price point accessible to every small business owner.

**Key Differentiators**:
- Only native iOS compliance deadline tracker with full feature set
- Multi-stage reminders (30/14/7/1 day) vs competitors' single reminder
- Document attachment linked to deadlines
- Audit trail for compliance history
- Auto-recurring deadline creation
- 6x cheaper than NeverFined ($4.99/mo vs $29/mo)
- Offline-first design with local SwiftData storage

## Competitive Analysis

| Feature | DeadLineGuard | NeverFined | Deadline App | ZenBusiness | Apple Reminders |
|---------|--------------|------------|-------------|-------------|-----------------|
| Native iOS App | Yes | No (Web) | Yes | Yes | Yes |
| Compliance Templates | Yes | Yes | No | Partial | No |
| Multi-stage Reminders | 30/14/7/1d | 30/7/1d | No | No | Limited |
| Document Attachment | Yes | No | No | No | No |
| Audit Trail | Yes | No | No | No | No |
| Auto-recurring Deadlines | Yes | Yes | No | No | Yes |
| Widget Support | Yes | No | Yes | No | Yes |
| Offline Mode | Yes | No | Yes | No | Yes |
| Price (monthly) | $4.99 | $29 | $1.99 | Free+ | Free |
| Price (annual) | $39.99 | $348 | N/A | N/A | Free |
| Target Market | Small Biz | Small Biz | General | LLC Formation | General |

**Competitive Advantage**: DeadLineGuard is the ONLY native iOS app combining compliance templates, document attachment, audit trail, and multi-stage reminders at $4.99/mo — 6x cheaper than NeverFined.

## Technical Architecture

| Component | Technology | Reason |
|-----------|-----------|--------|
| UI Framework | SwiftUI | Declarative, modern, native animations |
| Data Persistence | SwiftData (iOS 17+) | Type-safe, automatic schema migration |
| Local Notifications | UserNotifications | No server needed, works offline |
| Cloud Sync (Phase 2) | CloudKit | Apple ecosystem, free tier generous |
| Widgets (Phase 2) | WidgetKit | Home screen deadline preview |
| Documents | PhotosUI + UniformTypeIdentifiers | Image/document attachment |
| Architecture | MVVM + Repository Pattern | Testable, scalable |
| Subscription | StoreKit 2 | Native IAP, async/await |

## Module Structure & File Organization

```
DeadLineGuard/
├── DeadLineGuardApp.swift          # App entry point with SwiftData container
├── Models/
│   ├── ComplianceItem.swift        # SwiftData model for compliance items
│   ├── Document.swift              # SwiftData model for attached documents
│   ├── AuditLog.swift              # SwiftData model for audit trail
│   ├── ComplianceCategory.swift    # Category enum (Tax, License, etc.)
│   ├── ItemStatus.swift            # Status enum (Pending, In Progress, etc.)
│   └── RecurrenceRule.swift        # Recurrence enum (Monthly, Quarterly, etc.)
├── ViewModels/
│   ├── DashboardViewModel.swift    # Dashboard business logic
│   ├── ItemListViewModel.swift     # Item list filtering/sorting
│   ├── AddItemViewModel.swift      # Add/edit item logic
│   └── SettingsViewModel.swift     # Settings management
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift     # Main dashboard with stats
│   │   ├── StatsRowView.swift      # Stats cards (overdue/upcoming/total)
│   │   ├── ComplianceItemCard.swift # Item card component
│   │   └── EmptyStateView.swift    # Empty state placeholder
│   ├── ItemList/
│   │   ├── ItemListView.swift      # Full item list with filters
│   │   └── ItemFilterBar.swift     # Category/status filter bar
│   ├── AddItem/
│   │   ├── AddComplianceItemView.swift  # Add/edit item form
│   │   └── TemplatePickerView.swift     # Compliance template picker
│   ├── Detail/
│   │   ├── ItemDetailView.swift    # Item detail with actions
│   │   └── AuditLogView.swift      # Audit log history
│   ├── Calendar/
│   │   └── CalendarView.swift      # Calendar view of deadlines
│   ├── Settings/
│   │   ├── SettingsView.swift      # App settings
│   │   ├── PaywallView.swift       # Subscription paywall
│   │   └── ContactSupportView.swift # Contact support form
│   └── Onboarding/
│       └── OnboardingView.swift    # First-launch onboarding
├── Services/
│   ├── NotificationService.swift   # Local notification scheduling
│   ├── PurchaseManager.swift       # StoreKit 2 subscription manager
│   └── TemplateService.swift       # Compliance template provider
├── Utilities/
│   ├── Constants.swift             # App-wide constants
│   └── DateHelper.swift            # Date formatting helpers
└── Assets.xcassets/
    ├── AccentColor.colorset/
    └── AppIcon.appiconset/
```

## Implementation Flow

### Step 1: Data Models (SwiftData)
- Create ComplianceItem, Document, AuditLog models
- Define ComplianceCategory, ItemStatus, RecurrenceRule enums
- Set up SwiftData container in App entry point

### Step 2: Notification Service
- Implement NotificationService with multi-stage reminders
- Request notification permission on first launch
- Schedule 30/14/7/1 day reminders + overdue escalation

### Step 3: Dashboard View
- Build DashboardView with stats cards
- Create ComplianceItemCard component
- Add overdue/upcoming sections

### Step 4: Add/Edit Item Flow
- Create AddComplianceItemView form
- Implement TemplatePickerView with US compliance templates
- Handle recurrence rule selection and auto-creation

### Step 5: Item List & Calendar
- Build ItemListView with category/status filters
- Create CalendarView for date-based visualization

### Step 6: Item Detail & Audit Trail
- Build ItemDetailView with mark-complete action
- Implement AuditLogView for compliance history
- Auto-create next recurring item on completion

### Step 7: Subscription & Paywall
- Implement PurchaseManager with StoreKit 2
- Create PaywallView following Apple IAP rules
- Gate Pro features (unlimited items, multi-stage reminders, docs, audit)

### Step 8: Settings & Support
- Build SettingsView with policy links
- Implement ContactSupportView with feedback backend
- Add Restore Purchases button

### Step 9: Onboarding
- Create OnboardingView for first launch
- Request notification permission
- Offer quick template setup

### Step 10: Polish & Testing
- Test on iPhone XS Max and iPad Pro 13-inch (M4)
- Verify all user flows
- Ensure iPad layout is correct

## UI/UX Design Specifications

### Design Philosophy
"Protective Minimalism" — Clean, calm, confident. The app should feel like a reliable guard, not a panic-inducing alarm.

### Color System

| Role | Color | Hex |
|------|-------|-----|
| Primary | Deep Navy | #1B3A5C |
| Accent/Danger | Coral Red | #E85D4A |
| Success | Apple Green | #34C759 |
| Warning | Amber | #FF9500 |
| Info | Sky Blue | #007AFF |
| Background Light | Snow White | #F8F9FA |
| Background Dark | Rich Black | #0D1117 |

### Category Colors

| Category | Color | Icon |
|----------|-------|------|
| Tax | Blue (#007AFF) | dollarsign.circle.fill |
| License | Purple (#AF52DE) | licenseplate.fill |
| Report | Teal (#5AC8FA) | doc.text.fill |
| Insurance | Green (#34C759) | shield.fill |
| Employee | Orange (#FF9500) | person.2.fill |
| Other | Gray (#8E8E93) | folder.fill |

### Typography

| Element | Size | Weight |
|---------|------|--------|
| App Title | 28pt | Bold |
| Section Header | 20pt | Semibold |
| Card Title | 17pt | Headline |
| Card Subtitle | 15pt | Regular |
| Body Text | 15pt | Regular |
| Caption | 13pt | Regular |
| Badge Text | 11pt | Bold |

### Tab Navigation
- Tab 1: Dashboard (house.fill icon)
- Tab 2: Items (list.bullet.clipboard.fill icon)
- Tab 3: Calendar (calendar icon)
- Tab 4: Settings (gearshape.fill icon)

## Code Generation Rules

1. Architecture: MVVM + Repository Pattern
2. Naming: Swift API Design Guidelines; camelCase for variables, PascalCase for types
3. No comments in code unless asked
4. Error Handling: Result<Success, Error> for async; try? only for non-critical
5. Concurrency: async/await + @MainActor for UI updates
6. Data Flow: SwiftData @Query for reads; modelContext.insert/save for writes
7. Notifications: Always request permission on first launch
8. ALL SwiftData attributes MUST be optional OR have a default value
9. ALL SwiftData relationships MUST have inverse relationships
10. NEVER use .tabViewStyle(.sidebarAdaptable)
11. For main content in ScrollView, ALWAYS add .frame(maxWidth: 720).frame(maxWidth: .infinity)
12. Do NOT use ObservableObject conformance on views already marked with @Observable
13. Do NOT use iOS 18+ only APIs when targeting iOS 17+
14. Use Color.accentColor instead of ShapeStyle.accent
15. NEVER hardcode version numbers - always read from Bundle.main
16. Dynamic pricing from StoreKit - NEVER hardcode prices
17. No dark patterns in paywall - user must actively select plan
18. Plans sorted by price (cheapest first)

## Testing & Validation Standards

- Test on iPhone XS Max (primary phone)
- Test on iPad Pro 13-inch (M4) (primary tablet)
- Verify all user flows: add item, mark complete, edit, delete
- Verify notification scheduling and cancellation
- Verify subscription flow: purchase, restore, status check
- Verify iPad layout: no narrow sidebar, proper content width
- Verify free tier limits: max 3 items, 1-day reminder only
- Verify Pro features: unlimited items, multi-stage reminders, docs, audit

## Build & Deployment Checklist

1. Bundle ID: com.zzoutuo.DeadLineGuard
2. Minimum iOS: 17.0
3. Version: Read from Xcode project settings (1.0.0)
4. Build: Verify on both iPhone and iPad simulators
5. Push to GitHub: asunnyboy861/DeadLineGuard
6. Policy Pages: Deploy to asunnyboy861/DeadLineGuard-pages
7. App Store Connect: Submit with keytext.md metadata
8. Screenshots: iPhone 1242x2688, iPad 2064x2752
