import SwiftUI
import UIKit

final class ThreadedBraceletView: UIView {

    // MARK: Properties

    private let beadDiameter: CGFloat
    private(set) var beads: [BraceletBead] = []
    private var beadViews: [BeadView] = []
    private var showsInsertionSlot = false
    private var currentStringPolyline: [CGPoint] = []

    private let stringLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.separator.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3.0
        layer.lineCap = .round
        layer.lineJoin = .round
        return layer
    }()

    // MARK: Initialization

    init(beadDiameter: CGFloat) {
        self.beadDiameter = beadDiameter
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(stringLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration

    func configure(with beads: [BraceletBead]) {
        beadViews.forEach { $0.removeFromSuperview() }
        showsInsertionSlot = false
        self.beads = beads
        beadViews = beads.map { bead in
            let beadView = BeadView(color: bead.color, symbol: bead.symbol, diameter: beadDiameter)
            beadView.isUserInteractionEnabled = false
            // Spring-animated beads are positioned via `.center`, not Auto Layout, matching
            // the convention in BeadFlingViewController/BeadSpringViewController.
            beadView.translatesAutoresizingMaskIntoConstraints = true
            addSubview(beadView)
            return beadView
        }
        layoutBeads()
    }

    /// Reserves (or clears) an extra trailing slot in the layout, compressing the existing
    /// beads to the left to signal where a dropped bead would land.
    func setShowsInsertionSlot(_ shows: Bool) {
        guard showsInsertionSlot != shows else { return }
        showsInsertionSlot = shows
        UIView.animate(.spring) {
            self.layoutBeads(animatingString: true)
        }
    }

    /// Center of the reserved trailing slot, in this view's coordinate space, or `nil` if no
    /// slot is currently reserved.
    func insertionSlotCenter() -> CGPoint? {
        guard showsInsertionSlot else { return nil }
        return slotCenters(count: beads.count + 1).last
    }

    /// Adopts an already-positioned `BeadView` (typically the one that was just dragged onto
    /// `insertionSlotCenter()`) as the newest, permanent bead on the string.
    func append(_ bead: BraceletBead, view: BeadView) {
        showsInsertionSlot = false
        beads.append(bead)
        view.isUserInteractionEnabled = false
        addSubview(view)
        beadViews.append(view)
        layoutBeads()
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBeads()
    }

    // MARK: Private functions

    /// - Parameter animatingString: `UIView.animate(_:changes:)` drives its SwiftUI `Animation`
    ///   by interpolating animatable `UIView` properties (like `center`, used for the beads
    ///   below); it doesn't touch arbitrary `CALayer` properties. `stringLayer.path` needs its
    ///   own explicit Core Animation to visually keep up with the beads while a slot opens/closes.
    private func layoutBeads(animatingString: Bool = false) {
        let slotCount = beads.count + (showsInsertionSlot ? 1 : 0)
        let centers = slotCenters(count: slotCount)
        for (beadView, center) in zip(beadViews, centers) {
            beadView.center = center
        }

        currentStringPolyline = polylinePoints(through: centers)
        stringLayer.frame = bounds
        let path = stringPath(through: currentStringPolyline).cgPath
        if animatingString {
            animateStringPath(to: path)
        } else {
            stringLayer.path = path
        }
    }

    /// Approximates SwiftUI's `.spring` timing/bounce so the string visually settles in sync
    /// with the beads, which are already driven by that same animation via `UIView.animate`.
    private func animateStringPath(to path: CGPath) {
        let animation = CASpringAnimation(keyPath: "path")
        animation.fromValue = stringLayer.path
        animation.toValue = path
        animation.mass = 1
        animation.stiffness = 158
        animation.damping = 21
        animation.initialVelocity = 0
        animation.duration = animation.settlingDuration
        stringLayer.add(animation, forKey: "stringPath")
        stringLayer.path = path
    }

    private func slotCenters(count: Int) -> [CGPoint] {
        guard count > 0 else { return [] }

        let horizontalInset = beadDiameter * 0.75
        let usableWidth = max(bounds.width - horizontalInset * 2.0, 0)
        let spacing = count > 1 ? usableWidth / CGFloat(count - 1) : 0
        let amplitude = beadDiameter * 0.4

        return (0..<count).map { index in
            let x = horizontalInset + spacing * CGFloat(index)
            let y = bounds.midY + amplitude * sin(CGFloat(index) * 1.3)
            return CGPoint(x: x, y: y)
        }
    }

    private func polylinePoints(through centers: [CGPoint]) -> [CGPoint] {
        guard let first = centers.first, let last = centers.last else { return [] }

        let tailLength = beadDiameter * 0.9
        let tailStart = point(from: first, angle: .pi * 0.83, length: tailLength)
        let tailEnd = point(from: last, angle: .pi * 0.17, length: tailLength)
        return [tailStart] + centers + [tailEnd]
    }

    private func stringPath(through polyline: [CGPoint]) -> UIBezierPath {
        guard let first = polyline.first else { return UIBezierPath() }

        let path = UIBezierPath()
        path.move(to: first)
        for point in polyline.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }

    private func point(from origin: CGPoint, angle: CGFloat, length: CGFloat) -> CGPoint {
        CGPoint(x: origin.x + cos(angle) * length, y: origin.y + sin(angle) * length)
    }
}
