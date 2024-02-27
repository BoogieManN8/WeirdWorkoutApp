import Foundation
import Combine

final class NetworkingManager {
    static let shared = NetworkingManager()
    let baseURL = "http://62.72.18.243:5000/"
    
    var session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    private func makeRequest(to endpoint: String, method: String, body: Data? = nil) -> URLRequest {

        let urlString = "\(baseURL)\(endpoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        request.httpBody = body
        
        return request
    }
    
    private func sendRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                print("DEBUG: user string \(String(decoding: output.data, as: UTF8.self))")
                return output.data
            }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(from endpoint: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}



// MARK: - USER
extension NetworkingManager {
    func registerUser(user: UserModel) -> AnyPublisher<Data, Error> {
        let body = try? JSONEncoder().encode(user)
        let request = makeRequest(to: "users/", method: "POST", body: body)
        return sendRequest(request)
    }
    
    func fetchUser(userID: String) -> AnyPublisher<UserModel, Error> {
        let request = makeRequest(to: "users/\(userID)", method: "GET")
        print("DEBUG: \(request.url)")
        return sendRequest(request)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func updateUser(userID: String, user: UserModel) -> AnyPublisher<UserModel, Error> {
        let endpoint = "users/\(userID)"
        var request = makeRequest(to: endpoint, method: "PUT")
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return sendRequest(request)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    
    func deleteUser(userID: String) -> AnyPublisher<Void, Error> {
        let endpoint = "users/\(userID)"
        let request = makeRequest(to: endpoint, method: "DELETE")
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return ()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Workouts
extension NetworkingManager {
    
    func fetchWorkouts(by type: String) -> AnyPublisher<[WorkoutModel], Error> {
        let endpoint = "data/\(type)"
        return fetch(from: endpoint)
    }
    
    func fetchAllWorkouts() -> AnyPublisher<[WorkoutModel], Error> {
        let endpoint = "data/all"
        return fetch(from: endpoint)
    }
    
}
