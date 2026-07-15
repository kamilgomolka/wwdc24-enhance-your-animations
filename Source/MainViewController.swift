import UIKit

class MainViewController: UIViewController {
    
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
    
    private lazy var launchTestFeatureButton: UIButton = makeButton(
        title: "Launch Test Feature",
        action: { [weak self] in self?.pushTestFeatureViewController() }
    )
    
    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Boilerplate app"        
        view.backgroundColor = .systemBackground
        
        addSubviews()
        createConstraints()
    }
    
    // MARK: View setup
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(launchTestFeatureButton)
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
    
    private func makeButton(title: String, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in action() })
        return button
    }
    
    // MARK: Actions
    
    private func pushTestFeatureViewController() {
        navigationController?.pushViewController(TestFeatureViewController(), animated: true)
    }
}
