# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | DeadLineGuard |
| **Git URL** | git@github.com:asunnyboy861/DeadLineGuard.git |
| **Repo URL** | https://github.com/asunnyboy861/DeadLineGuard |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ❌ **DISABLED** (iOS app distributed via App Store) |

## Policy Pages (Separate Repository)

| Item | Value |
|------|-------|
| **Repository Name** | DeadLineGuard-pages |
| **Git URL** | git@github.com:asunnyboy861/DeadLineGuard-pages.git |
| **Repo URL** | https://github.com/asunnyboy861/DeadLineGuard-pages |
| **Visibility** | Public |
| **GitHub Pages** | ✅ **ENABLED** |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/DeadLineGuard-pages/ | ✅ Live |
| Support | https://asunnyboy861.github.io/DeadLineGuard-pages/support.html | ✅ Live |
| Privacy Policy | https://asunnyboy861.github.io/DeadLineGuard-pages/privacy.html | ✅ Live |
| Terms of Use | https://asunnyboy861.github.io/DeadLineGuard-pages/terms.html | ✅ Live |

## Repository Structure

### Main App Repository
```
DeadLineGuard/
├── DeadLineGuard/                   # iOS App Source Code
│   ├── DeadLineGuard.xcodeproj/     # Xcode Project
│   └── DeadLineGuard/               # Swift Source Files
│       ├── Views/
│       ├── Models/
│       ├── Services/
│       ├── Utilities/
│       └── ...
├── us.md                            # English Development Guide
├── keytext.md                       # App Store Metadata
├── capabilities.md                  # Capabilities Configuration
├── icon.md                          # App Icon Details
├── price.md                         # Pricing Configuration
└── nowgit.md                        # This File
```

### Policy Pages Repository
```
DeadLineGuard-pages/
├── index.html                       # Landing Page
├── support.html                     # Support Page
├── privacy.html                     # Privacy Policy
├── terms.html                       # Terms of Use (subscription)
├── .github/workflows/deploy.yml     # GitHub Pages deployment
└── README.md
```
