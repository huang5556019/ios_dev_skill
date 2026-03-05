import SwiftUI

@main
struct ContactsAppApp: App {
    @State private var viewModel = ContactsViewModel()
    
    init() {
        do {
            try DatabaseManager.shared.initialize()
        } catch {
            print("数据库初始化失败: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .windowStyle(.automatic)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("新建联系人") {
                    viewModel.addNewContact()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }
    }
}
