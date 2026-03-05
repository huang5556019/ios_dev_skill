# 基础控件

> 🎛️ Text, Button, TextField, Toggle, Slider, Picker (Swift 版)

---

## Text

### 基础用法

```swift
Text("Hello SwiftUI")
Text("带样式的文本")
    .font(.title)
    .fontWeight(.bold)
    .foregroundColor(.blue)
```

### 字体样式

```swift
Text("标题")
    .font(.largeTitle)
    .font(.title)
    .font(.headline)
    .font(.body)
    .font(.caption)
    .font(.system(size: 20, weight: .bold, design: .rounded))
```

### 多行与对齐

```swift
Text("多行文本示例\n第二行\n第三行")
    .lineLimit(2)              // 限制行数
    .lineSpacing(8)            // 行间距
    .multilineTextAlignment(.leading)
    .multilineTextAlignment(.center)
    .multilineTextAlignment(.trailing)
```

### 图文组合

```swift
Label("标签文本", systemImage: "star")

Label {
    Text("自定义内容")
} icon: {
    Image(systemName: "star")
}
```

---

## Button

### 基础用法

```swift
Button("点击我") {
    print("按钮被点击")
}

// 带图标的按钮
Button {
    print("点击")
} label: {
    Label("带图标按钮", systemImage: "star")
}
```

### 样式

```swift
// 普通按钮
Button("普通") { }

// 无样式按钮
Button("无样式") { }
.buttonStyle(.plain)

// 边框按钮
Button("边框") { }
.buttonStyle(.bordered)

// 带轮廓
Button("轮廓") { }
.buttonStyle(.borderedProminent)
```

### 自定义按钮

```swift
struct MyButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
```

---

## TextField

### 基础用法

```swift
@State private var text = ""

TextField("输入文本", text: $text)
    .textFieldStyle(.roundedBorder)
```

### 样式

```swift
// 圆角边框
TextField("圆角", text: $text)
    .textFieldStyle(.roundedBorder)

// 方形边框
TextField("方形", text: $text)
    .textFieldStyle(.squareBorder)

// 无样式
TextField("无样式", text: $text)
    .textFieldStyle(.plain)
```

### 安全输入

```swift
@State private var password = ""

SecureField("密码", text: $password)
```

---

## Toggle

### 基础用法

```swift
@State private var isOn = false

Toggle("开关", isOn: $isOn)
```

### 自定义

```swift
Toggle(isOn: $isOn) {
    Label("启用功能", systemImage: "checkmark.circle")
}

Toggle("深色模式", isOn: $isDarkMode)
    .toggleStyle(.switch)

Toggle("标签", isOn: $isOn)
    .toggleStyle(.checkbox)
```

---

## Slider

### 基础用法

```swift
@State private var value = 0.5

Slider(value: $value)
Slider(value: $value, in: 0...100)
Slider(value: $value, in: 0...100, step: 0.1)
```

### 带标签

```swift
VStack {
    Slider(value: $value, in: 0...100)
    Text("当前值: \(Int(value))")
}
```

---

## Picker

### 基础用法

```swift
@State private var selected = "A"

Picker("选择", selection: $selected) {
    Text("选项 A").tag("A")
    Text("选项 B").tag("B")
    Text("选项 C").tag("C")
}
```

### 样式

```swift
// 菜单样式
Picker("菜单", selection: $selected) {
    Text("A").tag("A")
    Text("B").tag("B")
}
.pickerStyle(.menu)

// 分段样式
Picker("分段", selection: $selected) {
    Text("A").tag("A")
    Text("B").tag("B")
}
.pickerStyle(.segmented)

// 轮转样式
Picker("轮转", selection: $selected) {
    Text("A").tag("A")
    Text("B").tag("B")
}
.pickerStyle(.wheel)
```

---

## DatePicker

```swift
@State private var date = Date()

DatePicker("日期", selection: $date)

DatePicker("日期时间", selection: $date)
    .datePickerStyle(.graphical)

DatePicker("仅日期", selection: $date, displayedComponents: .date)

DatePicker("仅时间", selection: $date, displayedComponents: .hourAndMinute)
```

---

## ColorPicker

```swift
@State private var color = Color.red

ColorPicker("选择颜色", selection: $color)
    .labelsHidden()
```

---

## ProgressView

```swift
// 不确定进度
ProgressView()

// 确定进度
@State private var progress = 0.5
ProgressView(value: progress)
ProgressView("加载中...", value: progress)

// 带标签
ProgressView(value: progress) {
    Text("正在下载...")
}
```

---

*最后更新：2026-03-05*
