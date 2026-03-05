# SwiftUI 基础

> 📘 View 协议、some View、属性构建器 (Swift 版)

---

## View 协议

### 基础定义

```swift
protocol View {
    associatedtype Body : View
    @ViewBuilder var body: Self.Body { get }
}
```

### 自定义视图

```swift
struct MyView: View {
    var body: some View {
        Text("Hello SwiftUI")
            .font(.title)
            .foregroundColor(.primary)
    }
}
```

---

## some View

### 不透明返回类型

```swift
// ✅ 推荐：使用 some View
var body: some View {
    VStack {
        Text("标题")
        Button("点击") { }
    }
}

// ❌ 避免：明确的返回类型
var body: some View {
    // 返回类型会变得非常复杂
    TupleView<(Text, Button)>(...)
}
```

### some 关键字的作用

```swift
// some View 表示返回某个具体 View 类型，但不需要指定具体类型
// 编译器会自动推断具体类型

func createView() -> some View {
    if condition {
        return Text("True")  // 返回 Text
    } else {
        return Text("False") // 返回 Text，类型一致
    }
}
```

---

## 属性构建器

### @ViewBuilder

```swift
struct ContainerView: View {
    let showTitle: Bool
    
    // 使用 @ViewBuilder 自动组合多个视图
    @ViewBuilder
    var content: some View {
        if showTitle {
            Text("标题")
        }
        
        ForEach(items) { item in
            Text(item.name)
        }
    }
    
    var body: some View {
        VStack {
            content
        }
    }
}
```

### @ResultBuilder (Swift 17+)

```swift
@ResultBuilder
struct ViewBuilder {
    static func buildBlock() -> some View {
        EmptyView()
    }
    
    static func buildBlock(_ views: View...) -> some View {
        ForEach(Array(views.enumerated()), id: \.offset) { _, view in
            view
        }
    }
}
```

---

## 视图组合

### 基本组合

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("标题")
                .font(.largeTitle)
            
            HStack {
                Button("选项 1") { }
                Button("选项 2") { }
            }
            
            Image(systemName: "star")
                .resizable()
                .frame(width: 50, height: 50)
        }
        .padding()
    }
}
```

### 条件视图

```swift
struct ConditionalView: View {
    let isLoggedIn: Bool
    
    var body: some View {
        VStack {
            if isLoggedIn {
                WelcomeView()
            } else {
                LoginView()
            }
        }
    }
}
```

### 循环视图

```swift
struct ListView: View {
    let items = ["苹果", "香蕉", "橙子"]
    
    var body: some View {
        VStack {
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
    }
}
```

---

## View 生命周期

### 初始化

```swift
struct MyView: View {
    let title: String
    let count: Int
    
    // 使用 let 或 var 声明属性
    @State private var isSelected: Bool = false
    
    init(title: String, count: Int = 0) {
        self.title = title
        self.count = count
    }
    
    var body: some View {
        Text(title)
            .onAppear {
                print("视图出现")
            }
            .onDisappear {
                print("视图消失")
            }
    }
}
```

---

## 常见模式

### 视图作为属性

```swift
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
    }
}

// 使用
CardView {
    VStack {
        Text("标题")
        Text("内容")
    }
}
```

### 泛型视图

```swift
struct GenericCard<T: View>: View {
    let content: T
    
    var body: some View {
        content
            .padding()
            .background(Color.blue.opacity(0.1))
    }
}
```

---

*最后更新：2026-03-05*
