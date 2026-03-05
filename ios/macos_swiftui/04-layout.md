# 布局系统

> 📐 VStack, HStack, ZStack, Grid, ScrollView (Swift 版)

---

## VStack

### 基础用法

```swift
VStack {
    Text("第一行")
    Text("第二行")
    Text("第三行")
}
```

### 对齐方式

```swift
// leading（左对齐）
VStack(alignment: .leading) {
    Text("左对齐")
    Text("内容")
}
.frame(width: 200)

// center（居中）
VStack(alignment: .center) {
    Text("居中")
    Text("内容")
}

// trailing（右对齐）
VStack(alignment: .trailing) {
    Text("右对齐")
    Text("内容")
}

// 间距
VStack(spacing: 20) {
    Text("第一行")
    Text("第二行")
}
```

---

## HStack

### 基础用法

```swift
HStack {
    Image(systemName: "star")
    Text("标题")
    Spacer()
}
.padding()
```

### 对齐方式

```swift
// top（顶部对齐）
HStack(alignment: .top) {
    Text("长文本")
    Image(systemName: "star")
}
.frame(height: 100)

// center（居中，默认）
HStack(alignment: .center) {
    Text("文本")
    Image(systemName: "star")
}

// bottom（底部对齐）
HStack(alignment: .bottom) {
    Text("文本")
    Image(systemName: "star")
}
.frame(height: 100)
```

---

## ZStack

### 基础用法

```swift
ZStack {
    Color.blue
    Text("叠加内容")
}
.frame(width: 200, height: 100)
```

### 常用场景

```swift
// 背景 + 内容
ZStack {
    RoundedRectangle(cornerRadius: 10)
        .fill(Color.blue)
    
    Text("卡片内容")
}

// 覆盖层
ZStack {
    Image("background")
    
    VStack {
        Spacer()
        HStack {
            Spacer()
            Text("右下角")
        }
    }
}
```

---

## LazyVStack / LazyHStack

### 性能优化

```swift
// 懒加载，仅在需要时渲染
LazyVStack {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}

// 分页加载
LazyVStack {
    ForEach(items) { item in
        ItemRow(item: item)
    }
    
    if hasMore {
        ProgressView()
            .onAppear {
                loadMore()
            }
    }
}
```

---

## Grid

### LazyVGrid

```swift
let columns = [
    GridItem(.flexible()),
    GridItem(.fixed(100)),
    GridItem(.adaptive(minimum: 80))
]

LazyVGrid(columns: columns, spacing: 10) {
    ForEach(0..<20, id: \.self) { index in
        Text("\(index)")
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.3))
    }
}
```

### GridItem

```swift
// 固定宽度
GridItem(.fixed(100))

// 灵活宽度
GridItem(.flexible())

// 自适应（根据空间自动调整）
GridItem(.adaptive(minimum: 80, maximum: 200))
```

---

## ScrollView

### 基础用法

```swift
ScrollView {
    VStack {
        ForEach(1..<20) { i in
            Text("项目 \(i)")
                .padding()
        }
    }
}
```

### 滚动方向

```swift
// 垂直滚动（默认）
ScrollView {
    // 内容
}

// 水平滚动
ScrollView(.horizontal) {
    HStack {
        ForEach(1..<10) { i in
            Text("\(i)")
                .frame(width: 100)
        }
    }
}

// 同时支持两个方向
ScrollView([.horizontal, .vertical]) {
    // 内容
}
```

---

## GeometryReader

### 获取尺寸

```swift
GeometryReader { geometry in
    VStack {
        Text("宽度: \(geometry.size.width)")
        Text("高度: \(geometry.size.height)")
    }
    .frame(width: geometry.size.width, height: geometry.size.height)
}
```

### 响应式布局

```swift
GeometryReader { geo in
    if geo.size.width > 600 {
        // 宽屏布局
        HStack {
            SidebarView()
            DetailView()
        }
    } else {
        // 窄屏布局
        NavigationStack {
            ListView()
        }
    }
}
```

---

## Spacer 与 Divider

### Spacer

```swift
HStack {
    Text("左侧")
    Spacer()  // 占据中间空间
    Text("右侧")
}

VStack {
    Text("顶部")
    Spacer()  // 占据中间空间
    Text("底部")
}
.frame(height: 200)
```

### Divider

```swift
VStack {
    Text("第一行")
    Divider()
    Text("第二行")
    Divider()
    Text("第三行")
}
```

---

*最后更新：2026-03-05*
