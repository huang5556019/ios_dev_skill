# 高级主题

> 🚀 性能优化、AppKit集成、SwiftUI for macOS特性 (Swift 版)

---

## AppKit 集成

### NSViewRepresentable

```swift
import SwiftUI
import AppKit

struct NSViewWrapper: NSViewRepresentable {
    let text: String
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.stringValue = text
        textField.isEditable = false
        textField.isBordered = false
        textField.backgroundColor = .clear
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}

// 使用
NSViewWrapper(text: "AppKit 视图")
```

### NSViewControllerRepresentable

```swift
struct NSViewControllerWrapper: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSViewController {
        // 返回自定义 NSViewController
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // 更新
    }
}
```

---

## UIKit 集成

### UIViewRepresentable

```swift
import SwiftUI
import UIKit

struct UIViewWrapper: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
}
```

---

## 性能优化

### 懒加载

```swift
// 使用 LazyVStack / LazyHStack
LazyVStack {
    ForEach(largeDataset) { item in
        ItemRow(item: item)
    }
}

// 使用 LazyVGrid
LazyVGrid(columns: [GridItem(.flexible())]) {
    ForEach(largeDataset) { item in
        ItemView(item: item)
    }
}
```

### 标识符优化

```swift
// ❌ 每次重新创建 ID
ForEach(items) { item in
    Text(item.name)
}

// ✅ 使用稳定 ID
ForEach(items, id: \.id) { item in
    Text(item.name)
}
```

### 避免重复计算

```swift
// ✅ 使用 @State 缓存计算结果
@State private var sortedItems: [Item] = []

var body: some View {
    List(sortedItems) { item in
        Text(item.name)
    }
    .onAppear {
        sortedItems = items.sorted()
    }
}
```

### 减少视图重建

```swift
// 使用 @equatable
struct ItemRow: View, Equatable {
    let item: Item
    
    static func == (lhs: ItemRow, rhs: ItemRow) -> Bool {
        lhs.item.id == rhs.item.id && lhs.item.name == rhs.item.name
    }
}
```

---

## macOS 特性

### Window 样式

```swift
struct ContentView: View {
    var body: some View {
        List {
            Text("内容")
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
```

### 菜单栏

```swift
import SwiftUI

struct MenuBarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("新建") { }
                Button("打开") { }
            }
            
            Menu("视图") {
                Button("显示侧边栏") { }
                Button("全屏") { }
            }
        }
    }
}
```

### 工具栏

```swift
struct ToolbarView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
```

---

## 架构模式

### MVVM

```swift
// Model
struct Item: Identifiable {
    let id = UUID()
    let name: String
}

// ViewModel
@Observable
class ItemViewModel {
    var items: [Item] = []
    var isLoading = false
    
    func loadItems() async {
        isLoading = true
        // 加载数据
        items = [
            Item(name: "项目 1"),
            Item(name: "项目 2")
        ]
        isLoading = false
    }
}

// View
struct ItemListView: View {
    let viewModel: ItemViewModel
    
    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
        }
        .task {
            await viewModel.loadItems()
        }
    }
}
```

---

## 调试技巧

### 调试视图

```swift
// 打印视图层级
struct DebugView: View {
    var body: some View {
        someView
            .print("\(MyStruct.self)")
    }
}

// 条件调试
struct ConditionalDebug: View {
    var body: some View {
        #if DEBUG
        Text("调试信息")
        #endif
    }
}
```

---

## 常见问题

### 视图不更新

```swift
// 检查：状态是否正确标记为 @State
@State private var count = 0

// 检查：是否使用 $ 绑定
@State private var text = ""
TextField("输入", text: $text)

// 检查：类是否遵循 ObservableObject
class DataStore: ObservableObject { }
```

### 布局问题

```swift
// 使用 frame 明确尺寸
Text("固定尺寸")
    .frame(width: 100, height: 50)

// 使用 GeometryReader 获取父视图尺寸
GeometryReader { geometry in
    // 使用 geometry.size
}
```

---

*最后更新：2026-03-05*
