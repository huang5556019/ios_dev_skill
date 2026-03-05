# 导航

> 🧭 NavigationStack, NavigationSplitView, TabView, Toolbar (Swift 版)

---

## NavigationStack

### 基础用法

```swift
NavigationStack {
    List(items) { item in
        NavigationLink(item.name, destination: DetailView(item: item))
    }
    .navigationTitle("列表")
}
```

### 跳转传值

```swift
NavigationStack {
    List(items) { item in
        NavigationLink(value: item) {
            Label(item.name, systemImage: item.icon)
        }
    }
    .navigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
}
.navigationTitle("首页")
```

### 工具栏导航

```swift
NavigationStack {
    List(items) { item in
        NavigationLink(item.name, value: item)
    }
    .navigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
    .toolbar {
        ToolbarItem(placement: .primaryAction) {
            Button(action: addItem) {
                Image(systemName: "plus")
            }
        }
    }
}
```

---

## NavigationSplitView

### 两列布局

```swift
NavigationSplitView {
    List(items, selection: $selectedItem) { item in
        NavigationLink(value: item) {
            Label(item.name, systemImage: item.icon)
        }
    }
    .navigationTitle("侧边栏")
} detail: {
    if let item = selectedItem {
        DetailView(item: item)
    } else {
        Text("选择一个项目")
            .foregroundColor(.secondary)
    }
}
```

### 三列布局

```swift
NavigationSplitView {
    List(categories, selection: $selectedCategory) { category in
        NavigationLink(value: category) {
            Label(category.name, systemImage: category.icon)
        }
    }
    .navigationTitle("分类")
} content: {
    if let category = selectedCategory {
        List(category.items, id: \.self) { item in
            NavigationLink(value: item) {
                Text(item.name)
            }
        }
        .navigationTitle(category.name)
    }
} detail: {
    if let item = selectedItem {
        DetailView(item: item)
    } else {
        Text("选择一个项目")
    }
}
```

---

## TabView

### 基础用法

```swift
TabView {
    HomeView()
        .tabItem {
            Label("首页", systemImage: "house")
        }
    
    SettingsView()
        .tabItem {
            Label("设置", systemImage: "gear")
        }
}
```

### 带标签

```swift
TabView(selection: $selectedTab) {
    HomeView()
        .tabItem {
            Label("首页", systemImage: "house")
        }
        .tag(0)
    
    SettingsView()
        .tabItem {
            Label("设置", systemImage: "gear")
        }
        .tag(1)
}
```

### 样式

```swift
TabView {
    HomeView()
        .tabItem {
            Label("首页", systemImage: "house")
        }
}
.tabViewStyle(.automatic)

TabView {
    HomeView()
        .tabItem {
            Label("首页", systemImage: "house")
        }
}
.tabViewStyle(.page)
```

---

## Toolbar

### 基础用法

```swift
NavigationStack {
    List(items) { item in
        Text(item.name)
    }
    .navigationTitle("列表")
    .toolbar {
        ToolbarItem(placement: .primaryAction) {
            Button(action: addItem) {
                Image(systemName: "plus")
            }
        }
        
        ToolbarItem(placement: .cancellationAction) {
            Button("取消") { }
        }
    }
}
```

### 位置

```swift
.toolbar {
    // 导航栏leading
    ToolbarItem(placement: .navigation) {
        Button(action: toggleSidebar) {
            Image(systemName: "sidebar.left")
        }
    }
    
    // 导航栏trailing
    ToolbarItem(placement: .primaryAction) {
        Button("保存") { }
    }
    
    // 底部
    ToolbarItem(placement: .bottomBar) {
        HStack {
            Button("左") { }
            Spacer()
            Button("右") { }
        }
    }
}
```

### Toolbar 配合

```swift
.navigationTitle("详情")
.toolbar {
    ToolbarItemGroup(placement: .primaryAction) {
        Button(action: share) {
            Image(systemName: "square.and.arrow.up")
        }
        
        Button(action: delete) {
            Image(systemName: "trash")
        }
    }
}
```

---

## Sheet 模态

### 基础用法

```swift
@State private var showingSheet = false

Button("显示") {
    showingSheet = true
}
.sheet(isPresented: $showingSheet) {
    SheetView()
}
```

### 传递数据

```swift
.sheet(item: $selectedItem) { item in
    DetailView(item: item)
}
```

### 全屏覆盖

```swift
.fullScreenCover(isPresented: $showingFullScreen) {
    FullScreenView()
}
```

---

## Alert 警告框

```swift
@State private var showingAlert = false

Button("显示警告") {
    showingAlert = true
}
.alert("标题", isPresented: $showingAlert) {
    Button("取消", role: .cancel) { }
    Button("确认", role: .destructive) { }
} message: {
    Text("这是警告内容")
}
```

---

*最后更新：2026-03-05*
