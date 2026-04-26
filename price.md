# Price Configuration

## Monetization Model
Auto-renewable Subscription (IAP Required)

## Subscription Group
Group Name: DeadLineGuard Pro

### Tier 0: Free (Always Available)
- **Type**: Free (limited features)
- **Features**: 3 compliance items, 1-day-before reminder only, calendar view, manual add items, basic categories
- **Purpose**: User acquisition, trial experience

### Tier 1: Monthly Subscription
- **Reference Name**: DeadLineGuard Pro Monthly
- **Product ID**: com.zzoutuo.DeadLineGuard.pro.monthly
- **Price**: $4.99 (USD)
- **Subscription Period**: 1 Month
- **Localization (English US)**:
  - Display Name: DeadLineGuard Pro Monthly (max 35 chars)
  - Description: Unlock all premium features (max 55 chars)

### Tier 2: Yearly Subscription
- **Reference Name**: DeadLineGuard Pro Yearly
- **Product ID**: com.zzoutuo.DeadLineGuard.pro.yearly
- **Price**: $39.99 (USD)
- **Subscription Period**: 1 Year
- **Localization (English US)**:
  - Display Name: DeadLineGuard Pro Yearly (max 35 chars)
  - Description: Save 33% with annual plan (max 55 chars)

### Tier 3: Lifetime (Non-consumable)
- **Include**: YES (App has NO API costs or usage-based costs)
- **Reference Name**: DeadLineGuard Pro Lifetime
- **Product ID**: com.zzoutuo.DeadLineGuard.pro.lifetime
- **Price**: $99.99 (USD)
- **Type**: Non-consumable (One-time, no renewal)
- **Localization (English US)**:
  - Display Name: DeadLineGuard Pro Lifetime (max 35 chars)
  - Description: One-time purchase, forever access (max 55 chars)

## App Store Connect Setup Instructions
1. Go to App Store Connect → Your App → Subscriptions
2. Create Subscription Group: "DeadLineGuard Pro"
3. Add subscriptions with above Product IDs
4. Configure localizations for each
5. Submit for review

## IAP Compliance Checklist (REQUIRED for Subscription Apps)
- [ ] Paywall displays subscription names
- [ ] Paywall displays subscription durations
- [ ] Dynamic pricing from StoreKit (no hardcoded prices)
- [ ] Renewal terms displayed: "Subscription automatically renews unless canceled..."
- [ ] Cancellation instructions displayed
- [ ] Free trial clause displayed (if applicable)
- [ ] Restore Purchases button implemented
- [ ] Privacy Policy link on paywall
- [ ] Terms of Use link on paywall
- [ ] NO dark patterns (no auto-selecting expensive options)
- [ ] Lifetime tier included (no API costs)
