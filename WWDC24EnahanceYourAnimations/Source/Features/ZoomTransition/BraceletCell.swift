import UIKit

final class BraceletCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: BraceletCell.self)

    // MARK: Properties

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let preview = BraceletPreviewView(beadDiameter: 22)

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View setup

    private func setupContainer() {
        contentView.addSubview(container)
        container.addSubview(preview)

        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        preview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14).isActive = true
        preview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14).isActive = true
        preview.topAnchor.constraint(equalTo: container.topAnchor, constant: 14).isActive = true
        preview.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14).isActive = true
    }

    // MARK: Configuration

    func configure(with bracelet: Bracelet) {
        preview.configure(with: bracelet)
    }
}
