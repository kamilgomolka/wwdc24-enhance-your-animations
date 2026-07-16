import SwiftUI
import UIKit

final class BeadFlingViewController: UIViewController {

    // MARK: Properties

    private let bead = BeadView(color: .systemPink, diameter: 72)

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
        CGPoint(x: view.bounds.midX, y: view.safeAreaInsets.top + 120)
    }

    private var beadHome: CGPoint {
        CGPoint(x: view.bounds.midX, y: view.bounds.maxY - view.safeAreaInsets.bottom - 140)
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

        setupMarker()
        setupHint()
        setupBead()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bead.center == .zero {
            bead.center = beadHome
        }
    }

    // MARK: View setup

    private func setupMarker() {
        view.addSubview(braceletEndMarker)
        braceletEndMarker.widthAnchor.constraint(equalToConstant: 80).isActive = true
        braceletEndMarker.heightAnchor.constraint(equalToConstant: 80).isActive = true
        braceletEndMarker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        braceletEndMarker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
    }

    private func setupHint() {
        view.addSubview(hintLabel)
        hintLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
    }

    private func setupBead() {
        bead.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(bead)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        bead.addGestureRecognizer(pan)
    }

    // MARK: Actions

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)

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
