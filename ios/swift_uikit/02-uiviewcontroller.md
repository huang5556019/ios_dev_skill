# UIViewController 视图控制器

> 🎮 iOS 应用的核心控制器

---

## 📌 核心概念

UIViewController 负责管理一组视图，是 iOS 应用中界面组织的核心单元。它处理：
- 视图的加载和卸载
- 生命周期管理
- 用户交互响应
- 数据传递和协调

---

## 🔄 生命周期

### 完整生命周期流程

```swift
class MyViewController: UIViewController {
    
    // MARK: - 初始化
    init() {
        super.init(nibName: nil, bundle: nil)
        // 最早初始化入口，适合设置默认值
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Storyboard/XIB 加载时使用
    }
    
    // MARK: - 视图加载
    override func loadView() {
        // 自定义创建视图（不使用 Storyboard/XIB 时）
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 视图已加载，进行 UI 配置和数据初始化
        setupUI()
        setupConstraints()
        setupData()
    }
    
    // MARK: - 视图即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 视图即将显示，刷新数据、更新 UI
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 视图已显示，启动动画、埋点
        startAnalytics()
    }
    
    // MARK: - 视图即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 视图即将消失，保存数据
        saveData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 视图已消失，清理资源
        cleanup()
    }
    
    // MARK: - 内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放可重新创建的资源
    }
    
    // MARK: - 析构
    deinit {
        print("\(type(of: self)) dealloc")
        // 清理观察者、通知等
        NotificationCenter.default.removeObserver(self)
    }
}
```

### 生命周期顺序

```
初始化 → loadView → viewDidLoad → viewWillAppear → viewDidAppear
                                      ↓
                            viewWillDisappear → viewDidDisappear
```

---

## 🏗️ 视图加载

### 编程式创建视图

```swift
class ProgrammaticViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
```

### 使用 UIStackView

```swift
class StackViewViewController: UIViewController {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        
        // 添加子视图
        stackView.addArrangedSubview(createLabel(text: "Title"))
        stackView.addArrangedSubview(createButton(title: "Action"))
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }
}
```

---

## 👶 子视图控制器

### 添加子控制器

```swift
class ContainerViewController: UIViewController {
    
    let childVC = ChildViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
    }
    
    private func addChildViewController() {
        // 1. 添加子控制器
        addChild(childVC)
        
        // 2. 添加子控制器的视图
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childVC.view)
        
        // 3. 设置约束
        NSLayoutConstraint.activate([
            childVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            childVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 4. 通知子控制器添加完成
        childVC.didMove(toParent: self)
    }
    
    // 移除子控制器
    private func removeChildViewController() {
        // 1. 通知子控制器即将移除
        childVC.willMove(toParent: nil)
        
        // 2. 从父视图移除
        childVC.view.removeFromSuperview()
        
        // 3. 从父控制器移除
        childVC.removeFromParent()
    }
}
```

---

## 🎭 模态呈现

### 基础模态

```swift
// 呈现控制器
let modalVC = ModalViewController()
modalVC.modalPresentationStyle = .fullScreen  // 或 .pageSheet, .formSheet, .overFullScreen
present(modalVC, animated: true)

// 关闭模态
@objc func dismissModal() {
    dismiss(animated: true)
}
```

### 传递数据

```swift
// 定义协议
protocol ModalDelegate: AnyObject {
    func modalViewController(_ vc: ModalViewController, didCompleteWith data: String)
}

// 模态控制器
class ModalViewController: UIViewController {
    weak var delegate: ModalDelegate?
    private var data: String = ""
    
    @objc func done() {
        delegate?.modalViewController(self, didCompleteWith: data)
        dismiss(animated: true)
    }
}

//  presenting 控制器
class PresentingViewController: UIViewController, ModalDelegate {
    
    func showModal() {
        let modalVC = ModalViewController()
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .pageSheet
        present(modalVC, animated: true)
    }
    
    func modalViewController(_ vc: ModalViewController, didCompleteWith data: String) {
        print("收到数据：\(data)")
    }
}
```

### 使用 Closure 回调

```swift
class ModalViewController: UIViewController {
    
    var onDismiss: ((String) -> Void)?
    
    @objc func done() {
        onDismiss?("返回的数据")
        dismiss(animated: true)
    }
}

// 使用
let modalVC = ModalViewController()
modalVC.onDismiss = { data in
    print("收到：\(data)")
}
present(modalVC, animated: true)
```

---

## 🧭 导航控制器

### 基础导航

```swift
// 创建导航控制器
let vc = DetailViewController()
let navVC = UINavigationController(rootViewController: vc)
present(navVC, animated: true)

// 推入新控制器
navigationController?.pushViewController(vc, animated: true)

// 弹出控制器
navigationController?.popViewController(animated: true)

// 弹出到指定控制器
navigationController?.popToViewController(targetVC, animated: true)

// 弹出到根控制器
navigationController?.popToRootViewController(animated: true)
```

### 自定义导航栏

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // 标题
    title = "页面标题"
    navigationItem.title = "自定义标题"
    
    // 返回按钮
    navigationItem.backBarButtonItem = UIBarButtonItem(
        title: "返回",
        style: .plain,
        target: nil,
        action: nil
    )
    
    // 左侧按钮
    navigationItem.leftBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(cancelTapped)
    )
    
    // 右侧按钮
    navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "完成",
        style: .done,
        target: self,
        action: #selector(doneTapped)
    )
    
    // 多个按钮
    navigationItem.rightBarButtonItems = [
        UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)),
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    ]
}
```

### 自定义导航栏样式

```swift
// 在 AppDelegate 或 SceneDelegate 中全局设置
let appearance = UINavigationBarAppearance()
appearance.configureWithOpaqueBackground()
appearance.backgroundColor = .systemBackground
appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

UINavigationBar.appearance().standardAppearance = appearance
UINavigationBar.appearance().scrollEdgeAppearance = appearance
```

---

## 📱 适配尺寸类

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    updateForCurrentTraitCollection()
}

override func willTransition(to newCollection: UITraitCollection, 
                           with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
        self.updateForCurrentTraitCollection()
    })
}

private func updateForCurrentTraitCollection() {
    switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
    case (.regular, .regular):
        // iPad
        setupForiPad()
    case (.compact, .regular):
        // iPhone 竖屏
        setupForiPhonePortrait()
    case (.compact, .compact):
        // iPhone 横屏
        setupForiPhoneLandscape()
    default:
        break
    }
}
```

---

## ✅ 最佳实践

### ✅ 推荐做法

```swift
// 1. 使用 lazy 属性延迟加载视图
private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

// 2. 将设置逻辑拆分到独立方法
override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    setupData()
}

// 3. 使用 weak 避免循环引用
weak var delegate: SomeDelegate?

// 4. 及时移除观察者
deinit {
    NotificationCenter.default.removeObserver(self)
}
```

### ❌ 避免做法

```swift
// 1. 不要在 viewDidLoad 之外初始化 UI
// ❌
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // 不应该在这里创建 UI
}

// 2. 不要忘记调用 super
// ❌
override func viewDidLoad() {
    // 忘记调用 super.viewDidLoad()
}

// 3. 不要强引用导致循环
// ❌
var onComplete: () -> Void = { [self] in  // 应该用 [weak self]
    self.doSomething()
}
```

---

*最后更新：2026-03-04*
