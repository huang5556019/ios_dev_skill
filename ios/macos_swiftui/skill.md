# macOS SwiftUI 开发助手 Skill

> 🛠️ 专业的 macOS SwiftUI 开发支持与代码生成（Swift 版）

---

## Skill 描述

本 Skill 提供完整的 macOS SwiftUI 开发支持，包括：
- 代码生成与示例（Swift + SwiftUI）
- 最佳实践建议
- 问题排查与调试
- 架构设计指导

---

## 能力范围

### ✅ 可以协助的内容

1. **SwiftUI 基础**
   - View 协议与视图构建
   - 视图修改器（View Modifier）
   - 属性构建器（Property Wrappers）

2. **状态管理**
   - @State、@Binding、@Published
   - @Environment、@EnvironmentObject
   - 状态共享与传递

3. **布局系统**
   - VStack、HStack、ZStack
   - LazyVGrid、LazyHGrid
   - ScrollView 与 GeometryReader

4. **基础控件**
   - Text、Button、TextField
   - Toggle、Slider、Picker
   - DatePicker、ColorPicker

5. **列表与导航**
   - List、ForEach、Identifiable
   - NavigationStack、NavigationSplitView
   - TabView、Toolbar

6. **交互与动画**
   - 手势识别（Gesture）
   - 动画系统
   - 过渡效果

7. **自定义绘图**
   - Canvas、Shape、Path
   - 自定义图形绘制

8. **高级主题**
   - AppKit 集成
   - 性能优化
   - 架构模式（MVVM）

### ❌ 不支持的内容

- iOS 开发（专注 macOS）
- UIKit 开发
- AppKit 开发（可提供集成建议）
- 后端服务开发
- App Store 上架流程

---

## 使用方式

### 1. 代码生成

**用户提问：**
```
帮我创建一个自定义的 macOS 窗口，带有工具栏和侧边栏
```

**助手响应：**
```swift
struct ContentView: View {
    @State private var selectedItem: String?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(["首页", "设置", "关于"], id: \.self, selection: $selectedItem) { item in
                NavigationLink(value: item) {
                    Label(item, systemImage: iconName(for: item))
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 300)
        } detail: {
            if let item = selectedItem {
                DetailView(title: item)
            } else {
                Text("选择一个项目")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("我的应用")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    private func iconName(for item: String) -> String {
        switch item {
        case "首页": return "house"
        case "设置": return "gear"
        case "关于": return "info.circle"
        default: return "doc"
        }
    }
}

struct DetailView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .padding()
    }
}
```

---

### 2. 问题排查

**用户提问：**
```
我的 SwiftUI 列表不显示数据，可能是什么原因？
```

**助手响应：**
```
请检查以下几点：

1. ✅ 数据是否正确传递
   确保数据源是一个 @State 变量或 @ObservedObject

2. ✅ 是否实现了 Identifiable 协议
   struct Item: Identifiable {
       let id = UUID()
       let name: String
   }

3. ✅ List 的 content 是否正确
   List(items) { item in
       Text(item.name)
   }

4. ✅ ForEach 的 id 参数
   List {
       ForEach(items, id: \.id) { item in
           Text(item.name)
       }
   }

5. ✅ 是否在正确的上下文中
   确保在 View 的 body 中使用
```

---

### 3. 最佳实践

**用户提问：**
```
如何优雅地管理 SwiftUI 应用的视图状态？
```

**助手响应：**
```swift
// 推荐：使用 @Observable (macOS 14+)
@Observable
class AppState {
    var isLoading = false
    var items: [Item] = []
    var error: Error?
    
    func fetchItems() async {
        isLoading = true
        defer { isLoading = false }
        // 加载数据
    }
}

// 使用
struct ContentView: View {
    @State private var appState = AppState()
    
    var body: some View {
        Group {
            if appState.isLoading {
                ProgressView()
            } else {
                List(appState.items) { item in
                    Text(item.name)
                }
            }
        }
        .task {
            await appState.fetchItems()
        }
    }
}

// 或使用 ObservableObject（兼容旧版本）
class AppState: ObservableObject {
    @Published var isLoading = false
    @Published var items: [Item] = []
}
```

---

## 代码规范

### 命名规范

```swift
// 视图名：大驼峰 + View 后缀
struct MainContentView: View
struct SidebarView: View

// 属性/变量：小驼峰
@State private var isExpanded: Bool = false
@Binding var selectedItem: Item?

// 方法：小驼峰，动词开头
func fetchData() async { }

// 常量：大驼峰
let maxItemCount = 100

// 枚举：首字母大写
enum ViewState {
    case loading
    case loaded
    case error(Error)
}
```

### 注释规范

```swift
// MARK: - Lifecycle
// MARK: - Properties
// MARK: - Public Methods
// MARK: - Private Methods

/// 获取用户信息
/// - Parameter userID: 用户 ID
/// - Returns: 用户信息对象
func fetchUser(with userID: String) -> User?
```

### 文件组织

```swift
// 1. Imports
import SwiftUI

// 2. Main View
struct MyView: View {
    // MARK: - Properties
    // MARK: - Body
    var body: some View {
        // 内容
    }
}

// 3. Subviews
private struct HeaderView: View {
    var body: some View {
        // 子视图
    }
}

// 4. Extensions
extension MyView: SomeProtocol {
    // 协议实现
}
```

### SwiftUI 特定规范

```swift
// 使用推断返回类型
var body: some View {
    VStack {
        Text("Hello")
        Button("Click") { }
    }
}

// 拆分复杂视图
var body: some View {
    VStack(spacing: 20) {
        headerView
        contentView
        footerView
    }
}

// 避免过度抽象
// ❌ 不好：过度使用 @Environment
// ✅ 好：只在必要时使用

// 使用 computed 属性简化 body
var isLoading: Bool { appState.isLoading }

var body: some View {
    if isLoading {
        ProgressView()
    } else {
        contentView
    }
}
```

---

## 资源链接

- [官方文档](https://developer.apple.com/documentation/swiftui)
- [SwiftUI 基础](./01-view-basics.md)
- [视图修改器](./02-view-modifier.md)
- [状态管理](./03-state-binding.md)
- [布局系统](./04-layout.md)
- [基础控件](./05-controls.md)
- [列表视图](./06-lists.md)
- [导航](./07-navigation.md)
- [手势与交互](./08-gestures.md)
- [动画](./09-animation.md)
- [自定义绘图](./10-drawing.md)
- [高级主题](./11-advanced.md)

---

## 版本信息

- **Skill 版本：** 1.0.0 (Swift + SwiftUI)
- **支持 macOS：** 13.0+（部分特性需要 14.0+）
- **语言：** Swift 5.9+
- **最后更新：** 2026-03-05

---

*本 Skill 基于 Apple 官方文档整理，结合实战经验编写*
