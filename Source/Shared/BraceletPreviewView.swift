import UIKit

final class BraceletPreviewView: UIView {

    // MARK: Properties

    private let beadDiameter: CGFloat
    private var beadViews: [BeadView] = []

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

    func configure(with bracelet: Bracelet) {
        beadViews.forEach { $0.removeFromSuperview() }
        beadViews = bracelet.beads.map { bead in
            let beadView = BeadView(color: bead.color, symbol: bead.symbol, diameter: beadDiameter)
            addSubview(beadView)
            return beadView
        }
        setNeedsLayout()
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let centers = beadCenters()
        for (beadView, center) in zip(beadViews, centers) {
            beadView.center = center
        }

        stringLayer.frame = bounds
        stringLayer.path = stringPath(through: centers).cgPath
    }

    // MARK: Private functions

    private func beadCenters() -> [CGPoint] {
        guard !beadViews.isEmpty else { return [] }

        let count = beadViews.count
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

    private func stringPath(through centers: [CGPoint]) -> UIBezierPath {
        guard let first = centers.first, let last = centers.last else {
            return UIBezierPath()
        }

        let tailLength = beadDiameter * 0.9
        let tailStart = point(from: first, angle: .pi * 0.83, length: tailLength)
        let tailEnd = point(from: last, angle: .pi * 0.17, length: tailLength)

        let path = UIBezierPath()
        path.move(to: tailStart)
        for center in centers + [tailEnd] {
            path.addLine(to: center)
        }
        return path
    }

    private func point(from origin: CGPoint, angle: CGFloat, length: CGFloat) -> CGPoint {
        CGPoint(x: origin.x + cos(angle) * length, y: origin.y + sin(angle) * length)
    }
}
