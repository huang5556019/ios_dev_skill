import Foundation

struct Contact: Identifiable, Codable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var groupName: String
    var notes: String
    var avatarColor: String
    var createdAt: Date
    var updatedAt: Date
    
    var fullName: String { "\(firstName) \(lastName)" }
    
    init(id: UUID = UUID(), firstName: String, lastName: String, email: String = "", phone: String = "", groupName: String = "其他", notes: String = "", avatarColor: String = "blue", createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id; self.firstName = firstName; self.lastName = lastName; self.email = email; self.phone = phone; self.groupName = groupName; self.notes = notes; self.avatarColor = avatarColor; self.createdAt = createdAt; self.updatedAt = updatedAt
    }
}

enum ContactGroup: String, CaseIterable, Codable {
    case family = "家人"
    case friends = "朋友"
    case colleagues = "同事"
    case other = "其他"
    
    var icon: String {
        switch self { case .family: return "house"; case .friends: return "person.2"; case .colleagues: return "briefcase"; case .other: return "person.crop.circle" }
    }
}
