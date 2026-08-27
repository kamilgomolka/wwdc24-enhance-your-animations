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
    private var hasCenteredBead = false

    private let bead = BeadView(color: .systemIndigo, systemImageName: "car", diameter: 64)

    private let canvasView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        setupCanvasView()
        setupBead()
        setupTapGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasCenteredBead, canvasView.bounds != .zero else { return }
        bead.center = CGPoint(x: canvasView.bounds.midX, y: canvasView.bounds.midY)
        hasCenteredBead = true
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

    private func setupCanvasView() {
        view.addSubview(canvasView)

        canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        canvasView.topAnchor.constraint(equalTo: styleControl.bottomAnchor, constant: 16).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: hintLabel.topAnchor, constant: -16).isActive = true
    }

    private func setupBead() {
        bead.translatesAutoresizingMaskIntoConstraints = true
        canvasView.addSubview(bead)
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        canvasView.addGestureRecognizer(tap)
    }

    // MARK: Actions

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: canvasView)
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
