import Foundation

final class OnBoardingViewModel: ObservableObject {
    
    let userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
    }
}
