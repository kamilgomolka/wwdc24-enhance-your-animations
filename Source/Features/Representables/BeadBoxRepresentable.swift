import SwiftUI

struct BeadBoxRepresentable: UIViewRepresentable {
    @Binding var isOpen: Bool

    func makeUIView(context: Context) -> BeadBox {
        BeadBox()
    }

    func updateUIView(_ box: BeadBox, context: Context) {
        context.animate {
            box.setLidOpen(isOpen)
        }
    }
}
