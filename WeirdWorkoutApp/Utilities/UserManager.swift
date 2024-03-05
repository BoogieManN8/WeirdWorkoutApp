import Foundation
import Combine
import AuthenticationServices

class UserManager: NSObject, ObservableObject {
    @Published var currentUser: UserModel?
    
    let baseURL = "https://busapp.co/"
    let networkingManager = NetworkingManager.shared
    let keychanManager = KeychainManager.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    func signInWithApple(){
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
    }
    
    
    func signInAsGuest(){
        let randomToken = generateRandomToken(length: 32)
        self.createUser(isGuest: true, isPremium: false, token: randomToken, level: .crook)
    }
    
    func createUser(isGuest: Bool, isPremium: Bool, token: String, level: UserLevel) {
        let id = UUID().uuidString
        let user = UserModel(id: id, isGuest: isGuest, isPremium: isPremium, userToken: token, points: 0, userLevel: level)
        networkingManager.registerUser(user: user)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR: failed to create user[\(user)] \(error)")
                }
            } receiveValue: { [weak self] data in
                self?.currentUser = user
                self?.keychanManager.saveToken(token: user.userToken, account: "com.weirdworkoutappl")
            }
            .store(in: &cancellables)
    }
    
    func fetchUser(with id: String) {
        networkingManager.fetchUser(userID: id)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: Could not fetch user[\(id)] - \(error)")
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)

    }
    
    func updateUser(by id: String, with user: UserModel) {
        networkingManager.updateUser(userID: id, user: user)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                print("DEBUG: could not update user[\(id)] - \(error)")
                }
            } receiveValue: { [weak self] user in
                print("DEBUG: updated user \(user)")
//                self?.currentUser = user
                self?.keychanManager.updateToken(newToken: user.userToken, account: "com.weirdworkoutappl")
            }
            .store(in: &cancellables)

    }
    
    func deleteUser(by id: String) {
        networkingManager.deleteUser(userID: id)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: could not delete user[\(id)] - \(error)")
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
 
    func generateRandomToken(length: Int) -> String {
        
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let charactersArray = Array(characters)
        
        let randomString = (0..<length).map { _ in
            charactersArray[Int(arc4random_uniform(UInt32(charactersArray.count)))]
        }
        
        return String(randomString)
    }
    
}

// MARK: - ASAuthorizationControllerDelegate
extension UserManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

            let userIdentifier = appleIDCredential.user
            let token = appleIDCredential.identityToken
            let email = appleIDCredential.email

            
            if let tokenData = token, let tokenString = String(data: tokenData, encoding: .utf8) {
                print("TOKEN STRING \(tokenString)")
                self.createUser(isGuest: false, isPremium: false, token: tokenString, level: .crook)
            }
            print("email \(String(describing: email))")
            self.createUser(isGuest: false, isPremium: false, token: userIdentifier, level: .crook)
            
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
