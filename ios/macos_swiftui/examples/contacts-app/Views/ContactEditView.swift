import SwiftUI

struct ContactEditView: View {
    @State private var contact: Contact
    let onSave: (Contact) -> Void
    let onCancel: () -> Void
    
    init(contact: Contact, onSave: @escaping (Contact) -> Void, onCancel: @escaping () -> Void) {
        _contact = State(initialValue: contact)
        self.onSave = onSave; self.onCancel = onCancel
    }
    
    var body: some View {
        Form {
            Section("基本信息") {
                TextField("名", text: $contact.firstName)
                TextField("姓", text: $contact.lastName)
                Picker("分组", selection: $contact.groupName) { ForEach(ContactGroup.allCases, id: \.rawValue) { Label($0.rawValue, systemImage: $0.icon).tag($0.rawValue) } }
            }
            Section("联系方式") {
                TextField("邮箱", text: $contact.email).textContentType(.emailAddress)
                TextField("电话", text: $contact.phone).textContentType(.telephoneNumber)
            }
            Section("备注") { TextEditor(text: $contact.notes).frame(minHeight: 80) }
            Section("头像颜色") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                    ForEach(["blue", "green", "orange", "purple", "red", "pink", "yellow", "cyan"], id: \.self) { color in
                        Circle().fill(Color(color)).frame(width: 44, height: 44).overlay(Circle().stroke(Color.primary, lineWidth: contact.avatarColor == color ? 3 : 0)).onTapGesture { contact.avatarColor = color }
                    }
                }.padding(.vertical, 8)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(contact.firstName.isEmpty && contact.lastName.isEmpty ? "新建联系人" : "编辑联系人")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("取消") { onCancel() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") { var updated = contact; updated.updatedAt = Date(); onSave(updated) }.disabled(contact.firstName.isEmpty || contact.lastName.isEmpty)
            }
        }
    }
}
