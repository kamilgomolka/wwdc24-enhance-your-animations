import UIKit

final class BraceletDetailViewController: UIViewController {

    // MARK: Properties

    let bracelet: Bracelet

    private let preview = BraceletPreviewView(beadDiameter: 52)

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

        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        preview.configure(with: bracelet)

        setupPreview()
    }

    // MARK: View setup

    private func setupPreview() {
        view.addSubview(preview)
        preview.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        preview.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        preview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        preview.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
}
