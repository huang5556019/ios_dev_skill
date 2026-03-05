import SwiftUI

struct ContactListView: View {
    @Environment(ContactsViewModel.self) private var viewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading { ProgressView("加载中...") }
            else if viewModel.filteredContacts.isEmpty { ContentUnavailableView("无联系人", systemImage: "person.crop.circle.badge.plus", description: Text("点击 + 按钮添加联系人")) }
            else {
                List(viewModel.filteredContacts, selection: Binding(get: { viewModel.selectedContact }, set: { viewModel.selectedContact = $0 })) { contact in ContactRowView(contact: contact).tag(contact) }.listStyle(.inset)
            }
        }
        .searchable(text: Binding(get: { viewModel.searchText }, set: { viewModel.searchText = $0 }), prompt: "搜索联系人").navigationTitle("列表").frame(minWidth: 250)
    }
}

struct ContactRowView: View {
    let contact: Contact
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(Color(contact.avatarColor)).frame(width: 40, height: 40).overlay(Text(String(contact.firstName.prefix(1))).foregroundColor(.white).font(.headline)
            VStack(alignment: .leading, spacing: 2) { Text(contact.fullName).font(.headline); if !contact.email.isEmpty { Text(contact.email).font(.subheadline).foregroundColor(.secondary) } }
            Spacer()
        }.padding(.vertical, 4)
    }
}
