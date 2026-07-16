import SwiftUI
import UIKit

final class BeadTrayView: UIView {

    // MARK: Properties

    private let beadDiameter: CGFloat
    private(set) var beads: [BraceletBead] = []
    private(set) var beadViews: [BeadView] = []

    // MARK: Initialization

    init(beadDiameter: CGFloat) {
        self.beadDiameter = beadDiameter
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration

    func configure(with beads: [BraceletBead]) {
        beadViews.forEach { $0.removeFromSuperview() }
        self.beads = beads
        beadViews = beads.map { bead in
            let beadView = BeadView(color: bead.color, symbol: bead.symbol, diameter: beadDiameter)
            // Spring-animated beads are positioned via `.center`, not Auto Layout, matching
            // the convention in BeadFlingViewController/BeadSpringViewController.
            beadView.translatesAutoresizingMaskIntoConstraints = true
            addSubview(beadView)
            return beadView
        }
        layoutBeads()
    }

    /// Removes bookkeeping for the bead at `index` (its view is left in the hierarchy for the
    /// caller to reparent elsewhere) and animates the remaining beads to close the gap.
    @discardableResult
    func extract(at index: Int) -> BeadView {
        let view = beadViews.remove(at: index)
        beads.remove(at: index)
        UIView.animate(.spring) {
            self.layoutBeads()
        }
        return view
    }

    /// Reinserts a previously extracted bead at `index`. `view.center` must already be
    /// expressed in this view's coordinate space before calling this (the caller converts and
    /// re-parents it beforehand) so the insertion itself causes no visual jump; the spring below
    /// then opens a gap for it alongside the rest of the row.
    func insert(_ bead: BraceletBead, view: BeadView, at index: Int) {
        let clampedIndex = min(index, beads.count)
        beads.insert(bead, at: clampedIndex)
        beadViews.insert(view, at: clampedIndex)
        addSubview(view)
        UIView.animate(.spring) {
            self.layoutBeads()
        }
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBeads()
    }

    // MARK: Private functions

    private func layoutBeads() {
        for (beadView, center) in zip(beadViews, slotCenters(count: beadViews.count)) {
            beadView.center = center
        }
    }

    private func slotCenters(count: Int) -> [CGPoint] {
        guard count > 0 else { return [] }
        guard count > 1 else { return [CGPoint(x: bounds.midX, y: bounds.midY)] }

        let horizontalInset = beadDiameter * 0.6
        let usableWidth = max(bounds.width - horizontalInset * 2.0, 0)
        let spacing = usableWidth / CGFloat(count - 1)

        return (0..<count).map { index in
            CGPoint(x: horizontalInset + spacing * CGFloat(index), y: bounds.midY)
        }
    }
}
