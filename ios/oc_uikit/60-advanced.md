# 高级主题

> 🎓 自定义控件、性能优化与多屏幕适配

---

## 自定义控件

### 创建自定义控件

```swift
class CustomCardView: UIView {
    
    // MARK: - Properties
    
    var title: String = "" {
        didSet { titleLabel.text = title }
    }
    
    var cardColor: UIColor = .white {
        didSet { backgroundColor = cardColor }
    }
    
    var onTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    // MARK: - Configuration
    
    func configure(icon: UIImage?, title: String, subtitle: String) {
        iconImageView.image = icon
        self.title = title
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 更新阴影路径以提高性能
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, 
                                                       cornerRadius: 12).cgPath
    }
}

// 使用示例
let card = CustomCardView()
card.configure(icon: UIImage(systemName: "star"),
               title: "标题",
               subtitle: "这是副标题描述")
card.onTap = {
    print("卡片被点击")
}
view.addSubview(card)
```

### 使用 IBDesignables

```swift
@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var startColor: UIColor = .systemBlue
    @IBInspectable var endColor: UIColor = .systemPurple
    @IBInspectable var cornerRadiusValue: CGFloat = 8
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = cornerRadiusValue
        layer.insertSublayer(gradientLayer, at: 0)
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadiusValue
    }
}
```

---

## 性能优化

### TableView 性能优化

```swift
class OptimizedTableViewController: UITableViewController {
    
    // 1. 使用 deque 重用机制
    override func tableView(_ tableView: UITableView, 
                           cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 配置 cell
        return cell
    }
    
    // 2. 预计算行高
    private var rowHeights: [Int: CGFloat] = [:]
    
    func calculateRowHeight(for indexPath: IndexPath) -> CGFloat {
        if let height = rowHeights[indexPath.row] {
            return height
        }
        
        // 计算高度
        let height = calculateHeight(for: items[indexPath.row])
        rowHeights[indexPath.row] = height
        return height
    }
    
    // 3. 异步图片加载
    func loadImage(for imageView: UIImageView, at indexPath: IndexPath) {
        // 取消之前的请求
        imageView.image = nil
        
        // 异步加载
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let image = self.loadImageFromDisk(at: indexPath)
            
            DispatchQueue.main.async {
                // 检查 cell 是否还在显示
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    cell.imageView?.image = image
                }
            }
        }
    }
    
    // 4. 减少 subview 数量
    class OptimizedCell: UITableViewCell {
        private let contentStackView = UIStackView()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupOptimizedLayout()
        }
        
        private func setupOptimizedLayout() {
            // 使用 stackview 减少约束数量
            contentView.addSubview(contentStackView)
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
        }
    }
}
```

### 内存优化

```swift
class MemoryOptimizedViewController: UIViewController {
    
    // 1. 使用 weak 避免循环引用
    weak var delegate: DataDelegate?
    
    // 2. 延迟加载大对象
    lazy var largeImage: UIImage? = {
        return UIImage(named: "large_image")
    }()
    
    // 3. 及时释放资源
    deinit {
        // 移除通知观察者
        NotificationCenter.default.removeObserver(self)
        
        // 取消网络请求
        URLSession.shared.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        
        // 释放缓存
        imageCache.removeAll()
    }
    
    // 4. 使用缓存
    private let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(with key: String) -> UIImage? {
        if let cached = imageCache.object(forKey: key as NSString) {
            return cached
        }
        
        guard let image = UIImage(named: key) else { return nil }
        imageCache.setObject(image, forKey: key as NSString)
        return image
    }
    
    // 5. 内存警告处理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        imageCache.removeAllObjects()
        largeImage = nil
    }
}
```

### 渲染优化

```swift
class RenderOptimizedView: UIView {
    
    // 1. 使用 shouldRasterize 缓存复杂视图
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        } else {
            layer.shouldRasterize = false
        }
    }
    
    // 2. 优化阴影性能
    func setupOptimizedShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        // 关键：设置 shadowPath
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    // 3. 避免离屏渲染
    override func draw(_ rect: CGRect) {
        // 使用 Core Graphics 直接绘制
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
    }
    
    // 4. 批量更新
    func updateMultipleProperties() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // 批量更新属性
        layer.opacity = 0.5
        layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
        
        CATransaction.commit()
    }
}
```

---

## 多屏幕适配

### Safe Area 适配

```swift
class SafeAreaAdaptiveView: UIView {
    
    private let contentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWithSafeArea()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWithSafeArea() {
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 使用 safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // 监听 Safe Area 变化
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        print("Safe Area 变化：\(safeAreaInsets)")
    }
}
```

### 尺寸类适配

```swift
class AdaptiveViewController: UIViewController {
    
    private var horizontalSizeClass: UIUserInterfaceSizeClass = .unspecified
    private var verticalSizeClass: UIUserInterfaceSizeClass = .unspecified
    
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
        horizontalSizeClass = traitCollection.horizontalSizeClass
        verticalSizeClass = traitCollection.verticalSizeClass
        
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            // iPad 或 iPhone Plus 横屏
            setupForRegularRegular()
        case (.compact, .regular):
            // iPhone 竖屏
            setupForCompactRegular()
        case (.compact, .compact):
            // iPhone 横屏
            setupForCompactCompact()
        default:
            break
        }
    }
    
    private func setupForRegularRegular() {
        // iPad 布局
        print("iPad 布局")
    }
    
    private func setupForCompactRegular() {
        // iPhone 竖屏布局
        print("iPhone 竖屏布局")
    }
    
    private func setupForCompactCompact() {
        // iPhone 横屏布局
        print("iPhone 横屏布局")
    }
}
```

### 多窗口适配

```swift
@available(iOS 13.0, *)
class MultiWindowAdapter: UIResponder, UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 根据窗口大小适配布局
        let traitCollection = windowScene.traitCollection
        
        if traitCollection.horizontalSizeClass == .regular {
            // 宽屏布局
            setupWideLayout(in: windowScene)
        } else {
            // 窄屏布局
            setupNarrowLayout(in: windowScene)
        }
    }
    
    private func setupWideLayout(in scene: UIWindowScene) {
        // 使用分栏布局
        let splitVC = UISplitViewController()
        // ...
    }
    
    private func setupNarrowLayout(in scene: UIWindowScene) {
        // 使用导航布局
        let navVC = UINavigationController()
        // ...
    }
}
```

---

## 深色模式适配

```swift
class DarkModeCompatibleView: UIView {
    
    // 使用动态颜色
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label  // 自动适配深色模式
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground  // 自动适配
        return view
    }()
    
    // 自定义动态颜色
    private func customDynamicColor() -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
            case .light, .unspecified:
                return UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            @unknown default:
                return .white
            }
        }
    }
    
    // 监听模式变化
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            // 深色模式切换
            updateForDarkMode()
        }
    }
    
    private func updateForDarkMode() {
        // 更新需要特殊处理的 UI
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.customDynamicColor()
        }
    }
}
```

---

## 辅助功能（Accessibility）

```swift
class AccessibleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAccessibility() {
        // 设置辅助功能标签
        accessibilityLabel = "提交按钮"
        
        // 设置辅助功能提示
        accessibilityHint = "双击以提交表单"
        
        // 设置按钮类型
        accessibilityTraits = .button
        
        // 设置是否可访问
        isAccessibilityElement = true
        
        // 自定义值
        accessibilityValue = "未选中"
    }
    
    override var isSelected: Bool {
        didSet {
            accessibilityValue = isSelected ? "已选中" : "未选中"
            accessibilityPerformUpdate()
        }
    }
}

// 支持动态字体
class DynamicTypeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDynamicType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDynamicType() {
        font = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        
        // 监听字体变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fontDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func fontDidChange() {
        font = .preferredFont(forTextStyle: .body)
        setNeedsLayout()
    }
}
```

---

*最后更新：2026-03-03*
