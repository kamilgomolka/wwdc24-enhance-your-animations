import SwiftUI
import UIKit

final class BeadSpringViewController: UIViewController {

    private enum AnimationStyle: String, CaseIterable {
        case spring = "Spring"
        case bouncy = "Bouncy"
        case smooth = "Smooth"
        case snappy = "Snappy"

        var animation: Animation {
            switch self {
            case .spring: .spring(duration: 0.5)
            case .bouncy: .bouncy(duration: 0.6)
            case .smooth: .smooth(duration: 0.5)
            case .snappy: .snappy(duration: 0.4)
            }
        }
    }

    // MARK: Properties

    private var selectedStyle: AnimationStyle = .spring

    private let bead = BeadView(color: .systemIndigo, diameter: 64)

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap anywhere to fling the bead"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var styleControl: UISegmentedControl = {
        let control = UISegmentedControl(items: AnimationStyle.allCases.map(\.rawValue))
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addAction(UIAction { [weak self] _ in self?.updateSelectedStyle() }, for: .valueChanged)
        return control
    }()

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "SwiftUI Animation"
        view.backgroundColor = .systemBackground

        setupControls()
        setupBead()
        setupTapGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bead.center == .zero {
            bead.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        }
    }

    // MARK: View setup

    private func setupControls() {
        view.addSubview(styleControl)
        view.addSubview(hintLabel)

        styleControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        styleControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        styleControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true

        hintLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }

    private func setupBead() {
        bead.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(bead)
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }

    // MARK: Actions

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        UIView.animate(selectedStyle.animation) {
            self.bead.center = location
        }
    }

    // MARK: Private functions

    private func updateSelectedStyle() {
        guard let style = AnimationStyle.allCases[safe: styleControl.selectedSegmentIndex] else { return }
        selectedStyle = style
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
