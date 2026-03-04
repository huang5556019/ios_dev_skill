# iOS UIKit 开发助手 Skill (Swift 版)

> 🛠️ 专业的 iOS UIKit 开发支持与代码生成（Swift 版）

---

## Skill 描述

本 Skill 提供完整的 iOS UIKit 开发支持，包括：
- 代码生成与示例（Swift）
- 最佳实践建议
- 问题排查与调试
- 架构设计指导

---

## 能力范围

### ✅ 可以协助的内容

1. **UI 组件使用**
   - UIView、UIViewController 生命周期
   - 常用控件（UIButton、UILabel、UITextField 等）
   - 列表组件（UITableView、UICollectionView）
   - 导航组件（UINavigationController、UITabBarController）

2. **布局系统**
   - Auto Layout 约束编写
   - UIStackView 堆栈布局
   - Safe Area 安全区域适配
   - 多屏幕适配方案

3. **交互与动画**
   - 手势识别（UIGestureRecognizer）
   - 触摸事件处理（UIResponder）
   - UIView 动画
   - 视图控制器转场

4. **架构模式**
   - MVC 架构实现
   - 自定义控件封装
   - 组件化设计
   - 代码组织与重构

5. **性能优化**
   - 列表性能优化
   - 内存管理
   - 渲染优化
   - 启动优化

### ❌ 不支持的内容

- SwiftUI 开发（专注 UIKit）
- Objective-C 语言支持（仅 Swift）
- 后端服务开发
- 第三方库的具体使用（可提供通用建议）
- App Store 上架流程

---

## 使用方式

### 1. 代码生成

**用户提问：**
```
帮我写一个自定义的圆角按钮，带阴影效果
```

**助手响应：**
```swift
class RoundedShadowButton: UIButton {
    
    var buttonColor: UIColor = .systemBlue {
        didSet { backgroundColor = buttonColor }
    }
    
    init(title: String, color: UIColor = .systemBlue) {
        super.init(frame: .zero)
        setupButton(title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = color
        
        // 圆角
        layer.cornerRadius = 10
        clipsToBounds = true
        
        // 阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // 点击反馈
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
}

// 使用
let button = RoundedShadowButton(title: "点击我", color: .systemBlue)
view.addSubview(button)
```

---

### 2. 问题排查

**用户提问：**
```
我的 TableView 不显示数据，可能是什么原因？
```

**助手响应：**
```
请检查以下几点：

1. ✅ 数据源是否设置
   tableView.dataSource = self

2. ✅ 是否注册了 Cell
   tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

3. ✅ 是否实现了数据源方法
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count  // 确保返回正确的数量
   }

4. ✅ cellForRowAt 是否正确
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       cell.textLabel?.text = items[indexPath.row]
       return cell
   }

5. ✅ 数据是否为空
   print(items.count)  // 检查数据源数组

6. ✅ 约束是否正确
   // 确保 tableView 有正确的大小和位置
```

---

### 3. 最佳实践

**用户提问：**
```
如何优雅地处理 ViewController 的生命周期？
```

**助手响应：**
```swift
class MyViewController: UIViewController {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private var data: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 刷新数据、更新 UI
        refreshData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 启动动画、埋点
        startAnalytics()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 保存数据
        saveData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 清理资源
        cleanup()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        // 配置 UI 组件
    }
    
    private func setupConstraints() {
        // Auto Layout 约束
    }
    
    private func setupData() {
        // 初始化数据
        data = []
    }
    
    // MARK: - Memory Management
    deinit {
        print("\(type(of: self)) dealloc")
        // 清理观察者、通知等
        NotificationCenter.default.removeObserver(self)
    }
}
```

---

## 代码规范

### 命名规范

```swift
// 类名：大驼峰
class MyViewController: UIViewController {}

// 属性/变量：小驼峰
var titleLabel: UILabel!

// 方法：小驼峰，动词开头
func fetchData() {}

// 常量：小驼峰
let maxItemCount = 100

// 枚举：首字母大写
enum LoadingState {
    case idle
    case loading
    case success
    case failure
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
func fetchUser(with userID: String) -> User? {
    // 实现
}
```

### 文件组织

```swift
// 1. Imports
import UIKit

// 2. Class Definition
class MyViewController: UIViewController {
    
    // MARK: - Properties
    // 属性声明
    
    // MARK: - Initialization
    // 初始化方法
    
    // MARK: - Lifecycle
    // 生命周期方法
    
    // MARK: - Public Methods
    // 公开方法
    
    // MARK: - Private Methods
    // 私有方法
    
    // MARK: - UITableViewDataSource
    // 代理扩展
}

// 3. Extensions
extension MyViewController: UITableViewDataSource {
    // 代理方法
}
```

---

## 常用代码片段

### 快速创建约束

```swift
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 16),
    view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
    view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
    view.heightAnchor.constraint(equalToConstant: 50)
])
```

### 快速创建 Cell

```swift
class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(text: String) {
        label.text = text
    }
}

// 注册和使用
tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
cell.configure(text: "Hello")
```

### 快速网络请求

```swift
func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: "https://api.example.com/data") else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        completion(.success(data))
    }.resume()
}
```

---

## 资源链接

- [官方文档](https://developer.apple.com/documentation/uikit)
- [UIView](./01-uiview.md)
- [UIViewController](./02-uiviewcontroller.md)

---

## 版本信息

- **Skill 版本：** 1.0.0 (Swift)
- **支持 iOS：** 12.0+
- **语言：** Swift 5+
- **最后更新：** 2026-03-04

---

*本 Skill 基于 Apple 官方文档整理，结合实战经验编写*
