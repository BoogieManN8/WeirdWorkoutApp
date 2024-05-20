import Foundation

enum UserLevel: Int, Codable {
    case crook = 0
    case medium = 1
    case pro = 2
}

struct UserModel: Codable {
    let id: String
    let isGuest: Bool
    let isPremium: Bool
    let userToken: String
    var points: Int
    let userLevel: UserLevel
    
    enum CodingKeys: String, CodingKey {
        case id
        case isGuest
        case isPremium
        case userToken
        case points
        case userLevel
    }
    
    
    init(id: String, isGuest: Bool, isPremium: Bool, userToken: String,points: Int, userLevel: UserLevel) {
        self.id = id
        self.isGuest = isGuest
        self.isPremium = isPremium
        self.userToken = userToken
        self.points = points
        self.userLevel = userLevel
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        userToken = try container.decode(String.self, forKey: .userToken)
        
        
        let isGuestInt = try container.decode(Int.self, forKey: .isGuest)
        isGuest = isGuestInt == 1
        
        let isPremiumInt = try container.decode(Int.self, forKey: .isPremium)
        isPremium = isPremiumInt == 1
        
        points = try container.decode(Int.self, forKey: .points)
        
        let userLevelInt = try container.decode(Int.self, forKey: .userLevel)
        guard let level = UserLevel(rawValue: userLevelInt) else {
            throw DecodingError.dataCorruptedError(forKey: .userLevel,
                                                   in: container,
                                                   debugDescription: "Invalid user level")
        }
        userLevel = level
    }
    
    
}
