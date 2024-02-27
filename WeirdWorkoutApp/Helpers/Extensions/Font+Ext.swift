import SwiftUI






extension Font {
    static let theme = AppFontTheme.shared
}


struct AppFontTheme {
    static let shared = AppFontTheme()
    let medium = Font.custom("Montserrat-Medium", size: 14)
    let bold = Font.custom("Montserrat-Bold", size: 16)
    let semiBold = Font.custom("Montserrat-SemiBold", size: 24)
    
    func medium(_ size: CGFloat) -> Font {
        Font.custom("Montserrat-Medium", size: size)
    }
    
    func bold(_ size: CGFloat) -> Font {
        Font.custom("Montserrat-Bold", size: size)
    }
    
    func semiBold(_ size: CGFloat) -> Font {
        Font.custom("Montserrat-SemiBold", size: size)
    }
}
