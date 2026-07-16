import SwiftUI
import UIKit

final class BeadThreadingViewController: UIViewController {

    private struct ActiveDrag {
        let bead: BraceletBead
        let originalIndex: Int
        let view: BeadView
    }

    // MARK: Properties

    private var activeDrag: ActiveDrag?

    private let stringView = ThreadedBraceletView(beadDiameter: 44)
    private let trayView = BeadTrayView(beadDiameter: 44)

    private let trayContainerView: UIView = {
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
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Generous hit-test area around the string used to decide when a dragged bead is "close
    /// enough" to reserve an insertion slot.
    private var insertionProximityRect: CGRect {
        stringView.frame.insetBy(dx: -40, dy: -60)
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bead Threading"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .refresh,
            primaryAction: UIAction { [weak self] _ in self?.resetDemo() }
        )

        setupStringView()
        setupTray()
        setupHint()
        resetDemo()
    }

    // MARK: View setup

    private func setupStringView() {
        view.addSubview(stringView)
        stringView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stringView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stringView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        stringView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
    }

    private func setupTray() {
        view.addSubview(trayContainerView)
        trayContainerView.addSubview(trayView)

        trayContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        trayContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        trayContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        trayContainerView.heightAnchor.constraint(equalToConstant: 44 + 16 + 16).isActive = true

        trayView.leadingAnchor.constraint(equalTo: trayContainerView.leadingAnchor, constant: 12).isActive = true
        trayView.trailingAnchor.constraint(equalTo: trayContainerView.trailingAnchor, constant: -12).isActive = true
        trayView.topAnchor.constraint(equalTo: trayContainerView.topAnchor, constant: 12).isActive = true
        trayView.bottomAnchor.constraint(equalTo: trayContainerView.bottomAnchor, constant: -12).isActive = true
    }

    private func setupHint() {
        view.addSubview(hintLabel)
        hintLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        hintLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        hintLabel.bottomAnchor.constraint(equalTo: trayContainerView.topAnchor, constant: -24).isActive = true
    }

    // MARK: Actions

    @objc private func handleBeadPan(_ gesture: UIPanGestureRecognizer) {
        guard let beadView = gesture.view as? BeadView else { return }

        switch gesture.state {
        case .began:
            beginDrag(of: beadView)
        case .changed:
            continueDrag(gesture)
        case .ended, .cancelled:
            endDrag()
        default:
            break
        }
    }

    // MARK: Private functions

    private func resetDemo() {
        activeDrag = nil
        let pools = Self.makeBeadPools()
        stringView.configure(with: pools.threaded)
        trayView.configure(with: pools.tray)
        attachPanGestures()
        updateHintLabel()
    }

    private func attachPanGestures() {
        for beadView in trayView.beadViews {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handleBeadPan))
            beadView.addGestureRecognizer(pan)
        }
    }

    private func beginDrag(of beadView: BeadView) {
        guard activeDrag == nil,
              let index = trayView.beadViews.firstIndex(where: { $0 === beadView }) else { return }

        let bead = trayView.beads[index]
        let frameInRoot = view.convert(beadView.frame, from: trayView)

        trayView.extract(at: index)

        view.addSubview(beadView)
        beadView.frame = frameInRoot

        activeDrag = ActiveDrag(bead: bead, originalIndex: index, view: beadView)
        updateHintLabel()
    }

    private func continueDrag(_ gesture: UIPanGestureRecognizer) {
        guard let activeDrag else { return }
        let location = gesture.location(in: view)

        UIView.animate(.interactiveSpring) {
            activeDrag.view.center = location
        }

        stringView.setShowsInsertionSlot(insertionProximityRect.contains(location))
    }

    private func endDrag() {
        guard let activeDrag else { return }
        self.activeDrag = nil

        if let slotCenterInString = stringView.insertionSlotCenter() {
            commitDrag(activeDrag, slotCenterInString: slotCenterInString)
        } else {
            returnDrag(activeDrag)
        }
    }

    private func commitDrag(_ drag: ActiveDrag, slotCenterInString: CGPoint) {
        let targetCenterInRoot = view.convert(slotCenterInString, from: stringView)

        UIView.animate(.spring) {
            drag.view.center = targetCenterInRoot
        } completion: { [weak self] in
            guard let self else { return }
            drag.view.center = slotCenterInString
            self.stringView.append(drag.bead, view: drag.view)
            self.updateHintLabel()
        }
    }

    private func returnDrag(_ drag: ActiveDrag) {
        let centerInTray = trayView.convert(drag.view.center, from: view)
        drag.view.center = centerInTray
        trayView.insert(drag.bead, view: drag.view, at: drag.originalIndex)
        updateHintLabel()
    }

    private func updateHintLabel() {
        hintLabel.text = trayView.beads.isEmpty
            ? "All beads threaded!\nTap reset to try again."
            : "Drag a bead near the string to make room and thread it."
    }

    private static func makeBeadPools() -> (threaded: [BraceletBead], tray: [BraceletBead]) {
        let pool = Bracelet.samples.flatMap(\.beads).shuffled()
        let threaded = Array(pool.prefix(3))
        let tray = Array(pool.dropFirst(3).prefix(6))
        return (threaded, tray)
    }
}
