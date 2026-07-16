import SwiftUI
import UIKit

final class RepresentableAnimationViewController: UIHostingController<BeadBoxDemoView> {

    init() {
        super.init(rootView: BeadBoxDemoView())
        title = "Animating Representables"
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
