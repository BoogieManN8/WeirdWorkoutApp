import SwiftUI

struct BottomSheetModifier<Content: View>: ViewModifier {
    @Binding var isPresented: Bool
    let backgroundColor: Color
    let handleColor: Color
    let sheetContent: Content

    func body(content: Self.Content) -> some View {
        ZStack {
            content
            if isPresented {
                BottomSheetView(isPresented: $isPresented, backgroundColor: backgroundColor, handleColor: handleColor, content: sheetContent)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}




struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    let backgroundColor: Color
    let handleColor: Color
    let content: Content
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                content
            }
            .overlay(.top){
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .frame(width: 120, height: 6)
                    .padding(.top, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
            .background(backgroundColor)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .offset(y: isPresented ? (translation > 0 ? translation : 0) : geometry.size.height * 0.5)
            
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        if value.translation.height > geometry.size.height * 0.2 {
                            self.isPresented = false
                        }
                    }
            )
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .offset(y: 40)
        }
    }
}


extension View {
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        backgroundColor: Color = Color.white,
        handleColor: Color = Color.gray,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(BottomSheetModifier(isPresented: isPresented, backgroundColor: backgroundColor, handleColor: handleColor, sheetContent: content()))
    }
}
