import SwiftUI
import UIKit

final class BeadFlingViewController: UIViewController {

    // MARK: Properties

    private var hasPositionedBead = false

    private let bead = BeadView(color: .systemTeal, systemImageName: "paperplane.fill", diameter: 72)

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

    private let braceletEndMarker: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Drag and fling the bead toward the ring"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var braceletEnd: CGPoint {
        CGPoint(x: canvasView.bounds.midX, y: canvasView.bounds.minY + 120)
    }

    private var beadHome: CGPoint {
        CGPoint(x: canvasView.bounds.midX, y: canvasView.bounds.maxY - 140)
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Continuous Velocity"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .refresh,
            primaryAction: UIAction { [weak self] _ in self?.resetBead() }
        )

        setupHint()
        setupCanvasView()
        setupMarker()
        setupBead()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !hasPositionedBead, canvasView.bounds != .zero else { return }
        bead.center = beadHome
        hasPositionedBead = true
    }

    // MARK: View setup

    private func setupHint() {
        view.addSubview(hintLabel)
        hintLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
    }

    private func setupCanvasView() {
        view.addSubview(canvasView)

        canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: hintLabel.topAnchor, constant: -16).isActive = true
    }

    private func setupMarker() {
        canvasView.addSubview(braceletEndMarker)
        braceletEndMarker.widthAnchor.constraint(equalToConstant: 80).isActive = true
        braceletEndMarker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        braceletEndMarker.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        braceletEndMarker.topAnchor.constraint(equalTo: canvasView.topAnchor, constant: 80).isActive = true
    }

    private func setupBead() {
        bead.translatesAutoresizingMaskIntoConstraints = true
        canvasView.addSubview(bead)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        bead.addGestureRecognizer(pan)
    }

    // MARK: Actions

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: canvasView)

        switch gesture.state {
        case .changed:
            UIView.animate(.interactiveSpring) {
                self.bead.center = location
            }
        case .ended, .cancelled:
            UIView.animate(.spring) {
                self.bead.center = self.braceletEnd
            }
        default:
            break
        }
    }

    // MARK: Private functions

    private func resetBead() {
        UIView.animate(.bouncy) {
            self.bead.center = self.beadHome
        }
    }
}
