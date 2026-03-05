import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    private let contactsTable = Table("contacts")
    
    private let id = Expression<String>("id")
    private let firstName = Expression<String>("first_name")
    private let lastName = Expression<String>("last_name")
    private let email = Expression<String?>("email")
    private let phone = Expression<String?>("phone")
    private let groupName = Expression<String>("group_name")
    private let notes = Expression<String?>("notes")
    private let avatarColor = Expression<String>("avatar_color")
    private let createdAt = Expression<Double>("created_at")
    private let updatedAt = Expression<Double>("updated_at")
    
    private init() {}
    
    func initialize() throws {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("contacts.sqlite3")
        db = try Connection(path.path)
        try createTable()
    }
    
    private func createTable() throws {
        try db?.run(contactsTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(firstName)
            t.column(lastName)
            t.column(email)
            t.column(phone)
            t.column(groupName, defaultValue: "其他")
            t.column(notes)
            t.column(avatarColor, defaultValue: "blue")
            t.column(createdAt)
            t.column(updatedAt)
        })
    }
    
    func getAllContacts() throws -> [Contact] {
        guard let db = db else { throw DatabaseError.notInitialized }
        var contacts: [Contact] = []
        for row in try db.prepare(contactsTable.order(lastName.asc, firstName.asc)) {
            let contact = Contact(id: UUID(uuidString: row[id])!, firstName: row[firstName], lastName: row[lastName], email: row[email] ?? "", phone: row[phone] ?? "", groupName: row[groupName], notes: row[notes] ?? "", avatarColor: row[avatarColor], createdAt: Date(timeIntervalSince1970: row[createdAt]), updatedAt: Date(timeIntervalSince1970: row[updatedAt]))
            contacts.append(contact)
        }
        return contacts
    }
    
    func insertContact(_ contact: Contact) throws {
        guard let db = db else { throw DatabaseError.notInitialized }
        try db.run(contactsTable.insert(id <- contact.id.uuidString, firstName <- contact.firstName, lastName <- contact.lastName, email <- contact.email, phone <- contact.phone, groupName <- contact.groupName, notes <- contact.notes, avatarColor <- contact.avatarColor, createdAt <- contact.createdAt.timeIntervalSince1970, updatedAt <- contact.updatedAt.timeIntervalSince1970))
    }
    
    func updateContact(_ contact: Contact) throws {
        guard let db = db else { throw DatabaseError.notInitialized }
        let row = contactsTable.filter(id == contact.id.uuidString)
        try db.run(row.update(firstName <- contact.firstName, lastName <- contact.lastName, email <- contact.email, phone <- contact.phone, groupName <- contact.groupName, notes <- contact.notes, avatarColor <- contact.avatarColor, updatedAt <- Date().timeIntervalSince1970))
    }
    
    func deleteContact(id contactId: UUID) throws {
        guard let db = db else { throw DatabaseError.notInitialized }
        let row = contactsTable.filter(id == contactId.uuidString)
        try db.run(row.delete())
    }
    
    func searchContacts(query: String) throws -> [Contact] {
        guard let db = db else { throw DatabaseError.notInitialized }
        let pattern = "%\(query)%"
        let queryResult = contactsTable.filter(firstName.like(pattern) || lastName.like(pattern) || email.like(pattern)).order(lastName.asc)
        var contacts: [Contact] = []
        for row in try db.prepare(queryResult) {
            let contact = Contact(id: UUID(uuidString: row[id])!, firstName: row[firstName], lastName: row[lastName], email: row[email] ?? "", phone: row[phone] ?? "", groupName: row[groupName], notes: row[notes] ?? "", avatarColor: row[avatarColor], createdAt: Date(timeIntervalSince1970: row[createdAt]), updatedAt: Date(timeIntervalSince1970: row[updatedAt]))
            contacts.append(contact)
        }
        return contacts
    }
}

enum DatabaseError: Error { case notInitialized }
