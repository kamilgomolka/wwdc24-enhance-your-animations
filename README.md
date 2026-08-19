# WWDC24 - Enhance Your UI Animations and Transitions

A small UIKit demo app exploring the animation and transition APIs introduced in the WWDC24 session
[Enhance your UI animations and transitions](https://developer.apple.com/videos/play/wwdc2024/10145/).

Each topic from the session is a self-contained demo, reachable from the main menu as its own button
and backed by an independent view controller. The visual theme follows the session's friendship
bracelets and beads.

## Demos

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

## Agentic Coding (Built with AI)

This repository serves not only as a UI demo, but also as an experiment in AI-assisted development. 

The entire codebase was built using [Cursor](https://cursor.com/) and an agentic workflow (**Plan > Review > Implement > Review**).

## Architecture

- Plain, programmatic UIKit (no Storyboards/XIBs except `LaunchScreen.storyboard`). One `UIViewController`
  per feature under `Source/Features/`, pushed from `MainViewController` inside a `UINavigationController`.
- Pattern: classic UIKit MVC. Models are plain value types (`Bracelet`).
- Shared building blocks live in `Source/Shared/` (`BeadView`, `BraceletPreviewView`, `Bracelet`).
- No third-party dependencies.

```
Source/
  MainViewController.swift          Menu with one button per demo
  Shared/                           Reusable model + views
  Features/
    ZoomTransition/                 Demo 1
    SwiftUIAnimation/               Demo 2
    GestureVelocity/                Demo 3
    BeadThreading/                  Demo 4
```

## Notes on the APIs

- Under Xcode 26's "main actor by default" concurrency mode, `UICollectionViewDiffableDataSource` section
  identifiers must be `Sendable`, so the gallery uses an `Int` section identifier rather than a
  main-actor-isolated enum.

## Requirements

- Xcode with the iOS 26 SDK
- Swift 6 (strict concurrency)
- iOS 26.0+ deployment target

## Running

Open `WWDC24-EnahanceYourAnimations.xcodeproj`, select the `WWDC24-EnahanceYourAnimations` scheme, and run on a
simulator or device. Animations in the session video are shown at half speed; enable Slow Animations
(Simulator > Debug > Slow Animations, or Cmd-T) to inspect them more closely.

## License

MIT — see [LICENSE](LICENSE).
