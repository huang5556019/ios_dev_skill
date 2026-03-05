# 状态管理

> 🔄 @State, @Binding, @Published, @Environment, @EnvironmentObject (Swift 版)

---

## @State

### 基础用法

```swift
struct CounterView: View {
    @State private var count = 0
    @State private var isEnabled = false
    
    var body: some View {
        VStack {
            Text("计数: \(count)")
                .font(.title)
            
            HStack {
                Button("-") { count -= 1 }
                Button("+") { count += 1 }
            }
            
            Toggle("启用", isOn: $isEnabled)
        }
        .padding()
    }
}
```

### 适用场景

- 视图私有的简单状态
- 不需要在视图间共享的数据
- 值类型（struct、enum）

---

## @Binding

### 基础用法

```swift
struct ToggleView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("开关", isOn: $isOn)
    }
}

struct ParentView: View {
    @State private var isOn = false
    
    var body: some View {
        ToggleView(isOn: $isOn)  // 传递绑定
    }
}
```

### 双向绑定

```swift
struct EditableText: View {
    @Binding var text: String
    
    var body: some View {
        TextField("输入文本", text: $text)
    }
}
```

---

## @Published (ObservableObject)

### 基础用法

```swift
class DataStore: ObservableObject {
    @Published var items: [String] = []
    @Published var isLoading = false
    
    func addItem(_ item: String) {
        items.append(item)
    }
}

struct ContentView: View {
    @StateObject private var store = DataStore()
    
    var body: some View {
        List {
            ForEach(store.items, id: \.self) { item in
                Text(item)
            }
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
    }
}
```

### 监听变化

```swift
struct DetailView: View {
    @ObservedObject var store: DataStore
    
    var body: some View {
        Text("共 \(store.items.count) 项")
    }
}
```

---

## @EnvironmentObject

### 基础用法

```swift
// 定义共享数据
class AppSettings: ObservableObject {
    @Published var username = ""
    @Published var isDarkMode = false
}

// 在 App 中注入
@main
struct MyApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}

// 在任意视图中使用
struct ProfileView: View {
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        Form {
            TextField("用户名", text: $settings.username)
            Toggle("深色模式", isOn: $settings.isDarkMode)
        }
    }
}
```

---

## @Environment

### 常用环境值

```swift
struct EnvView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.locale) var locale
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("颜色模式: \(colorScheme == .dark ? "深色" : "浅色")")
            Text("语言: \(locale.identifier)")
            
            Button("关闭") {
                dismiss()
            }
        }
    }
}
```

### 自定义环境值

```swift
// 定义
struct APIConfiguration {
    let baseURL: String
    let apiKey: String
}

extension APIConfiguration: EnvironmentKey {
    static let defaultValue = APIConfiguration(baseURL: "", apiKey: "")
}

extension EnvironmentValues {
    var apiConfig: APIConfiguration {
        get { self[APIConfiguration.self] }
        set { self[APIConfiguration.self] = newValue }
    }
}

// 注入
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.apiConfig, APIConfiguration(
                    baseURL: "https://api.example.com",
                    apiKey: "key123"
                ))
        }
    }
}
```

---

## @StateObject vs @ObservedObject

### @StateObject

- 在视图创建时初始化
- 视图生命周期内保持唯一实例
- **推荐用于顶级数据**

```swift
struct ParentView: View {
    @StateObject private var store = DataStore()  // 创建实例
    
    var body: some View {
        ChildView(store: store)
    }
}
```

### @ObservedObject

- 由父视图传入
- 可能在多处使用
- **用于接收外部传入的数据**

```swift
struct ChildView: View {
    @ObservedObject var store: DataStore
    
    var body: some View {
        // 使用 store
    }
}
```

---

## @Observable (macOS 14+)

### 新API

```swift
@Observable
class AppState {
    var count = 0
    var items: [String] = []
}

struct ContentView: View {
    let state: AppState
    
    var body: some View {
        VStack {
            Text("\(state.count)")
            
            Button("增加") {
                state.count += 1
            }
        }
    }
}
```

---

*最后更新：2026-03-05*
