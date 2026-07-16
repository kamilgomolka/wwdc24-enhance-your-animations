import UIKit

final class BraceletDetailViewController: UIViewController {

    // MARK: Properties

    let bracelet: Bracelet

    private let card: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 28
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = bracelet.name
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let preview = BraceletPreviewView(beadDiameter: 44)

    // MARK: Initialization

    init(bracelet: Bracelet) {
        self.bracelet = bracelet
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = bracelet.name
        view.backgroundColor = .systemGroupedBackground
        preview.configure(with: bracelet)

        setupCard()
    }

    // MARK: View setup

    private func setupCard() {
        view.addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(preview)

        card.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        card.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        card.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24).isActive = true

        preview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        preview.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24).isActive = true
        preview.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24).isActive = true
        preview.heightAnchor.constraint(equalToConstant: 80).isActive = true
        preview.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -40).isActive = true
    }
}
