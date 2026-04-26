# Capabilities Configuration Guide

## Configuration Summary

### No Capabilities Required
| Capability | Status | Notes |
|------------|--------|-------|
| **None** | Skipped | No special capabilities needed for this app |

**Why no capabilities needed**: DeadLineGuard uses local SwiftData storage and UserNotifications framework. The app does not require Camera, Photo Library, Location, iCloud, HealthKit, or any other special hardware/service access. Notifications are handled through the standard UserNotifications framework which only requires the INFOPLIST_KEY_NSUserNotificationsUsageDescription build setting.

**Verification**: Build succeeded without any capabilities enabled

---

## Build Settings Configured

| Setting | Value | Purpose |
|---------|-------|---------|
| PRODUCT_BUNDLE_IDENTIFIER | com.zzoutuo.DeadLineGuard | App Bundle ID |
| MARKETING_VERSION | 1.0.0 | App version |
| CURRENT_PROJECT_VERSION | 1 | Build number |
| IPHONEOS_DEPLOYMENT_TARGET | 17.0 | Minimum iOS version |
| GENERATE_INFOPLIST_FILE | YES | Auto-generate Info.plist |
| INFOPLIST_KEY_NSUserNotificationsUsageDescription | "DeadLineGuard needs to send you notifications..." | Notification permission |

---

## Summary Checklist

### Auto-Configured (Verified)
- [x] Bundle ID set to com.zzoutuo.DeadLineGuard
- [x] Marketing Version set to 1.0.0
- [x] iOS Deployment Target set to 17.0
- [x] Notification permission description added
- [x] No capabilities needed - build succeeded
