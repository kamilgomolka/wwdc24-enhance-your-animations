# Enhance Your UI Animations and Transitions

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
| Animating Representables | A SwiftUI view opens/closes a UIKit bead box lid; the SwiftUI animation bridges into the UIView. | `UIViewRepresentableContext.animate(changes:)` |
| Gesture Continuous Velocity | Drag and fling a bead; the release preserves the gesture's velocity. | `.interactiveSpring` during the gesture, `.spring` on release, via `UIView.animate(_:changes:)` |

All four APIs require iOS 18 or later.

## Architecture

- Plain, programmatic UIKit (no Storyboards/XIBs except `LaunchScreen.storyboard`). One `UIViewController`
  per feature under `Source/Features/`, pushed from `MainViewController` inside a `UINavigationController`.
- Pattern: classic UIKit MVC. Models are plain value types (`Bracelet`). The Representables demo is
  SwiftUI (`BeadBoxRepresentable` + `BeadBoxDemoView`) hosted in a `UIHostingController` subclass, showing
  how to mix SwiftUI into a UIKit app.
- Shared building blocks live in `Source/Shared/` (`BeadView`, `BraceletPreviewView`, `Bracelet`).
- No third-party dependencies.

```
Source/
  MainViewController.swift          Menu with one button per demo
  Shared/                           Reusable model + views
  Features/
    ZoomTransition/                 Demo 1
    SwiftUIAnimation/               Demo 2
    Representables/                 Demo 3
    GestureVelocity/                Demo 4
```

## Notes on the APIs

- The session slide uses `$isOpen.animated()` on the binding. That helper is not part of the public SDK,
  so the Representables demo uses the documented `withAnimation(_:)` instead; `context.animate` still reads
  the animation from the current transaction.
- Under Xcode 26's "main actor by default" concurrency mode, `UICollectionViewDiffableDataSource` section
  identifiers must be `Sendable`, so the gallery uses an `Int` section identifier rather than a
  main-actor-isolated enum.

## Requirements

- Xcode with the iOS 26 SDK
- Swift 6 (strict concurrency)
- iOS 18+ deployment target (project targets iOS 26.0)

## Running

Open `WWDC24-EnahanceYourAnimations.xcodeproj`, select the `NewAppBoilerplateUIKit` scheme, and run on a
simulator or device. Animations in the session video are shown at half speed; enable Slow Animations
(Simulator > Debug > Slow Animations, or Cmd-T) to inspect them more closely.
