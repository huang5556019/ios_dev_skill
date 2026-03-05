# 列表与导航

> 📑 NSTableView、NSOutlineView 与导航 (Swift 版)

---

## NSTableView 表格视图

### 基础用法

```swift
class TableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    let tableView = NSTableView()
    let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Cell"))
        column.title = "标题"
        column.width = 200
        tableView.addTableColumn(column)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("Cell")
        var cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTextField
        
        if cell == nil {
            cell = NSTextField()
            cell?.identifier = identifier
        }
        
        cell?.stringValue = items[row]
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        print("选中：\(items[row])")
        return true
    }
}
```

### 自定义单元格

```swift
class CustomTableCellView: NSTableCellView {
    
    let iconImageView = NSImageView()
    let titleLabel = NSTextField()
    let subtitleLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        ])
    }
    
    func configure(title: String, subtitle: String, iconName: String) {
        titleLabel.stringValue = title
        subtitleLabel.stringValue = subtitle
        iconImageView.image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)
    }
}
```

---

## NSOutlineView 大纲视图

### 基础用法

```swift
class OutlineViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    let outlineView = NSOutlineView()
    
    struct Node {
        let name: String
        let children: [Node]?
    }
    
    let data: [Node] = [
        Node(name: "A", children: [Node(name: "A1", children: nil), Node(name: "A2", children: nil)]),
        Node(name: "B", children: nil),
        Node(name: "C", children: [Node(name: "C1", children: nil)])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Column"))
        column.title = "目录"
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column
        
        outlineView.dataSource = self
        outlineView.delegate = self
        
        let scrollView = NSScrollView()
        scrollView.documentView = outlineView
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return data.count
        }
        if let node = item as? Node {
            return node.children?.count ?? 0
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return data[index]
        }
        if let node = item as? Node, let children = node.children {
            return children[index]
        }
        return NSNull()
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let node = item as? Node {
            return node.children != nil
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let node = item as? Node {
            let cell = NSTextField(labelWithString: node.name)
            return cell
        }
        return nil
    }
}
```

---

## NSTabView 标签视图

```swift
let tabView = NSTabView()

let tab1 = NSTabViewItem(identifier: "tab1")
tab1.label = "首页"
tab1.view = createTabView(1)

let tab2 = NSTabViewItem(identifier: "tab2")
tab2.label = "设置"
tab2.view = createTabView(2)

tabView.addTabViewItem(tab1)
tabView.addTabViewItem(tab2)

func createTabView(_ index: Int) -> NSView {
    let view = NSView()
    let label = NSTextField(labelWithString: "Tab \(index)")
    view.addSubview(label)
    return view
}
```

---

## NSMenu 菜单

### 创建菜单

```swift
let mainMenu = NSMenu()

// 应用菜单
let appMenuItem = NSMenuItem()
let appMenu = NSMenu()
appMenu.addItem(withTitle: "关于", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
appMenu.addItem(NSMenuItem.separator())
appMenu.addItem(withTitle: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
appMenuItem.submenu = appMenu
mainMenu.addItem(appMenuItem)

// 文件菜单
let fileMenuItem = NSMenuItem()
let fileMenu = NSMenu(title: "文件")
fileMenu.addItem(withTitle: "新建", action: #selector(newDocument(_:)), keyEquivalent: "n")
fileMenu.addItem(withTitle: "打开", action: #selector(openDocument(_:)), keyEquivalent: "o")
fileMenuItem.submenu = fileMenu
mainMenu.addItem(fileMenuItem)

NSApp.mainMenu = mainMenu
```

### 上下文菜单

```swift
let menu = NSMenu()
menu.addItem(withTitle: "复制", action: #selector(copy(_:)), keyEquivalent: "c")
menu.addItem(withTitle: "粘贴", action: #selector(paste(_:)), keyEquivalent: "v")

view.menu = menu
```

---

*最后更新：2026-03-05*
