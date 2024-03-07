import SwiftUI

struct MainView: View {
    
    @StateObject var authViewModel: AuthViewModel
    @StateObject var onBoardViewModel: OnBoardViewModel
    @StateObject var onBoardingViewModel: OnBoardingViewModel
    @State var showSplash: Bool = true
    
    init(){
        let userManager = UserManager()
        self._authViewModel = StateObject(wrappedValue: AuthViewModel(userManager: userManager))
        self._onBoardViewModel = StateObject(wrappedValue: OnBoardViewModel(userManager: userManager))
        self._onBoardingViewModel = StateObject(wrappedValue: OnBoardingViewModel(userManager: userManager))
    }
    
    var body: some View {
        ZStack {
            
            if authViewModel.isAuthenticated {
                OnBoardView()
                    .navigationTitle("")
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .environmentObject(onBoardViewModel)
                    .environmentObject(authViewModel)
            } else {
                OnBoardingView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .environmentObject(authViewModel)
                    .environmentObject(onBoardingViewModel)
            }
            if showSplash {
                SplashScreenView()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation{
                                showSplash = false
                            }
                        }
                    }
            }
            
        }
        
    }
}

#Preview {
    MainView()
}


