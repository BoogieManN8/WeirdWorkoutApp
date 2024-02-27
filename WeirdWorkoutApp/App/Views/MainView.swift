import SwiftUI

struct MainView: View {
    
    @StateObject var authViewModel: AuthViewModel
    @StateObject var onBoardViewModel: OnBoardViewModel
    @StateObject var onBoardingViewModel: OnBoardingViewModel
    
    init(){
        let userManager = UserManager()
        self._authViewModel = StateObject(wrappedValue: AuthViewModel(userManager: userManager))
        self._onBoardViewModel = StateObject(wrappedValue: OnBoardViewModel(userManager: userManager))
        self._onBoardingViewModel = StateObject(wrappedValue: OnBoardingViewModel(userManager: userManager))
    }
    
    var body: some View {
        if authViewModel.isAuthenticated {
            OnBoardView()
                .navigationTitle("")
                .navigationBarHidden(true)
                .environmentObject(onBoardViewModel)
                .environmentObject(authViewModel)
        } else {
            OnBoardingView()
                .navigationTitle("")
                .navigationBarHidden(true)
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    MainView()
}


