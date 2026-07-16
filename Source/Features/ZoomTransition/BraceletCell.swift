import UIKit

final class BraceletCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: BraceletCell.self)

    // MARK: Properties

    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let preview = BraceletPreviewView(beadDiameter: 26)

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
        container.addSubview(nameLabel)
        container.addSubview(preview)

        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true

        preview.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        preview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16).isActive = true
        preview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
        preview.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16).isActive = true
    }

    // MARK: Configuration

    func configure(with bracelet: Bracelet) {
        nameLabel.text = bracelet.name
        preview.configure(with: bracelet)
    }
}
