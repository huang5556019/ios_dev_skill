# NSViewController 视图控制器

> 🎛️ macOS 视图控制器完全指南 (Swift 版)

---

## 基础用法

### 创建视图控制器

```swift
class ContentViewController: NSViewController {
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        
        let label = NSTextField(labelWithString: "Hello macOS")
        label.font = NSFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
```

### 生命周期

```swift
override func loadView() {
    // 加载视图
}

override func viewDidLoad() {
    super.viewDidLoad()
    // 视图加载完成
}

override func viewWillAppear() {
    super.viewWillAppear()
    // 视图即将显示
}

override func viewDidAppear() {
    super.viewDidAppear()
    // 视图已显示
}

override func viewWillDisappear() {
    super.viewWillDisappear()
    // 视图即将消失
}

override func viewDidDisappear() {
    super.viewDidDisappear()
    // 视图已消失
}
```

---

## 视图控制器容器

### 添加子视图控制器

```swift
let childVC = ChildViewController()
addChild(childVC)
view.addSubview(childVC.view)
childVC.view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    childVC.view.topAnchor.constraint(equalTo: view.topAnchor),
    childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])
```

### 移除子视图控制器

```swift
childVC.removeFromParent()
childVC.view.removeFromSuperview()
```

### NSSplitViewController

```swift
class SplitViewController: NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftVC = LeftViewController()
        let rightVC = RightViewController()
        
        let leftItem = NSSplitViewItem(sidebarWithViewController: leftVC)
        let rightItem = NSSplitViewItem(viewController: rightVC)
        
        addSplitViewItem(leftItem)
        addSplitViewItem(rightItem)
    }
}
```

### NSTabViewController

```swift
class TabViewController: NSTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabStyle = .toolbar
        
        let tab1 = NSTabViewItem(viewController: FirstViewController())
        tab1.label = "首页"
        
        let tab2 = NSTabViewItem(viewController: SecondViewController())
        tab2.label = "设置"
        
        addTabViewItem(tab1)
        addTabViewItem(tab2)
    }
}
```

---

## 视图控制器协作

### 传递数据

```swift
// 通过初始化方法传递
class DetailViewController: NSViewController {
    let item: String
    
    init(item: String) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 使用
let detailVC = DetailViewController(item: "Data")
```

### 回调

```swift
protocol ContentViewControllerDelegate: AnyObject {
    func contentViewControllerDidFinish(_ controller: ContentViewController)
}

class ContentViewController: NSViewController {
    weak var delegate: ContentViewControllerDelegate?
    
    @IBAction func finish(_ sender: Any?) {
        delegate?.contentViewControllerDidFinish(self)
    }
}
```

---

## 常见问题

### 视图不显示

```swift
// 确保视图已添加到窗口
window?.contentViewController = contentVC
```

---

*最后更新：2026-03-05*
