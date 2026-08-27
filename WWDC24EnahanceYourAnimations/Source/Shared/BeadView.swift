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

    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var color: UIColor {
        didSet {
            backgroundColor = color
            symbolLabel.textColor = Self.contrastingTextColor(for: color)
            symbolImageView.tintColor = Self.contrastingTextColor(for: color)
        }
    }

    // MARK: Initialization

    init(color: UIColor, symbol: String = "", systemImageName: String? = nil, diameter: CGFloat) {
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

        symbolLabel.text = symbol
        symbolLabel.font = .systemFont(ofSize: diameter * 0.42, weight: .semibold)
        symbolLabel.textColor = Self.contrastingTextColor(for: color)
        addSubview(symbolLabel)
        symbolLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        if let systemImageName {
            let configuration = UIImage.SymbolConfiguration(pointSize: diameter * 0.42, weight: .semibold)
            symbolImageView.image = UIImage(systemName: systemImageName, withConfiguration: configuration)
            symbolImageView.tintColor = Self.contrastingTextColor(for: color)
            addSubview(symbolImageView)
            symbolImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            symbolImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
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

    // MARK: Private functions

    private static func contrastingTextColor(for color: UIColor) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            .getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.6 ? .black : .white
    }
}
