import SwiftUI

struct BeadBoxDemoView: View {
    @State private var isOpen = false

    var body: some View {
        VStack(spacing: 32) {
            BeadBoxRepresentable(isOpen: $isOpen)
                .fixedSize()
                .onTapGesture {
                    withAnimation(.spring(duration: 0.6)) {
                        isOpen.toggle()
                    }
                }

            Text(isOpen ? "Tap the box to close the lid" : "Tap the box to open the lid")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    BeadBoxDemoView()
}
