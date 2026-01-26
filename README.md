# 🐱 Pomonya (Clean Arcade Pomodoro)

**Pomonya** is a stylish, arcade-inspired Pomodoro timer designed to help you stay focused and productive while accompanied by a cute companion named **Mpus**. With a "Clean Arcade" aesthetic featuring neon accents, glassmorphism, and smooth animations, productivity has never looked this good.

![Pomonya Banner](https://raw.githubusercontent.com/nofalbriansah/pomonya/main/web/favicon.png)

## ✨ Features

- 🕒 **Dynamic Timers**: Toggle between Focus, Short Break, and Long Break sessions.
- 🐈 **Interactive Companion**: **Mpus** reacts to your progress via Rive animations.
- 🎮 **Gamified Productivity**: Earn rewards as you complete focus sessions.
- 🛒 **The Shop**: Customize your experience with skins and hats for Mpus.
- 📊 **Insightful Stats**: Track your productivity trends with beautiful charts.
- 🎨 **Clean Arcade UI**: A premium dark-mode interface with neon fuchsia and electric blue highlights.
- 🎵 **Lofi & SFX**: Integrated audio to keep you in the flow.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Linux build tools (if running on Linux)

### Installation

1. **Clone the repository:**
   ```bash
   git clone git@github.com:nofalbriansah/pomonya.git
   cd pomonya
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run -d linux
   ```

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Riverpod](https://riverpod.dev)
- **Animations**: [Rive](https://rive.app)
- **Local Database**: [Hive](https://hivedb.dev)
- **UI Components**: [Google Fonts](https://fonts.google.com), [fl_chart](https://pub.dev/packages/fl_chart)
- **Audio**: [audioplayers](https://pub.dev/packages/audioplayers)

## 🎨 Aesthetic Design

Pomonya utilizes a curated "Clean Arcade" color palette:
- **Deep Background**: `#0B0E14` (The void)
- **Surface Dark**: `#161B28` (Glass panels)
- **Electric Blue**: `#00F0FF` (The energy)
- **Neon Fuchsia**: `#F0ABFC` (The highlight)

## 📝 Troubleshooting (Linux)

If you encounter build errors on Linux related to `rive_common` or `harfbuzz`, ensure that the `-Werror` flag is removed from your `linux/CMakeLists.txt` to allow compatibility with newer compilers.

---

Made with ❤️ by [nofalbriansah](https://github.com/nofalbriansah)
