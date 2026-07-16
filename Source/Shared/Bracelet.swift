import UIKit

struct BraceletBead: Hashable {
    let symbol: String
    let color: UIColor
}

struct Bracelet: Hashable, Identifiable {
    let id: UUID
    let name: String
    let beads: [BraceletBead]

    init(id: UUID = UUID(), name: String, beads: [BraceletBead]) {
        self.id = id
        self.name = name
        self.beads = beads
    }
}

extension Bracelet {
    private static let symbolPool = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "✨", "🔥", "🌈", "💫", "🍀", "🎧", "⚡️", "🌸", "🎯", "🧩", "🎈", "🌊", "💎", "🎵"
    ]

    private static func randomBeads(colors: [UIColor], count: Int) -> [BraceletBead] {
        (0..<count).map { _ in
            BraceletBead(symbol: symbolPool.randomElement() ?? "?", color: colors.randomElement() ?? .systemGray)
        }
    }

    static let samples: [Bracelet] = {
        let blues: [UIColor] = [.systemBlue, .systemIndigo, .systemCyan, .systemTeal]
        let greens: [UIColor] = [.systemGreen, .systemMint, .systemTeal]
        let purples: [UIColor] = [.systemPurple, .systemIndigo, .systemPink]
        let oranges: [UIColor] = [.systemOrange, .systemBrown, .systemRed]
        let grays: [UIColor] = [.systemGray, .systemGray2, .systemGray3]

        return [
            Bracelet(name: "Sunset", beads: randomBeads(colors: oranges, count: 6)),
            Bracelet(name: "Ocean", beads: randomBeads(colors: blues, count: 5)),
            Bracelet(name: "Meadow", beads: randomBeads(colors: greens, count: 5)),
            Bracelet(name: "Berry", beads: randomBeads(colors: purples, count: 4)),
            Bracelet(name: "Candy", beads: randomBeads(colors: purples + blues, count: 5)),
            Bracelet(name: "Graphite", beads: randomBeads(colors: grays, count: 6)),
            Bracelet(name: "Sky", beads: randomBeads(colors: blues, count: 3)),
            Bracelet(name: "Fruit", beads: randomBeads(colors: oranges + greens, count: 5))
        ]
    }()
}
