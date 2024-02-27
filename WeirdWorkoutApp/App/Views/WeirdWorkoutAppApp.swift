import SwiftUI

@main
struct WeirdWorkoutAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}


extension UIApplication {
    var currentScene: UIWindowScene? {
        return connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
