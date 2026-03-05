# NSWindow 窗口

> 🪟 macOS 窗口管理完全指南 (Swift 版)

---

## 基础用法

### 创建窗口

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
        
        setupContentView()
    }
    
    private func setupContentView() {
        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        window?.contentView = contentView
    }
}
```

### Style Mask

```swift
// 常用样式
let styleMask: NSWindow.StyleMask = [
    .titled,      // 标题栏
    .closable,    // 关闭按钮
    .miniaturizable, // 最小化按钮
    .resizable,   // 调整大小
    .fullSizeContentView, // 全尺寸内容视图
    .unifiedTitleAndToolbar // 统一标题和工具栏
]
```

---

## 窗口管理

### 显示与隐藏

```swift
window?.makeKeyAndOrderFront(nil)
window?.orderOut(nil)
window?.orderFront(nil)
```

### 窗口层级

```swift
window?.level = .floating
window?.level = .normal
window?.level = .modalPanel
```

### 窗口大小

```swift
window?.minSize = NSSize(width: 400, height: 300)
window?.maxSize = NSSize(width: 1200, height: 900)

window?.setContentSize(NSSize(width: 800, height: 600))
window?.setFrame(NSRect(x: 0, y: 0, width: 800, height: 600), display: true)

window?.center()
```

---

## 窗口控制器

### NSWindowController 用法

```swift
class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.delegate = self
    }
}

extension WindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        // 窗口即将关闭
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        // 窗口成为主窗口
    }
    
    func windowDidResize(_ notification: Notification) {
        // 窗口大小改变
    }
}
```

---

## 工具栏

### 创建工具栏

```swift
class ToolbarWindowController: NSWindowController, NSToolbarDelegate {
    
    private let toolbarIdentifier = NSToolbar.Identifier("MainToolbar")
    
    func setupToolbar() {
        let toolbar = NSToolbar(identifier: toolbarIdentifier)
        toolbar.delegate = self
        toolbar.displayMode = .iconAndLabel
        toolbar.allowsUserCustomization = true
        toolbar.autosavesConfiguration = true
        window?.toolbar = toolbar
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .toggleSidebar, .newDocument]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .space, .toggleSidebar, .newDocument, .openDocument]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.label = "新建"
        item.paletteLabel = "新建文档"
        item.toolTip = "创建新文档"
        item.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil)
        item.target = self
        item.action = #selector(newDocument(_:))
        return item
    }
    
    @objc func newDocument(_ sender: Any?) {
        // 创建新文档
    }
}
```

---

## 常见问题

### 窗口不显示

```swift
window?.makeKeyAndOrderFront(nil)
NSApp.activate(ignoringOtherApps: true)
```

### 窗口置顶

```swift
window?.level = .floating
```

---

*最后更新：2026-03-05*
