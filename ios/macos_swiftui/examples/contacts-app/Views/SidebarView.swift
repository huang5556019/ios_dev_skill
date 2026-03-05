import SwiftUI

struct SidebarView: View {
    @Environment(ContactsViewModel.self) private var viewModel
    
    var body: some View {
        List(selection: Binding(get: { viewModel.selectedGroup }, set: { viewModel.selectedGroup = $0 })) {
            Section("分组") {
                Button { viewModel.selectedGroup = nil } label: { Label { HStack { Text("所有联系人"); Spacer(); Text("\(viewModel.groupCounts["全部"] ?? 0)").foregroundColor(.secondary).font(.caption) } icon: { Image(systemName: "person.3") } }.buttonStyle(.plain).listRowBackground(viewModel.selectedGroup == nil ? Color.accentColor.opacity(0.2) : Color.clear)
                ForEach(ContactGroup.allCases, id: \.self) { group in Label { HStack { Text(group.rawValue); Spacer(); Text("\(viewModel.groupCounts[group.rawValue] ?? 0)").foregroundColor(.secondary).font(.caption) } icon: { Image(systemName: group.icon) }.tag(group) }
            }
        }
        .listStyle(.sidebar).navigationTitle("联系人").frame(minWidth: 180)
    }
}
