import Foundation

@objc class Contact: NSObject, Identifiable {
    @objc var id: String
    @objc var firstName: String
    @objc var lastName: String
    @objc var email: String
    @objc var phone: String
    @objc var groupName: String
    @objc var notes: String
    @objc var avatarColor: String
    @objc var createdAt: Date
    @objc var updatedAt: Date
    
    @objc var fullName: String { "\(firstName) \(lastName)" }
    
    @objc init(id: String = UUID().uuidString, firstName: String, lastName: String, email: String = "", phone: String = "", groupName: String = "其他", notes: String = "", avatarColor: String = "blue", createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id; self.firstName = firstName; self.lastName = lastName; self.email = email; self.phone = phone; self.groupName = groupName; self.notes = notes; self.avatarColor = avatarColor; self.createdAt = createdAt; self.updatedAt = updatedAt
    }
    
    @objc static let allGroups = ["家人", "朋友", "同事", "其他"]
}
