import UIKit

final class BeadView: UIView {

    // MARK: Properties

    private let highlightLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.startPoint = CGPoint(x: 0.35, y: 0.3)
        layer.endPoint = CGPoint(x: 1.1, y: 1.1)
        layer.colors = [
            UIColor.white.withAlphaComponent(0.55).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        return layer
    }()

    var color: UIColor {
        didSet { backgroundColor = color }
    }

    // MARK: Initialization

    init(color: UIColor, diameter: CGFloat) {
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        layer.addSublayer(highlightLayer)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        widthAnchor.constraint(equalToConstant: diameter).isActive = true
        heightAnchor.constraint(equalToConstant: diameter).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        highlightLayer.frame = bounds
        highlightLayer.cornerRadius = bounds.width / 2
    }
}
