import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    let onEdit: () -> Void
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Circle().fill(Color(contact.avatarColor)).frame(width: 100, height: 100).overlay(Text(String(contact.firstName.prefix(1))).foregroundColor(.white).font(.largeTitle)
                Text(contact.fullName.isEmpty ? "未命名" : contact.fullName).font(.title).fontWeight(.bold)
                if let group = ContactGroup(rawValue: contact.groupName) { Label(group.rawValue, systemImage: group.icon).padding(.horizontal, 12).padding(.vertical, 6).background(Color.secondary.opacity(0.2)).cornerRadius(8) }
                Divider()
                VStack(alignment: .leading, spacing: 16) {
                    if !contact.email.isEmpty { DetailInfoRow(icon: "envelope", title: "邮箱", value: contact.email) }
                    if !contact.phone.isEmpty { DetailInfoRow(icon: "phone", title: "电话", value: contact.phone) }
                    if !contact.notes.isEmpty { VStack(alignment: .leading) { Label("备注", systemImage: "note.text").font(.caption).foregroundColor(.secondary); Text(contact.notes) } }
                }.padding(.horizontal)
                Spacer()
                HStack(spacing: 16) { Button("编辑") { onEdit() }.buttonStyle(.bordered); Button("删除") { showDeleteAlert = true }.buttonStyle(.bordered).tint(.red) }
            }.padding()
        }
        .navigationTitle("详情")
        .alert("确认删除", isPresented: $showDeleteAlert) { Button("取消", role: .cancel) { }; Button("删除", role: .destructive) { onDelete() } } message: { Text("确定要删除 \(contact.fullName) 吗？") }
    }
}

struct DetailInfoRow: View {
    let icon: String; let title: String; let value: String
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon).frame(width: 24).foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 2) { Text(title).font(.caption).foregroundColor(.secondary); Text(value) }
            Spacer()
        }
    }
}
