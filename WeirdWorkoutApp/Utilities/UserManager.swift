import Foundation
import Combine

class UserManager: NSObject, ObservableObject {
    @Published var currentUser: UserModel?
    
    let baseURL = "http://62.72.18.243:5000/"
    let networkingManager = NetworkingManager.shared
    let keychanManager = KeychainManager.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    func signInWithApple(){
        // sends token to server
    }
    
    
    func signInAsGuest(){
        // send generated temporary token
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
    
}
