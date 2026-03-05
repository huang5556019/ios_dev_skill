# 常用控件

> 🎛️ AppKit 核心控件使用指南 (Swift 版)

---

## NSButton 按钮

### 基础用法

```swift
let button = NSButton(title: "点击我", target: self, action: #selector(buttonTapped))
button.bezelStyle = .rounded

@objc func buttonTapped() {
    print("按钮被点击")
}
```

### 按钮样式

```swift
button.bezelStyle = .rounded
button.bezelStyle = .inline
button.bezelStyle = .texturedRounded
button.bezelStyle = .square
button.bezelStyle = .disclosure
button.bezelStyle = .shadowlessSquare
button.isBordered = false
```

### 图标按钮

```swift
let iconButton = NSButton(image: NSImage(systemSymbolName: "star", accessibilityDescription: nil)!, 
                          target: self, 
                          action: #selector(iconTapped))
iconButton.bezelStyle = .texturedRounded
```

---

## NSTextField 文本字段

### 基础用法

```swift
let textField = NSTextField()
textField.placeholderString = "请输入..."
textField.stringValue = "默认值"
textField.isEditable = true
textField.isSelectable = true
```

### 标签

```swift
let label = NSTextField(labelWithString: "标签文本")
label.font = NSFont.systemFont(ofSize: 14)
label.textColor = .labelColor
label.alignment = .center
```

### 密码字段

```swift
let passwordField = NSSecureTextField()
passwordField.placeholderString = "请输入密码"
```

---

## NSTextView 文本视图

### 基础用法

```swift
let scrollView = NSScrollView()
let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 200))

textView.isEditable = true
textView.isSelectable = true
textView.font = NSFont.systemFont(ofSize: 14)
textView.textColor = .textColor

scrollView.documentView = textView
scrollView.hasVerticalScroller = true
```

### 代理方法

```swift
extension ViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        let textView = notification.object as! NSTextView
        print("文本变化：\(textView.string)")
    }
}
```

---

## NSImageView 图片视图

### 基础用法

```swift
let imageView = NSImageView()
imageView.image = NSImage(named: "example")
imageView.imageScaling = .scaleProportionallyUpOrDown
```

### 图片缩放

```swift
imageView.imageScaling = .scaleNone
imageView.imageScaling = .scaleProportionallyUpOrDown
imageView.imageScaling = .scaleProportionallyDown
imageView.imageScaling = .scaleToFit
imageView.imageScaling = .scaleToFill
```

---

## NSSlider 滑块

### 基础用法

```swift
let slider = NSSlider(value: 50, minValue: 0, maxValue: 100, target: self, action: #selector(sliderChanged(_:)))
slider.numberOfTickMarks = 5
slider.allowsTickMarkValuesOnly = false

@objc func sliderChanged(_ sender: NSSlider) {
    print("当前值：\(sender.doubleValue)")
}
```

---

## NSPopUpButton 下拉菜单

### 基础用法

```swift
let popup = NSPopUpButton()
popup.addItems(withTitles: ["选项 1", "选项 2", "选项 3"])
popup.selectItem(at: 0)
popup.target = self
popup.action = #selector(popupChanged(_:))

@objc func popupChanged(_ sender: NSPopUpButton) {
    print("选中：\(sender.titleOfSelectedItem ?? "")")
}
```

---

## NSProgressIndicator 进度条

### 基础用法

```swift
// 不确定进度
let indeterminateProgress = NSProgressIndicator()
indeterminateProgress.style = .spinning
indeterminateProgress.startAnimation(nil)

// 确定进度
let determinateProgress = NSProgressIndicator()
determinateProgress.style = .bar
determinateProgress.minValue = 0
determinateProgress.maxValue = 100
determinateProgress.doubleValue = 50
```

---

## NS Segmented Control 分段控制

```swift
let segmented = NSSegmentedControl(labels: ["左", "中", "右"], trackingMode: .selectOne, target: self, action: #selector(segmentChanged(_:)))
segmented.selectedSegment = 0

@objc func segmentChanged(_ sender: NSSegmentedControl) {
    print("选中索引：\(sender.selectedSegment)")
}
```

---

## NSOutlineView 大纲视图

### 基础用法

```swift
class OutlineViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    let outlineView = NSOutlineView()
    let data = ["A", "B", "C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Column"))
        column.title = "标题"
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column
        
        outlineView.dataSource = self
        outlineView.delegate = self
        
        let scrollView = NSScrollView()
        scrollView.documentView = outlineView
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return item == nil ? data.count : 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return data[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell = NSTextField(labelWithString: item as! String)
        return cell
    }
}
```

---

*最后更新：2026-03-05*
