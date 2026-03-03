# 列表与导航

> 📑 UITableView、UICollectionView 与导航控制器

---

## UITableView 表格视图

### 基础用法

```swift
class MyViewController: UIViewController {
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let items = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, 
                          forCellReuseIdentifier: "Cell")
    }
}

extension MyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 组数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 行数
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // 单元格
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", 
                                                for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // 点击事件
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("选中：\(items[indexPath.row])")
    }
}
```

### 自定义单元格

```swift
class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let iconImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            subtitleLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor, constant: 12),
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(
                equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        iconImageView.image = UIImage(systemName: "star")
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

// 使用
tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)

func tableView(_ tableView: UITableView, 
               cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, 
                                            for: indexPath) as! CustomCell
    cell.configure(title: "标题", subtitle: "副标题")
    return cell
}
```

### 分组与索引

```swift
// 多组数据
func numberOfSections(in tableView: UITableView) -> Int {
    return 3
}

func tableView(_ tableView: UITableView, 
               numberOfRowsInSection section: Int) -> Int {
    return sectionData[section].count
}

// 组标题
func tableView(_ tableView: UITableView, 
               titleForHeaderInSection section: Int) -> String? {
    return "分组 \(section + 1)"
}

// 索引标题
func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return ["A", "B", "C", "D"]
}

func tableView(_ tableView: UITableView, 
               sectionForSectionIndexTitle title: String, 
               atIndex index: Int) -> Int {
    return index
}
```

### 编辑模式

```swift
// 开启编辑
tableView.isEditing = true

// 删除
func tableView(_ tableView: UITableView, 
               commit editingStyle: UITableViewCell.EditingStyle, 
               forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// 移动
func tableView(_ tableView: UITableView, 
               canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
}

func tableView(_ tableView: UITableView, 
               moveRowAt sourceIndexPath: IndexPath, 
               to destinationIndexPath: IndexPath) {
    let item = items.remove(at: sourceIndexPath.row)
    items.insert(item, at: destinationIndexPath.row)
}
```

### 高度设置

```swift
// 自动高度（推荐）
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 60

// 固定高度
func tableView(_ tableView: UITableView, 
               heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
}

// 动态高度
func tableView(_ tableView: UITableView, 
               heightForRowAt indexPath: IndexPath) -> CGFloat {
    let text = items[indexPath.row]
    // 根据内容计算高度
    return 44 + CGFloat(text.count) * 2
}
```

---

## UICollectionView 集合视图

### 基础用法

```swift
class MyViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let items = Array(1...20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell"
        )
    }
}

extension MyViewController: UICollectionViewDataSource, 
                            UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, 
                       numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell", 
            for: indexPath
        )
        cell.contentView.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                       didSelectItemAt indexPath: IndexPath) {
        print("选中：\(items[indexPath.item])")
    }
}
```

### 自定义单元格

```swift
class GridCell: UICollectionViewCell {
    
    static let identifier = "GridCell"
    
    let imageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
    }
    
    func configure(image: UIImage?, title: String) {
        imageView.image = image
        label.text = title
    }
}

// 使用
collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.identifier)

func collectionView(_ collectionView: UICollectionView, 
                   cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GridCell.identifier, 
        for: indexPath
    ) as! GridCell
    cell.configure(image: UIImage(systemName: "star"), title: "Item \(indexPath.item)")
    return cell
}
```

### 布局配置

```swift
// Flow Layout
let layout = UICollectionViewFlowLayout()
layout.scrollDirection = .vertical // 或 .horizontal
layout.itemSize = CGSize(width: 100, height: 100)
layout.minimumInteritemSpacing = 10
layout.minimumLineSpacing = 10
layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

// 动态调整大小
func collectionView(_ collectionView: UICollectionView, 
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
}

// Compositional Layout (iOS 13+)
func createCompositionalLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(100)
    )
    let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}
```

---

## UINavigationController 导航控制器

### 基础用法

```swift
// 创建导航控制器
let rootVC = RootViewController()
let navigationController = UINavigationController(rootViewController: rootVC)

// 设置到 window
window?.rootViewController = navigationController

// 推入新控制器
let detailVC = DetailViewController()
navigationController.pushViewController(detailVC, animated: true)

// 弹出
navigationController.popViewController(animated: true)

// 弹到根
navigationController.popToRootViewController(animated: true)

// 弹到指定
navigationController.popToViewController(targetVC, animated: true)
```

### 导航栏配置

```swift
// 隐藏导航栏
navigationController?.setNavigationBarHidden(true, animated: true)

// 设置标题
navigationItem.title = "标题"

// 返回按钮
navigationItem.backBarButtonItem = UIBarButtonItem(
    title: "返回",
    style: .plain,
    target: nil,
    action: nil
)

// 隐藏返回按钮
navigationItem.hidesBackButton = true

// 左侧按钮
navigationItem.leftBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: self,
    action: #selector(cancelTapped)
)

// 右侧按钮
navigationItem.rightBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: .save,
    target: self,
    action: #selector(saveTapped)
)

// 多个按钮
navigationItem.rightBarButtonItems = [
    UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)),
    UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
]
```

### 自定义导航栏

```swift
// 背景色
navigationController?.navigationBar.barTintColor = .systemBlue

// 标题颜色
navigationController?.navigationBar.titleTextAttributes = [
    .foregroundColor: UIColor.white
]

// 大标题
navigationController?.navigationBar.prefersLargeTitles = true
navigationItem.largeTitleDisplayMode = .automatic // 或 .always, .never

// 毛玻璃效果
navigationController?.navigationBar.isTranslucent = true

// 底部线条
navigationController?.navigationBar.shadowImage = UIImage()
```

---

## UITabBarController 标签栏

### 基础用法

```swift
// 创建子控制器
let vc1 = FirstViewController()
vc1.tabBarItem = UITabBarItem(
    title: "首页",
    image: UIImage(systemName: "house"),
    selectedImage: UIImage(systemName: "house.fill")
)

let vc2 = SecondViewController()
vc2.tabBarItem = UITabBarItem(
    title: "搜索",
    image: UIImage(systemName: "magnifyingglass"),
    selectedImage: UIImage(systemName: "magnifyingglass.fill")
)

let vc3 = ThirdViewController()
vc3.tabBarItem = UITabBarItem(
    title: "我的",
    image: UIImage(systemName: "person"),
    selectedImage: UIImage(systemName: "person.fill")
)

// 创建标签栏控制器
let tabBarController = UITabBarController()
tabBarController.viewControllers = [vc1, vc2, vc3]

// 设置到 window
window?.rootViewController = tabBarController
```

### 自定义样式

```swift
// 背景色
tabBarController.tabBar.barTintColor = .white

// 选中颜色
tabBarController.tabBar.tintColor = .systemBlue

// 背景图片
tabBarController.tabBar.backgroundImage = UIImage()
tabBarController.tabBar.shadowImage = UIImage()

// 隐藏顶部线条
tabBarController.tabBar.shadowImage = UIImage()

// 添加高斯模糊
let blurEffect = UIBlurEffect(style: .light)
let blurView = UIVisualEffectView(effect: blurEffect)
blurView.frame = tabBarController.tabBar.bounds
blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
tabBarController.tabBar.insertSubview(blurView, at: 0)
```

### 代理方法

```swift
extension MyAppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, 
                         shouldSelect viewController: UIViewController) -> Bool {
        // 是否可以切换
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, 
                         didSelect viewController: UIViewController) {
        // 已经切换
        print("切换到：\(viewController)")
    }
}
```

---

*最后更新：2026-03-03*
