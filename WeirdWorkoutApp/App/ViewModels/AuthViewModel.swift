import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    let userManager: UserManager
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserModel?
    
    let keyChainManager = KeychainManager.shared
    private var cancellables: Set<AnyCancellable> = []
    
    init(userManager: UserManager) {
        self.userManager = userManager
        
        userListener()
        checkUsersKeyAndFetch(shouldCreate: false)
    }
    
    func signInWithApple(){
        userManager.signInWithApple()
    }
    
    func signInAsGuest() {
        userManager.signInAsGuest()
    }
    
    func testCreation(){
        userManager.createUser(isGuest: true, isPremium: false, token: "iphone8 token", level: .crook)
    }
    
    func checkUsersKeyAndFetch(shouldCreate: Bool = false) {
        let key = keyChainManager.getToken(account: "com.weirdworkoutappl")
        if let key = key {
            print("DEBUG: key \(key)")
            fetchUser(by: key)
        } else if shouldCreate {
            testCreation()
        }
        
    }
    
    func fetchUser(by id: String){
        userManager.fetchUser(with: id)
    }
    
    func deleteUser(){
        userManager.deleteUser(by: currentUser?.userToken ?? "")
        userManager.currentUser = nil
        isAuthenticated = false
    }
    
    func userListener(){
        userManager.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.currentUser = user
                if let newUser = self?.currentUser {
                    self?.isAuthenticated  = true
                    print("DEBUG: user \(newUser)")
                }
                
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
