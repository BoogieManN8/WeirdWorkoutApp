import SwiftUI

@main
struct WeirdWorkoutAppApp: App {
    @State var showSplashScreen: Bool = true
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            
        }
    }
}


extension UIApplication {
    var currentScene: UIWindowScene? {
        return connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}


struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.theme.darkBlue
                .ignoresSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
            }
        }
    }
}
