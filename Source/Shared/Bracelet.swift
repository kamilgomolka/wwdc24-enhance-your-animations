import UIKit

struct Bracelet: Hashable, Identifiable {
    let id: UUID
    let name: String
    let beadColors: [UIColor]

    init(id: UUID = UUID(), name: String, beadColors: [UIColor]) {
        self.id = id
        self.name = name
        self.beadColors = beadColors
    }
}

extension Bracelet {
    static let samples: [Bracelet] = [
        Bracelet(
            name: "Sunset",
            beadColors: [.systemRed, .systemOrange, .systemYellow, .systemPink, .systemOrange, .systemRed]
        ),
        Bracelet(
            name: "Ocean",
            beadColors: [.systemTeal, .systemBlue, .systemCyan, .systemIndigo, .systemBlue, .systemTeal]
        ),
        Bracelet(
            name: "Meadow",
            beadColors: [.systemGreen, .systemMint, .systemYellow, .systemGreen, .systemTeal, .systemGreen]
        ),
        Bracelet(
            name: "Berry",
            beadColors: [.systemPurple, .systemPink, .systemIndigo, .systemPurple, .systemPink, .systemPurple]
        ),
        Bracelet(
            name: "Candy",
            beadColors: [.systemPink, .systemMint, .systemYellow, .systemCyan, .systemOrange, .systemPurple]
        ),
        Bracelet(
            name: "Graphite",
            beadColors: [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray3, .systemGray]
        )
    ]
}
