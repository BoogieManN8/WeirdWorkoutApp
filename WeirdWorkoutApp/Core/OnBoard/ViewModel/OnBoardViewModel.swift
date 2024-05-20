import Foundation
import Combine
import SwiftUI

class OnBoardViewModel: ObservableObject {
    
    
    @Published var currentUser: UserModel?
    
    @Published var bodyWorkouts: [WorkoutModel] = []
    @Published var legWorkouts: [WorkoutModel] = []
    @Published var speedWorkouts: [WorkoutModel] = []
    @Published var torsoWorkouts: [WorkoutModel] = []
    @Published var allWorkouts  = Set<WorkoutByCategories>()
    @Published var historyData: [WorkoutModel] = []
    
//    var groupedHistoryData: [Date: [WorkoutModel]] {
//        let grouped = Dictionary(grouping: historyData) { $0.createdAt.startOfDay }
//        return grouped
//    }
    
    private var cancellables: Set<AnyCancellable> = []
    let userManager: UserManager
    let networkingManager = NetworkingManager.shared
    private let coreDataManager = CoreDataManager.shared

    
    
    init(userManager: UserManager){
        self.userManager = userManager
        setUpUserListener()
        fetchAllWorkouts()
        fetchWorkoutsFromCore()
        
        
    }
    
    
    
}


// MARK: - User
extension OnBoardViewModel {
    func setUpUserListener(){
        userManager.$currentUser
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("DEBUG: finished")
                    break
                case .failure(let failure):
                    print("DEBUG: failed getting user \(failure)")
                }
            }, receiveValue: { user in
                DispatchQueue.main.async{
                    self.currentUser = user
                    print("DEBUG: user was assigned \(String(describing: self.currentUser))")
                }
            })
            .store(in: &cancellables)
    }
    
    func updateUser(user: UserModel) {
        DispatchQueue.main.async{
            
            self.userManager.updateUser(by: user.id, with: user)
            self.userManager.currentUser = user
        }
        
    }
}

// MARK: - workout data
extension OnBoardViewModel {
    
    func fetchBodyWorkouts(){
        networkingManager.fetchWorkouts(by: "body")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: Could not fetch body workouts \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] bodyWorkouts in
                self?.bodyWorkouts = bodyWorkouts
                let newWorkout = WorkoutByCategories(id: UUID().uuidString, category: .body, workout: bodyWorkouts)
                self?.allWorkouts.insert(newWorkout)
            }
            .store(in: &cancellables)
    }
    
    func fetchLegWorkouts(){
        networkingManager.fetchWorkouts(by: "leg")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: Could not fetch leg workouts \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] legWorkouts in
                self?.legWorkouts = legWorkouts
                let newWorkout = WorkoutByCategories(id: UUID().uuidString, category: .leg, workout: legWorkouts)
                self?.allWorkouts.insert(newWorkout)
            }
            .store(in: &cancellables)
    }
    
    func fetchSpeedWorkouts(){
        networkingManager.fetchWorkouts(by: "speed")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: Could not fetch speed workouts \(error)")
                }
            } receiveValue: { [weak self] speedWorkouts in
                self?.speedWorkouts = speedWorkouts
                let newWorkout = WorkoutByCategories(id: UUID().uuidString, category: .speed, workout: speedWorkouts)
                self?.allWorkouts.insert(newWorkout)
            }
            .store(in: &cancellables)
    }
    
    func fetchTorsoWorkouts(){
        networkingManager.fetchWorkouts(by: "torso")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: Could not fetch torso workouts \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] torsoWorkouts in
                self?.torsoWorkouts = torsoWorkouts
                let newWorkout = WorkoutByCategories(id: UUID().uuidString, category: .torso, workout: torsoWorkouts)
                self?.allWorkouts.insert(newWorkout)
            }
            .store(in: &cancellables)
    }
    
    func fetchAllWorkouts(){
        self.fetchBodyWorkouts()
        self.fetchLegWorkouts()
        self.fetchSpeedWorkouts()
        self.fetchTorsoWorkouts()
        
    }
    
}


// MARK: - CORE DATA
extension OnBoardViewModel {
    func fetchWorkoutsFromCore() {
        self.historyData = coreDataManager.fetchAllWorkouts()
    }
    
    func addWorkoutToHistory(id: String, name: String, workoutDescription: String, image: String, video: String, difficulty: Int, category: workoutType) {
        coreDataManager.createWorkout(id: id, name: name, workoutDescription: workoutDescription, image: image, video: video, difficulty: difficulty, category: category)
        self.fetchWorkoutsFromCore()
    }
}


extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
