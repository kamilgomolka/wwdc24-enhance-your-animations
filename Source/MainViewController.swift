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
    }

    // MARK: Properties
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Enhance Your UI Animations"
        view.backgroundColor = .systemBackground
        
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
        var configuration = UIButton.Configuration.filled()
        configuration.title = demo.title
        configuration.subtitle = demo.subtitle
        configuration.titleAlignment = .leading
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.present(demo)
        })
    }
    
    // MARK: Actions
    
    private func present(_ demo: Demo) {
        navigationController?.pushViewController(demo.makeViewController(), animated: true)
    }
}
