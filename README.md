### Mobile Application Engineer · Flutter · Kotlin · Clean Architecture

[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-00B4FF?style=for-the-badge)](LICENSE)

</div>

---

## What Is This?

This is my personal portfolio — a **cinematic Flutter Web experience** that goes far beyond a typical developer page. Every interaction is intentional: from the 3.6-second orchestrated preloader to the glowing orb that replaces your system cursor.

> Built with Flutter Web because why not push the platform to its limits.

---

## Visual Effects

### Cinematic Preloader
A 3.6-second choreographed sequence before you ever see the page:
- Ambient floating dots drift across a dark canvas
- **DHIREN** clip-reveals upward with an electric sweep line
- **KOKAL** follows, then skill tags fade in with a progress bar filling to 100%
- Exit: 130 particles explode outward before fading to the main site

### Glowing Orb Cursor
Your system cursor is completely replaced by a custom-painted orb:
- Multi-layer glow: outer diffuse ring → mid ring → inner core → solid dot
- 4-point crosshair lines pulse around the center
- 40-particle trail that fades over 700ms as you move
- Implemented via CSS `cursor: none !important` + Flutter `CustomPainter`

### Animated Mesh Background
A living, breathing backdrop made of 5 radial gradient blobs:
- Organic sine/cosine drift on a 12-second loop
- Parallax reaction to scroll position
- Grid overlay at 60px spacing for a subtle tech aesthetic

### Hero Section Stagger
Every element enters with a precise delay chain via `flutter_animate`:
| Element | Delay |
|---|---|
| "Available for Work" badge | 0ms |
| Name | 150ms |
| Title & subtitle | 300–400ms |
| Summary | 500ms |
| CTA buttons | 650ms |
| Social icons | 800ms |

### Live Counters
Stats that count up from zero when they scroll into view:
```
2    YEARS EXPERIENCE
3    COMPANIES
747K+ LINES OF FLUTTER CODE
```

### Magnetic Buttons
CTAs that physically pull toward your cursor within an 80px radius — `elasticOut` spring-back on exit.

### Light / Dark Theme
Circular wipe animation toggles between themes — no jarring flash.

---

## Tech Stack

```
Framework    Flutter Web (Dart 3.x)
Routing      go_router
Fonts        Inter (UI) + JetBrains Mono (code/stats) via google_fonts
Animations   flutter_animate + AnimationController + CustomPainter
Theme        Material 3 + AppColorTokens ThemeExtension
```

### Dependencies
| Package | Purpose |
|---|---|
| `go_router` | Client-side routing |
| `google_fonts` | Inter + JetBrains Mono |
| `flutter_animate` | Stagger & chain animations |
| `animated_text_kit` | Typewriter effects |
| `url_launcher` | External link handling |

---

## Project Structure

```
lib/
├── core/
│   ├── theme/          # AppColors, AppTextStyles, ThemeExtension
│   └── widgets/
│       ├── cursor/     # GlowingOrbCursor
│       ├── preloader/  # CinematicPreloader
│       └── scaffold/   # PortfolioScaffold + Navbar
├── features/
│   ├── home/           # Hero, LiveCounters, MeshBackground, MagneticButton
│   ├── about/          # (in progress)
│   ├── experience/     # (in progress)
│   ├── skills/         # (in progress)
│   ├── projects/       # (in progress)
│   └── contact/        # (in progress)
└── main.dart           # Preloader → Router boot sequence
```

---

## Design System

**Color Palette**
```
Background      #050A14   (near-black navy)
Cards           #0D1929
Accent          #00B4FF   (electric blue)
Text Primary    #E8F4FD
```

**Breakpoints**
```
Mobile    < 768px
Tablet    < 1100px
Desktop   ≥ 1100px
```

---

## Getting Started

```bash
# Clone
git clone https://github.com/dhirenkokal/dhiren_portfolio.git
cd dhiren_portfolio

# Install dependencies
flutter pub get

# Run in browser
flutter run -d chrome

# Build for production
flutter build web --release
```

> Requires Flutter SDK with web support enabled. Run `flutter doctor` if you hit issues.

---

## About Me

I'm **Dhiren Kokal**, a Mobile Application Engineer based in Mumbai.

- **2+ years** of professional mobile development
- **747K+ lines** of Flutter code shipped at [Binaryveda](https://binaryveda.com)
- MCA graduate, University of Mumbai (2024)
- Currently building an IoT platform with Flutter + Android SDK + HarmonyOS/ArkTS
- Specializing in Kotlin, Jetpack Compose, Clean Architecture, and BLoC

**Find me:**
- Email: dhirenkokal@gmail.com
- GitHub: [@dhirenkokal](https://github.com/dhirenkokal)

---

<div align="center">

**Built with Flutter Web · Designed with obsessive attention to detail**

</div>
