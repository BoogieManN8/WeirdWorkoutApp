import SwiftUI

struct OverlayModifier<Overlay: View>: ViewModifier {
    let overlay: Overlay
    let alignment: Alignment
    
    init(alignment: Alignment = .center, @ViewBuilder content: () -> Overlay) {
        self.alignment = alignment
        self.overlay = content()
    }
    
    func body(content: Content) -> some View {
        content.overlay(overlay, alignment: alignment)
    }
}

extension View {
    func overlay<Overlay: View>(alignment: Alignment = .center, @ViewBuilder overlay: () -> Overlay) -> some View {
        self.modifier(OverlayModifier(alignment: alignment, content: overlay))
    }
    
    func overlay<Overlay: View>(_ alignment: Alignment = .center, @ViewBuilder overlay: () -> Overlay) -> some View {
        self.modifier(OverlayModifier(alignment: alignment, content: overlay))
    }
}
