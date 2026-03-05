# 高级主题

> 🚀 进阶技能与最佳实践 (Swift 版)

---

## 性能优化

### 列表性能优化

```swift
// 1. 估算高度
tableView.estimatedRowHeight = 60
tableView.rowHeight = UITableView.automaticDimension

// 2. 预渲染图片
imageView.image = UIImage(named: "cached")

// 3. 复用单元格
tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)

// 4. 减少重绘
cell.layer.shouldRasterize = true
cell.layer.rasterizationScale = UIScreen.main.scale
```

### 内存管理

```swift
// 1. 避免循环引用
weak var weakSelf = self

// 2. 及时释放
deinit {
    NotificationCenter.default.removeObserver(self)
}

// 3. 图片缓存
let cache = NSCache<NSString, UIImage>()
cache.setObject(image, forKey: "imageKey")
```

### 启动优化

```swift
// 1. 懒加载
lazy var heavyView: HeavyView = {
    return HeavyView()
}()

// 2. 后台加载
DispatchQueue.global(qos: .userInitiated).async {
    let data = self.loadData()
    DispatchQueue.main.async {
        self.updateUI(with: data)
    }
}
```

---

## 架构模式

### MVC 模式

```swift
class UserViewController: UIViewController {
    
    private var users: [User] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUsers()
    }
    
    private func setupUI() {
        // 设置视图
    }
    
    private func fetchUsers() {
        // 获取数据
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
```

### MVVM 模式

```swift
class UserListViewModel {
    
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchUsers() {
        isLoading = true
        // API call
    }
}

class UserListViewController: UIViewController {
    
    let viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
```

---

## 数据持久化

### UserDefaults

```swift
// 保存
UserDefaults.standard.set("value", forKey: "key")
UserDefaults.standard.set(42, forKey: "number")
UserDefaults.standard.set(true, forKey: "flag")

// 读取
let value = UserDefaults.standard.string(forKey: "key")
let number = UserDefaults.standard.integer(forKey: "number")
let flag = UserDefaults.standard.bool(forKey: "flag")

// 删除
UserDefaults.standard.removeObject(forKey: "key")
```

### 文件存储

```swift
let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let fileURL = documentsPath.appendingPathComponent("file.txt")

// 写入
try? "Hello".write(to: fileURL, atomically: true, encoding: .utf8)

// 读取
let content = try? String(contentsOf: fileURL, encoding: .utf8)
```

### Codable

```swift
struct User: Codable {
    let id: Int
    let name: String
}

let user = User(id: 1, name: "Tom")

// 编码
let data = try? JSONEncoder().encode(user)

// 解码
let decoded = try? JSONDecoder().decode(User.self, from: data)
```

---

## 网络请求

### URLSession

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

### JSON 解析

```swift
struct Response: Decodable {
    let data: [Item]
}

struct Item: Decodable {
    let id: Int
    let title: String
}

URLSession.shared.dataTask(with: url) { data, _, _ in
    let items = try? JSONDecoder().decode(Response.self, from: data!)
}.resume()
```

---

## 调试技巧

### 断点调试

```swift
// 条件断点
// 在 Xcode 中设置条件：row == 0

// Swift Print
print("Debug: \(variable)")

// Assert
assert(x > 0, "x 必须大于 0")
```

### Crash 处理

```swift
// 捕获异常
func catchException() {
    try? {
        // 可能崩溃的代码
    }
}

// 收集 Crash 日志
// 使用 Firebase Crashlytics 或其他服务
```

---

*最后更新：2026-03-05*
