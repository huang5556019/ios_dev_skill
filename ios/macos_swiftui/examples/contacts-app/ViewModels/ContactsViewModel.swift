import Foundation
import SwiftUI

@Observable
class ContactsViewModel {
    var contacts: [Contact] = []
    var selectedGroup: ContactGroup?
    var selectedContact: Contact?
    var searchText = ""
    var isEditing = false
    var isLoading = false
    var errorMessage: String?
    
    var filteredContacts: [Contact] {
        var result = contacts
        if let group = selectedGroup { result = result.filter { $0.groupName == group.rawValue } }
        if !searchText.isEmpty {
            result = result.filter { $0.firstName.localizedCaseInsensitiveContains(searchText) || $0.lastName.localizedCaseInsensitiveContains(searchText) || $0.email.localizedCaseInsensitiveContains(searchText) }
        }
        return result.sorted { $0.lastName < $1.lastName }
    }
    
    var groupCounts: [String: Int] {
        var counts: [String: Int] = ["全部": contacts.count]
        for group in ContactGroup.allCases { counts[group.rawValue] = contacts.filter { $0.groupName == group.rawValue }.count }
        return counts
    }
    
    func loadContacts() {
        isLoading = true
        do { contacts = try DatabaseManager.shared.getAllContacts() } catch { errorMessage = "加载失败: \(error.localizedDescription)" }
        isLoading = false
    }
    
    func addNewContact() {
        let newContact = Contact(firstName: "", lastName: "", groupName: "其他")
        do { try DatabaseManager.shared.insertContact(newContact); contacts.append(newContact); selectedContact = newContact; isEditing = true } catch { errorMessage = "添加失败: \(error.localizedDescription)" }
    }
    
    func saveContact(_ contact: Contact) {
        do {
            if contacts.contains(where: { $0.id == contact.id }) {
                try DatabaseManager.shared.updateContact(contact)
                if let idx = contacts.firstIndex(where: { $0.id == contact.id }) { contacts[idx] = contact }
            } else {
                try DatabaseManager.shared.insertContact(contact)
                contacts.append(contact)
            }
            isEditing = false
        } catch { errorMessage = "保存失败: \(error.localizedDescription)" }
    }
    
    func deleteContact(_ contact: Contact) {
        do { try DatabaseManager.shared.deleteContact(id: contact.id); contacts.removeAll { $0.id == contact.id }; if selectedContact?.id == contact.id { selectedContact = nil } } catch { errorMessage = "删除失败: \(error.localizedDescription)" }
    }
}
