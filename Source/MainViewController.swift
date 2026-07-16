import UIKit

class MainViewController: UIViewController {

    private enum Demo: CaseIterable {
        case zoomTransition
        case swiftUIAnimation
        case representables
        case continuousVelocity

        var title: String {
            switch self {
            case .zoomTransition: "Zoom Transition"
            case .swiftUIAnimation: "SwiftUI Animation on UIView"
            case .representables: "Animating Representables"
            case .continuousVelocity: "Gesture Continuous Velocity"
            }
        }

        var subtitle: String {
            switch self {
            case .zoomTransition: "Tap a bracelet to zoom into its editor"
            case .swiftUIAnimation: "Drive UIView springs with SwiftUI animations"
            case .representables: "Bridge SwiftUI animations into a UIView via context.animate"
            case .continuousVelocity: "Fling a bead and preserve gesture velocity"
            }
        }

        func makeViewController() -> UIViewController {
            switch self {
            case .zoomTransition: BraceletGalleryViewController()
            case .swiftUIAnimation: BeadSpringViewController()
            case .representables: RepresentableAnimationViewController()
            case .continuousVelocity: BeadFlingViewController()
            }
        }

        var iconSystemName: String {
            switch self {
            case .zoomTransition: "arrow.up.left.and.arrow.down.right"
            case .swiftUIAnimation: "wand.and.stars"
            case .representables: "shippingbox.fill"
            case .continuousVelocity: "hand.draw.fill"
            }
        }

        var accentColor: UIColor {
            switch self {
            case .zoomTransition: .systemIndigo
            case .swiftUIAnimation: .systemPink
            case .representables: .systemTeal
            case .continuousVelocity: .systemOrange
            }
        }
    }

    // MARK: Properties
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16.0,
            leading: 16.0,
            bottom: 16.0,
            trailing: 16.0
        )
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 14.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Enhance Your UI Animations"
        view.backgroundColor = .systemGroupedBackground
        
        addSubviews()
        createConstraints()
    }
    
    // MARK: View setup
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        for demo in Demo.allCases {
            stackView.addArrangedSubview(makeButton(for: demo))
        }
    }
    
    private func createConstraints() {
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    // MARK: Factories
    
    private func makeButton(for demo: Demo) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.title = demo.title
        configuration.subtitle = demo.subtitle
        configuration.titleAlignment = .leading
        configuration.background = makeCardBackground(highlighted: false)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 76, bottom: 18, trailing: 40)
        configuration.titlePadding = 4.0
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .preferredFont(forTextStyle: .headline)
            attributes.foregroundColor = .label
            return attributes
        }
        configuration.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .preferredFont(forTextStyle: .footnote)
            attributes.foregroundColor = .secondaryLabel
            return attributes
        }

        let button = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.present(demo)
        })
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowRadius = 10.0
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.configurationUpdateHandler = { [weak self] button in
            guard let self else { return }
            button.configuration?.background = self.makeCardBackground(highlighted: button.isHighlighted)
        }

        addAccessories(to: button, for: demo)
        return button
    }
    
    private func makeCardBackground(highlighted: Bool) -> UIBackgroundConfiguration {
        var background = UIBackgroundConfiguration.clear()
        background.backgroundColor = highlighted ? .systemGray5 : .systemBackground
        background.strokeColor = .systemGray4
        background.strokeWidth = 1.0
        background.cornerRadius = 18.0
        return background
    }
    
    private func makeIconBadge(for demo: Demo) -> UIView {
        let badge = UIView()
        badge.backgroundColor = demo.accentColor
        badge.layer.cornerRadius = 12.0
        badge.layer.cornerCurve = .continuous
        badge.isUserInteractionEnabled = false
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        let imageView = UIImageView(image: UIImage(systemName: demo.iconSystemName))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 19.0, weight: .semibold)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        badge.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: badge.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: badge.centerYAnchor).isActive = true

        return badge
    }
    
    private func makeDisclosureIndicator() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .tertiaryLabel
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 14.0, weight: .semibold)
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func addAccessories(to button: UIButton, for demo: Demo) {
        let iconBadge = makeIconBadge(for: demo)
        let disclosureIndicator = makeDisclosureIndicator()

        button.addSubview(iconBadge)
        button.addSubview(disclosureIndicator)

        iconBadge.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16.0).isActive = true
        iconBadge.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true

        disclosureIndicator.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16.0).isActive = true
        disclosureIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    
    // MARK: Actions
    
    private func present(_ demo: Demo) {
        navigationController?.pushViewController(demo.makeViewController(), animated: true)
    }
}
