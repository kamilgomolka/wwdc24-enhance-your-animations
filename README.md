# WWDC24 — Enhance Your UI Animations and Transitions

[![Swift](https://img.shields.io/badge/Swift-6.0-F05138.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/iOS-26.0%2B-000000.svg)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-26-1575F9.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

A small UIKit demo exploring the animation and transition APIs from the WWDC24 session [Enhance your UI animations and transitions](https://developer.apple.com/videos/play/wwdc2024/10145/). Each topic is a self-contained screen, reachable from the main menu. The visual theme follows the session's friendship bracelets and beads.

## What It Shows

| Demo | What it shows | Key API |
| --- | --- | --- |
| Zoom Transition | Tap a bracelet cell to zoom into its detail screen; the transition is interactive. | `UIViewController.preferredTransition = .zoom { context in ... }` |
| SwiftUI Animation on UIView | Tap to fling a bead across the screen using a chosen SwiftUI animation. | `UIView.animate(_ animation: SwiftUI.Animation, changes:)` |
| Gesture Continuous Velocity | Drag and fling a bead; the release preserves the gesture's velocity. | `.interactiveSpring` during the gesture, `.spring` on release, via `UIView.animate(_:changes:)` |
| Bead Threading | Drag a bead from a tray toward the bracelet string; nearby beads spring open a slot at the end, signaling where it will land. | Same `.interactiveSpring`/`.spring` pair, coordinating a multi-view spring reflow across two custom views |

All APIs require iOS 18 or later.

## Screenshots / Recordings

<img width="434" height="908" alt="Screenshot 2026-07-16 at 14 45 14" src="https://github.com/user-attachments/assets/4b685879-9e75-46d7-8974-57f44d1f10bb" />

https://github.com/user-attachments/assets/399831a4-96c2-41ac-b014-b1671271ee26

https://github.com/user-attachments/assets/04d655ce-d150-4da9-8bab-ae39a9ea9c66

## Architecture

Plain, programmatic UIKit — no Storyboards/XIBs except `LaunchScreen.storyboard`, no third-party dependencies. One `UIViewController` per feature under `Source/Features/`, pushed onto a single `UINavigationController` rooted at `MainViewController` (wired up in `SceneDelegate`).

Classic UIKit MVC. Models are plain value types (`Bracelet`). Shared building blocks live in `Source/Shared/` (`BeadView`, `BraceletPreviewView`, `Bracelet`).

Under Xcode 26's `MainActor` default isolation, `UICollectionViewDiffableDataSource` section identifiers must be `Sendable`, so the gallery uses an `Int` section identifier rather than a main-actor-isolated enum.

```
Config/
├── Local.xcconfig.example                  # Template for the untracked Local.xcconfig (Team ID)
└── WWDC24EnahanceYourAnimations.xcconfig   # Platform, Swift, signing, versioning, Info.plist keys

WWDC24EnahanceYourAnimations/
├── Source/
│   ├── Application/
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── MainViewController.swift            # Entry point: one button per feature
│   ├── Shared/                             # Bracelet model + BeadView / BraceletPreviewView
│   └── Features/
│       ├── ZoomTransition/                 # Demo 1
│       ├── SwiftUIAnimation/               # Demo 2
│       ├── GestureVelocity/                # Demo 3
│       └── BeadThreading/                  # Demo 4
└── SupportingFiles/
    ├── Assets.xcassets
    ├── Base.lproj/LaunchScreen.storyboard
    └── Info.plist                          # Scene manifest only; the rest comes from xcconfig
```

Xcode's own default warning flags still live in `project.pbxproj`; everything this project decides for itself lives in `Config/`.

## Requirements

- Xcode 26 or later
- iOS 26.0+ (`IPHONEOS_DEPLOYMENT_TARGET`) 
- Swift 6 language mode, strict concurrency, strict memory safety, `MainActor` default isolation

## Getting Started

```bash
git clone https://github.com/kamilgomolka/wwdc24-enhance-your-animations.git
cd wwdc24-enhance-your-animations
open WWDC24EnahanceYourAnimations.xcodeproj
```

Build and run the `WWDC24EnahanceYourAnimations` scheme on an iOS 26+ Simulator. Signing is not required for the Simulator. To run on a device, copy the local configuration template and fill in your Apple Developer Team ID:

```bash
cp Config/Local.xcconfig.example Config/Local.xcconfig
```

`Config/Local.xcconfig` is untracked, so no Team ID ever lands in version control.

Animations in the session video are shown at half speed; enable Slow Animations (Simulator > Debug > Slow Animations, or Cmd-T) to inspect them more closely.

## Tooling

```bash
make build         # compile for the Simulator
make format        # apply swift-format in place
make destinations  # list available Simulator destinations
```

`swift-format` ships with the Xcode toolchain, so there is nothing to install. Override the Simulator with `make build SIMULATOR='iPhone 17 Pro'`. Format on save is an editor setting, not a repo hook.

## Built with an Agentic Workflow

This repository doubles as an experiment in AI-assisted development. The specification, architectural decisions, code review, and verification are mine; [Cursor](https://cursor.com/) executes against them in a **Plan > Review > Implement > Review** loop. Nothing lands without passing the review step and a green CI run.

## License

MIT — see [LICENSE](LICENSE).
