![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white) ![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green) ![Encryption](https://img.shields.io/badge/Encryption-AES--256-red) ![License](https://img.shields.io/badge/License-Open%20Source-blue) ![Status](https://img.shields.io/badge/Status-v1.0-orange) ![Lang](https://img.shields.io/badge/Lang-ES%20%7C%20EN-yellow)

# 🔐 PhantomKey

**Your passwords, invisible to everyone.**

PhantomKey is a fully offline, secure password manager built with Flutter. All credentials are encrypted with AES-256-CBC and stored exclusively on-device using platform-native secure storage (Keychain on iOS, Keystore on Android). No servers. No cloud. No tracking.

---

## ✨ Features

### 🛡️ Security First
- **AES-256-CBC Encryption** — Military-grade encryption with random IV per operation
- **Biometric Authentication** — Face ID (iPhone X+), Fingerprint (Android), or device PIN
- **Zero Cloud Dependency** — All data stays on your device, always
- **Secure Storage** — Uses platform Keychain (iOS) and Keystore (Android)

### 🎨 Modern UI/UX
- **Liquid Glass Design** — Translucent cards with blur effects and ambient gradients
- **Living Background** — Organic, constantly flowing gradient animation using trigonometric functions
- **Dark & Light Themes** — Smooth animated toggle with warm sunset palette (dark) and elegant beige tones (light)
- **Fluid Animations** — Fade, scale, and slide transitions across all screens

### 🔑 Password Management
- **Password Generator** — Configurable length (6-32), uppercase, lowercase, numbers, symbols
- **Strength Indicator** — Real-time password strength evaluation with visual feedback
- **Smart Categories** — Social Media, Work, Bank, Academic with color-coded organization
- **Search & Filter** — Instant search across all credentials with category filtering
- **One-Tap Copy** — Copy usernames, passwords, and URLs to clipboard instantly

### 🌐 Multi-Language
- **Spanish & English** — Full localization with instant language switching
- **Dynamic UI** — All labels, messages, and categories update in real-time

---

## 📱 Screens

| Lock Screen | Home | Settings |
|:-----------:|:----:|:--------:|
| Biometric auth with animated shield | Credential list with search & categories | Theme, language & security info |

| Add Credential | Detail | Generator |
|:--------------:|:------:|:---------:|
| Form with auto-generate | View, copy & delete | Configurable password generation |

---

## 🏗️ Architecture

```
lib/
├── main.dart                          # Entry point + Provider + DevicePreview
├── models/
│   └── credential.dart                # Data model (JSON serializable)
├── services/
│   ├── crypto_service.dart            # AES-256 encryption + password generator
│   └── storage_service.dart           # Secure local storage (Keychain/Keystore)
├── providers/
│   └── vault_provider.dart            # Global state (CRUD + filters + theme + language)
├── screens/
│   ├── lock_screen.dart               # Biometric authentication
│   ├── home_screen.dart               # Dashboard + categories + search
│   ├── detail_screen.dart             # Credential detail view
│   ├── add_credential_screen.dart     # New credential form
│   ├── generator_screen.dart          # Password generator
│   └── settings_screen.dart           # Theme, language, app info
├── widgets/
│   ├── glass_card.dart                # GlassCard, GlassChip, GlassButton
│   └── living_background.dart         # Animated flowing gradient background
└── utils/
    ├── constants.dart                 # Dual color palette + categories
    └── app_strings.dart               # EN/ES localization strings
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|:-----------|:--------|
| **Flutter 3.41+** | Cross-platform framework |
| **Dart** | Programming language |
| **Provider** | State management |
| **flutter_secure_storage** | Encrypted local storage |
| **local_auth** | Biometric authentication |
| **encrypt** | AES-256-CBC encryption |
| **uuid** | Unique credential IDs |
| **device_preview** | Device frame preview |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.41+
- Android Studio (for Android SDK)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/JF012/PhantomKey-App-v1.0.git

# Navigate to project
cd PhantomKey-App-v1.0

# Install dependencies
flutter pub get

# Run on Edge/Chrome
flutter run -d edge

# Run on Android device
flutter run -d android
```

---

## 🔒 Security Details

| Feature | Implementation |
|:--------|:---------------|
| Encryption | AES-256-CBC with random IV per operation |
| Key Storage | Platform Keychain (iOS) / Keystore (Android) |
| Biometrics | Face ID, Fingerprint, Iris, PIN fallback |
| Data Location | 100% on-device, zero network calls |
| Password Generation | `Random.secure()` for cryptographic randomness |

---

## 🎨 Design Philosophy

PhantomKey follows a **Liquid Glass** design language inspired by modern fintech apps:

- **Glassmorphism** — Semi-transparent cards with backdrop blur
- **Ambient Gradients** — Living background with 5 organic blobs using non-linear trigonometric motion
- **Warm Palette** — Coral (#FF6B4A), Amber (#FF9F43), Gold (#FFD93D) on deep dark backgrounds
- **Micro-Interactions** — Every transition is animated: theme changes, screen navigation, biometric feedback

---

## 📄 License

This project is open source and available for educational and portfolio purposes.

---

<p align="center">
  Made with Flutter 💙 by <a href="https://github.com/JF012">JF012</a>
</p>

