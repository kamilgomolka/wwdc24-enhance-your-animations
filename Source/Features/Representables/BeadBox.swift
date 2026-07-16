import UIKit

final class BeadBox: UIView {

    // MARK: Properties

    private(set) var isLidOpen = false

    private let beadRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    private let lid: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBrown
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let lidHandle: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.alpha = 0.6
        view.layer.cornerRadius = 4
        return view
    }()

    // MARK: Initialization

    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 24
        layer.cornerCurve = .continuous

        for color in [UIColor.systemRed, .systemOrange, .systemGreen, .systemBlue, .systemPurple] {
            beadRow.addArrangedSubview(BeadView(color: color, diameter: 36))
        }

        addSubview(beadRow)
        addSubview(lid)
        lid.addSubview(lidHandle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    override var intrinsicContentSize: CGSize {
        CGSize(width: 280, height: 220)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        beadRow.frame = bounds.insetBy(dx: 32, dy: 0)
        lid.frame = bounds
        lid.center = lidCenter(open: isLidOpen)
        lidHandle.frame = CGRect(x: lid.bounds.midX - 30, y: 20, width: 60, height: 8)
    }

    // MARK: Lid control

    func setLidOpen(_ open: Bool) {
        isLidOpen = open
        lid.center = lidCenter(open: open)
    }

    private func lidCenter(open: Bool) -> CGPoint {
        CGPoint(x: bounds.midX, y: open ? bounds.midY - bounds.height : bounds.midY)
    }
}
