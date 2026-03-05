import SwiftUI

struct ContentView: View {
    @Environment(ContactsViewModel.self) private var viewModel
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
        } content: {
            ContactListView()
        } detail: {
            if let contact = viewModel.selectedContact {
                if viewModel.isEditing {
                    ContactEditView(contact: contact, onSave: { updatedContact in viewModel.saveContact(updatedContact) }, onCancel: { viewModel.isEditing = false })
                } else {
                    ContactDetailView(contact: contact, onEdit: { viewModel.isEditing = true }, onDelete: { viewModel.deleteContact(contact) })
                }
            } else {
                ContentUnavailableView("选择联系人", systemImage: "person.crop.circle", description: Text("从列表中选择一个联系人查看详情"))
            }
        }
        .navigationTitle("联系人")
        .toolbar {
            ToolbarItem(placement: .primaryAction) { Button(action: { viewModel.addNewContact() }) { Image(systemName: "plus") } }
        }
        .onAppear { viewModel.loadContacts() }
    }
}
