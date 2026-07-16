import UIKit

final class BraceletGalleryViewController: UIViewController {

    private static let mainSection = 0

    // MARK: Properties

    private let bracelets = Bracelet.samples

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var dataSource = makeDataSource()

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zoom Transition"
        view.backgroundColor = .systemGroupedBackground

        setupCollectionView()
        applySnapshot()
    }

    // MARK: View setup

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: Factories

    private func makeLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(140)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Bracelet.ID> {
        let registration = UICollectionView.CellRegistration<BraceletCell, Bracelet> { cell, _, bracelet in
            cell.configure(with: bracelet)
        }

        return UICollectionViewDiffableDataSource<Int, Bracelet.ID>(collectionView: collectionView) { [weak self] collectionView, indexPath, id in
            let bracelet = self?.bracelets.first { $0.id == id }
            return collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: bracelet
            )
        }
    }

    // MARK: Private functions

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Bracelet.ID>()
        snapshot.appendSections([Self.mainSection])
        snapshot.appendItems(bracelets.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func sourceCell(for bracelet: Bracelet) -> UIView? {
        guard let indexPath = dataSource.indexPath(for: bracelet.id) else { return nil }
        return collectionView.cellForItem(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension BraceletGalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let id = dataSource.itemIdentifier(for: indexPath),
              let bracelet = bracelets.first(where: { $0.id == id }) else { return }

        let detail = BraceletDetailViewController(bracelet: bracelet)
        detail.preferredTransition = .zoom { [weak self] context in
            guard let detail = context.zoomedViewController as? BraceletDetailViewController else { return nil }
            return self?.sourceCell(for: detail.bracelet)
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}
