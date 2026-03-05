# 列表视图

> 📋 List, ForEach, Identifiable, 动态列表 (Swift 版)

---

## List 基础

### 简单列表

```swift
let items = ["苹果", "香蕉", "橙子"]

List(items, id: \.self) { item in
    Text(item)
}
```

### 静态内容

```swift
List {
    Text("静态项 1")
    Text("静态项 2")
    Text("静态项 3")
}
```

### 带标识符

```swift
struct Item: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

let items = [
    Item(name: "首页", icon: "house"),
    Item(name: "设置", icon: "gear"),
    Item(name: "关于", icon: "info.circle")
]

List(items) { item in
    Label(item.name, systemImage: item.icon)
}
```

---

## ForEach

### 基本用法

```swift
List {
    ForEach(0..<10) { index in
        Text("项目 \(index)")
    }
}
```

### 带 ID

```swift
List {
    ForEach(items, id: \.id) { item in
        ItemRow(item: item)
    }
}
```

### 动态创建

```swift
@State private var items = [
    Item(name: "项目 1"),
    Item(name: "项目 2")
]

List {
    ForEach($items) { $item in
        TextField("名称", text: $item.name)
    }
    .onDelete { indexSet in
        items.remove(atOffsets: indexSet)
    }
}
```

---

## List 样式

### 静态样式

```swift
// 默认样式
List {
    Text("默认")
}
.listStyle(.automatic)

// 大图标样式（iOS/macOS）
List {
    Text("大图标")
}
.listStyle(.inset)

List {
    Text("分组")
}
.listStyle(.insetGrouped)
```

### 侧边栏样式 (macOS)

```swift
List {
    NavigationLink("首页", destination: HomeView())
    NavigationLink("设置", destination: SettingsView())
}
.listStyle(.sidebar)
```

---

## 选择与编辑

### 单选

```swift
@State private var selectedItem: Item?

List(selection: $selectedItem) {
    ForEach(items) { item in
        Text(item.name)
            .tag(item)
    }
}
.onChange(of: selectedItem) { _, newValue in
    print("选中: \(newValue?.name ?? "无")")
}
```

### 多选

```swift
@State private var selectedItems = Set<Item.ID>()

List(items, selection: $selectedItems) { item in
    Text(item.name)
        .tag(item.id)
}
```

### 删除

```swift
List {
    ForEach(items) { item in
        Text(item.name)
    }
    .onDelete { indexSet in
        items.remove(atOffsets: indexSet)
    }
}
```

### 移动

```swift
List {
    ForEach(items) { item in
        Text(item.name)
    }
    .onMove { source, destination in
        items.move(fromOffsets: source, toOffset: destination)
    }
}
.toolbar {
    EditButton()
}
```

---

## Section 列表

### 基础

```swift
List {
    Section("分组 1") {
        Text("项 1")
        Text("项 2")
    }
    
    Section("分组 2") {
        Text("项 3")
        Text("项 4")
    }
}
```

### 带页眉页脚

```swift
List {
    Section {
        Text("项 1")
    } header: {
        Text("第一组")
    } footer: {
        Text("这是第一组的说明")
    }
}
```

---

## 嵌套列表

```swift
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let items: [String]
}

let categories = [
    Category(name: "水果", items: ["苹果", "香蕉"]),
    Category(name: "蔬菜", items: ["胡萝卜", "白菜"])
]

List {
    ForEach(categories) { category in
        Section(category.name) {
            ForEach(category.items, id: \.self) { item in
                Text(item)
            }
        }
    }
}
```

---

*最后更新：2026-03-05*
