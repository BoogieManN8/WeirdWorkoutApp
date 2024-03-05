import SwiftUI
import StoreKit

struct SettingsView: View {
    let bounds: CGRect = UIScreen.main.bounds
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: OnBoardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEula: Bool = false
    @State private var eulaState: EulaState = .terms
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        
        if showEula {
            EulaView(url: URL(string: eulaState.rawValue)!)
                .ignoresSafeArea(.all)
                .overlay(.topLeading) {
                    Button(action: {
                        showEula = false
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.theme.darkBlue)
                            .font(.theme.bold(18))
                    })
                    .padding()
                }
            
        } else {
            ZStack {
                Color.theme.darkBlue
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    Button(action: {
                        eulaState = .terms
                        showEula = true
                    }, label: {
                        Text("Terms of use")
                            .padding()
                            .foregroundColor(.white)
                            .font(.theme.bold)
                            .frame(width: bounds.width * 0.7, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                    })
                    
                    Button(action: {
                        eulaState = .privacy
                        showEula = true
                    }, label: {
                        Text("Privacy Policy")
                            .padding()
                            .foregroundColor(.white)
                            .font(.theme.bold)
                            .frame(width: bounds.width * 0.7, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                    })
                    
                    Button(action: {
                        eulaState = .support
                        showEula = true
                    }, label: {
                        Text("Support")
                            .padding()
                            .foregroundColor(.white)
                            .font(.theme.bold)
                            .frame(width: bounds.width * 0.7, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                    })
                    
                    Button(action: {
                        rateApp()
                    }, label: {
                        Text("Rate us")
                            .padding()
                            .foregroundColor(.white)
                            .font(.theme.bold)
                            .frame(width: bounds.width * 0.7, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                    })
                    
                    
                    if var user = authViewModel.currentUser, user.isGuest {
                        Button(action: {
                            authViewModel.signInWithApple()
                        }, label: {
                            Text("Sign in with apple")
                                .padding()
                                .foregroundColor(.white)
                                .font(.theme.bold)
                                .frame(width: bounds.width * 0.7, height: 55)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                        })
                    }
                    
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Text("Delete Account")
                            .padding()
                            .foregroundColor(.gray)
                            .font(.theme.bold)
                            .frame(width: bounds.width * 0.7, height: 55)
                            
                    })
                    .padding(.top, 20)
                    
                }
            }
            .overlay(.top) {
                ZStack {
                    Color.theme.blue
                        .ignoresSafeArea(.all)
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }, label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white.opacity(0.6))
                                .font(.theme.semiBold)
                        })
                        
                        
                        Spacer()
                        
                        Text("Settings")
                            .foregroundColor(.white)
                            .font(.theme.bold(18))
                        
                        Spacer()
                        HStack {
                            
                            Text("\(viewModel.currentUser?.points ?? 0)")
                                .foregroundColor(.theme.yellow)
                                .font(.theme.semiBold)
                            
                            Image("trophy")
                        }
                        
                        
                        
                    }
                    .padding(.horizontal)
                    
                }
                .frame(height: bounds.height * 0.09)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete account ?"),
                    message: Text("Are you sure you want to delete account ?"),
                    primaryButton: .destructive(Text("Delete")) {
                        withAnimation(.easeOut){
                            authViewModel.deleteUser()
                        }
                    },
                    secondaryButton: .default(Text("Cancel").foregroundColor(Color.blue)) {
                        showAlert = false
                    }
                )
            }
        }
    }
    
    func rateApp() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(OnBoardViewModel(userManager: UserManager()))
        .environmentObject(AuthViewModel(userManager: UserManager()))
}
