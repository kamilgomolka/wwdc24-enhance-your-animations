import UIKit

final class BraceletPreviewView: UIView {

    // MARK: Properties

    private let beadDiameter: CGFloat

    private let stringLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.separator.cgColor
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private let beadStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Initialization

    init(beadDiameter: CGFloat) {
        self.beadDiameter = beadDiameter
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.addSublayer(stringLayer)
        addSubview(beadStack)
        beadStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        beadStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        beadStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        beadStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration

    func configure(with bracelet: Bracelet) {
        beadStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for color in bracelet.beadColors {
            beadStack.addArrangedSubview(BeadView(color: color, diameter: beadDiameter))
        }
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        stringLayer.path = path.cgPath
    }
}
