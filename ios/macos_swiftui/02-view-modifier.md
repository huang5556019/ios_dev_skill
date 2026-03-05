# 视图修改器

> 🎨 View Modifier、链式调用、自定义修改器 (Swift 版)

---

## 基础用法

### 什么是 View Modifier

```swift
// View Modifier 本质上是一个接受 View，返回 View 的函数
struct ModifiedContent<Content, Modifier> : View {
    let content: Content
    let modifier: Modifier
}

// 使用方式
Text("Hello")
    .font(.title)           // 返回新的 ModifiedContent
    .foregroundColor(.red) // 链式调用
    .padding()             // 继续修改
```

### 常见 Modifier

```swift
Text("示例文本")
    .font(.title)                    // 字体
    .fontWeight(.bold)              // 字重
    .foregroundColor(.blue)        // 前景色
    .background(Color.yellow)      // 背景色
    .padding(20)                    // 内边距
    .frame(width: 200, height: 100) // 尺寸
    .cornerRadius(10)               // 圆角
    .shadow(radius: 5)              // 阴影
    .opacity(0.8)                  // 透明度
```

---

## 常用修饰器

### 布局

```swift
VStack {
    Text("固定尺寸")
        .frame(width: 100, height: 50)
        .background(Color.red)
    
    Text("最小尺寸")
        .frame(minWidth: 100, minHeight: 50)
        .background(Color.green)
    
    Text("最大尺寸")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
}
.frame(height: 300)
```

### 偏移与对齐

```swift
Text("偏移")
    .offset(x: 10, y: 20)

Text("对齐")
    .frame(width: 200, height: 100)
    .background(Color.gray.opacity(0.3))

Text("位置")
    .position(x: 100, y: 50)
```

### 边框与背景

```swift
RoundedRectangle(cornerRadius: 10)
    .stroke(Color.blue, lineWidth: 2)
    .frame(width: 100, height: 50)

RoundedRectangle(cornerRadius: 10)
    .fill(Color.blue.gradient)
    .frame(width: 100, height: 50)
```

---

## 自定义 View Modifier

### 基本结构

```swift
struct MyModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

// 扩展 View 添加便捷方法
extension View {
    func myStyle(color: Color, cornerRadius: CGFloat = 10) -> some View {
        modifier(MyModifier(color: color, cornerRadius: cornerRadius))
    }
}

// 使用
Text("自定义样式")
    .myStyle(color: .blue)
```

### 带有参数的 Modifier

```swift
struct BorderModifier: ViewModifier {
    var color: Color
    var lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}

extension View {
    func bordered(color: Color, lineWidth: CGFloat = 1) -> some View {
        modifier(BorderModifier(color: color, lineWidth: lineWidth))
    }
}

// 使用
Button("边框按钮") { }
    .bordered(color: .blue, lineWidth: 2)
```

---

## 条件 Modifier

```swift
extension View {
    @ViewBuilder
    func conditionalModifier<T: View>(
        _ condition: Bool,
        transform: (Self) -> T
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// 使用
Text("条件样式")
    .conditionalModifier(isHighlighted) { view in
        view
            .foregroundColor(.red)
            .bold()
    }
```

---

## 组合多个 Modifier

```swift
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.windowBackgroundColor))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// 使用
VStack {
    Text("卡片 1").cardStyle()
    Text("卡片 2").cardStyle()
}
.padding()
```

---

## 环境 Modifier

### 使用 @Environment

```swift
struct ThemeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("当前主题: \(colorScheme == .dark ? "深色" : "浅色")")
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
```

### 自定义环境值

```swift
// 定义
struct AppSettings {
    var accentColor: Color = .blue
    var cornerRadius: CGFloat = 8
}

extension AppSettings: EnvironmentKey {
    static let defaultValue = AppSettings()
}

extension EnvironmentValues {
    var appSettings: AppSettings {
        get { self[AppSettings.self] }
        set { self[AppSettings.self] = newValue }
    }
}

// 使用
struct ContentView: View {
    @Environment(\.appSettings) var settings
    
    var body: some View {
        Text("设置")
            .cornerRadius(settings.cornerRadius)
    }
}
```

---

*最后更新：2026-03-05*
