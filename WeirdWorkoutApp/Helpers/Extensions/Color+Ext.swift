import SwiftUI


extension Color {
    static let theme = AppColorTheme.shared
}

struct AppColorTheme {
    static let shared = AppColorTheme()
    
    let black = Color("appBlack")
    let darkBlue = Color("appDarkBlue")
    let blue = Color("appBlue")
    let yellow = Color("appYellow")
}
