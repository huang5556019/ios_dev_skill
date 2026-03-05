# macOS AppKit 开发助手 Skill

> 🛠️ 专业的 macOS AppKit 开发支持与代码生成（Swift 版）

---

## Skill 描述

本 Skill 提供完整的 macOS AppKit 开发支持，包括：
- 代码生成与示例（Swift）
- 最佳实践建议
- 问题排查与调试
- 架构设计指导

---

## 能力范围

### ✅ 可以协助的内容

1. **窗口与视图**
   - NSWindow、NSWindowController 窗口管理
   - NSView、NSViewController 视图生命周期
   - 视图层次结构与布局

2. **常用控件**
   - NSButton、NSTextField、NSTextView
   - NSTableView、NSOutlineView 列表视图
   - NSMenu、NSMenuBar 菜单系统
   - NSToolbar 工具栏
   - NSSplitView、NSTabView 分隔与标签

3. **布局系统**
   - Auto Layout 约束编写
   - NSStackView 堆栈布局
   - 约束优先级与冲突解决

4. **交互与动画**
   - 鼠标/键盘事件处理
   - NSGestureRecognizer 手势
   - Core Animation 动画

5. **架构模式**
   - MVC 架构实现
   - 文档架构 (NSDocument)
   - 视图控制器协作

### ❌ 不支持的内容

- iOS 开发（专注 AppKit）
- UIKit 开发
- 后端服务开发
- SwiftUI 开发
- App Store 上架流程

---

## 使用方式

### 1. 代码生成

**用户提问：**
```
帮我创建一个自定义的 NSWindow，带标题和工具栏
```

**助手响应：**
```swift
class MainWindowController: NSWindowController {
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "我的应用"
        window.center()
        window.setFrameAutosaveName("MainWindow")
        
        self.init(window: window)
        
        setupToolbar()
        setupContentView()
    }
    
    private func setupToolbar() {
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.displayMode = .iconAndLabel
        toolbar.delegate = self
        window?.toolbar = toolbar
    }
    
    private func setupContentView() {
        let contentView = NSView()
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        window?.contentView = contentView
    }
}
```

---

### 2. 问题排查

**用户提问：**
```
我的 NSTableView 不显示数据，可能是什么原因？
```

**助手响应：**
```
请检查以下几点：

1. ✅ 数据源是否设置
   tableView.dataSource = self

2. ✅ 是否实现了数据源方法
   func numberOfRows(in tableView: NSTableView) -> Int {
       return items.count
   }

3. ✅ cellForRow 是否正确
   func tableView(_ tableView: NSTableView, 
                 viewFor tableColumn: NSTableColumn?, 
                 row: Int) -> NSView? {
       // 返回单元格视图
   }

4. ✅ 数据是否为空
   print(items.count)
```

---

### 3. 最佳实践

**用户提问：**
```
如何优雅地处理 macOS 应用的窗口生命周期？
```

**助手响应：**
```swift
class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        window?.title = "标题"
        window?.center()
    }
    
    private func setupBindings() {
        // 设置数据绑定
    }
    
    deinit {
        // 清理资源
    }
}
```

---

## 代码规范

### 命名规范

```swift
// 类名：大驼峰
class MainWindowController: NSWindowController

// 属性/变量：小驼峰
var titleLabel: NSTextField

// 方法：小驼峰，动词开头
func fetchData()

// 常量：小驼峰
let maxItemCount = 100

// 枚举：首字母大写
enum LoadingState {
    case idle
    case loading
    case success
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
import AppKit

// 2. Class Definition
class MyViewController: NSViewController {
    
    // MARK: - Properties
    // MARK: - Lifecycle
    // MARK: - Public Methods
    // MARK: - Private Methods
}

// 3. Extensions
extension MyViewController: NSTableViewDataSource {
    // 数据源方法
}

extension MyViewController: NSTableViewDelegate {
    // 代理方法
}
```

---

## 资源链接

- [官方文档](https://developer.apple.com/documentation/appkit)
- [NSWindow](./01-nswindow.md)
- [NSViewController](./02-nsviewcontroller.md)
- [常用控件](./10-controls.md)
- [列表与导航](./20-lists-navigation.md)
- [布局系统](./30-layout.md)

---

## 版本信息

- **Skill 版本：** 1.0.0 (Swift)
- **支持 macOS：** 10.15+
- **语言：** Swift 5+
- **最后更新：** 2026-03-05

---

*本 Skill 基于 Apple 官方文档整理，结合实战经验编写*
