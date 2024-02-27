import Foundation

enum workoutType: String, Hashable {
    case body, leg, speed, torso
    var wrappedValue: String {
        switch self {
        case .body:
            return "body"
        case .leg:
            return "leg"
        case .speed:
            return "speed"
        case .torso:
            return "torso"
        }
    }
    
}

struct WorkoutModel: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let description: String
    let image: String
    let video: String
    let difficulty: Int
    let createdAt: Date?
}


struct WorkoutByCategories: Identifiable, Hashable {
    let id: String
    let category: workoutType
    let workout: [WorkoutModel]
}


struct WorkoutHistory: Identifiable, Hashable {
    let id: String
    let date: Date
    let workouts: [WorkoutModel]
}
