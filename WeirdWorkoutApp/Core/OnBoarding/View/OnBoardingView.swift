//
import SwiftUI

struct OnBoardingView: View {
    
    enum ViewState {
        case notifications , signUp
    }
    let bounds: CGRect = UIScreen.main.bounds
    @State var viewState: ViewState = .notifications
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    @State var showEula: Bool = false
    @State var eulaState: EulaState = .terms
    
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
              Image("OnBoardingBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea(.all)
                
                switch viewState {
                case .notifications:
                    notificationsLayer
                        .transition(.move(edge: .leading))
                case .signUp:
                    signUpLayer
                        .transition(.move(edge: .trailing))
                }
                
            }
        }
        
    }
}

#Preview {
    OnBoardingView()
}
// MARK: - LAYERS
extension OnBoardingView {
    var notificationsLayer: some View {
        VStack (spacing: 50) {

            Spacer()
                .frame(height: bounds.height * 0.4)
            VStack (alignment: .leading, spacing: 20){
                Text("Enable Push\nNotifications Now")
                    .foregroundColor(.white)
                    .font(.theme.bold(24))
                    .multilineTextAlignment(.leading)
                
                Text("Be the first to know about new updates and find out about new workouts available to you")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.theme.semiBold(16))
                    .multilineTextAlignment(.leading)
                
            }
            .padding(.horizontal, 20)
            
            VStack {
                Button(action: {
                    withAnimation {
                        viewState = .signUp
                    }
                }, label: {
                    Text("Enable Notifications")
                        .padding()
                        .foregroundColor(.theme.darkBlue)
                        .font(.theme.semiBold(16))
                        .frame(width: bounds.width * 0.8, height: 55)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.yellow))
                })
                
                Button(action: {
                    withAnimation {
                        viewState = .signUp
                    }
                }, label: {
                    Text("Ask me later")
                        .underline()
                        .padding()
                        .foregroundColor(.gray)
                        .font(.theme.semiBold(16))
                        .frame(width: bounds.width * 0.8, height: 55)
                        
                })
            }
            .padding()
            
        }
//        .frame(width: bounds.width, height: bounds.height)
    }
    
    var signUpLayer: some View {
        VStack (spacing: 50) {
            
            Spacer()
                .frame(height: bounds.height * 0.4)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign Up Now")
                    .foregroundColor(.white)
                    .font(.theme.bold(28))
                    .multilineTextAlignment(.leading)
                
                Text("Connect your Apple account and start training from our sets from beginner to professional.")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.theme.semiBold(16))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
            VStack {
                Button(action: {
                    viewState = .notifications
                }, label: {
                    Text("Continue as a guest")
                        .underline()
                        .padding()
                        .foregroundColor(.white.opacity(0.8))
                        .font(.theme.semiBold(16))
                        .frame(width: bounds.width * 0.8, height: 55)
                })
                
                Button(action: {
                    withAnimation {
                        authViewModel.checkUsersKeyAndFetch(shouldCreate: true)
                    }
                }, label: {
                    Text("Sign in with apple")
                        .padding()
                        .foregroundColor(.theme.darkBlue)
                        .font(.theme.semiBold(16))
                        .frame(width: bounds.width * 0.8, height: 55)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.yellow))
                        
                })
                
                HStack {
                    Text("Agree on ")
                    
                    Text("Terms")
                        .underline()
                        .foregroundColor(.white)
                        .onTapGesture {
                            eulaState = .terms
                            showEula = true
                        }
                    
                    Text("and")
                    
                    Text("Privacy")
                        .underline()
                        .foregroundColor(.white)
                        .onTapGesture {
                            eulaState = .privacy
                            showEula = true
                        }
                }
                .foregroundColor(.white.opacity(0.8))
                .font(.theme.medium(16))
            }
        }
        .padding()
    }
}


enum EulaState: String {
    case terms, privacy, support
    
    var rawValue: String {
        switch self {
        case .terms:
            return "https://www.youtube.com"
        case .privacy:
            return "https://www.facebook.com"
        case .support:
            return "https://www.google.com"
        }
    }
}
