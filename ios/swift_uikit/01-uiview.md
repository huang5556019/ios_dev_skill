# UIView 基础视图

> 🎯 所有 UI 组件的基类

---

## 📌 核心概念

UIView 是 iOS 中所有可见 UI 元素的基类。它负责：
- 渲染内容到屏幕
- 处理触摸和事件
- 管理子视图层级
- 支持动画和变换

---

## 🔧 常用属性

### 外观属性

```swift
// 背景颜色
view.backgroundColor = UIColor.systemBlue

// 圆角
view.layer.cornerRadius = 8
view.layer.masksToBounds = true

// 边框
view.layer.borderWidth = 1
view.layer.borderColor = UIColor.gray.cgColor

// 阴影
view.layer.shadowColor = UIColor.black.cgColor
view.layer.shadowOffset = CGSize(width: 0, height: 2)
view.layer.shadowOpacity = 0.3
view.layer.shadowRadius = 4
```

### 布局属性

```swift
// 框架（父坐标系）
view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

// 边界（自身坐标系）
view.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

// 中心点（父坐标系）
view.center = CGPoint(x: 50, y: 50)

// 变换
view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
```

### 交互属性

```swift
// 用户交互
view.isUserInteractionEnabled = true

// Alpha 透明度
view.alpha = 0.8

// 隐藏
view.isHidden = false

// 清除背景
view.isOpaque = false
```

---

## 🎨 添加子视图

```swift
let subview = UIView()
subview.backgroundColor = .red
view.addSubview(subview)

// 移除子视图
subview.removeFromSuperview()

// 移除所有子视图
subview.subviews.forEach { $0.removeFromSuperview() }

// 交换子视图顺序
view.exchangeSubview(at: 0, withSubviewAt: 1)

// 插入到指定位置
view.insertSubview(subview, at: 0)
view.insertSubview(subview, aboveSubview: anotherView)
view.insertSubview(subview, belowSubview: anotherView)
```

---

## 🔄 视图层级查询

```swift
// 获取父视图
let superview = view.superview

// 获取所有子视图
let subviews = view.subviews

// 判断是否包含某个子视图
let contains = view.subviews.contains(anotherView)

// 转换坐标
let pointInWindow = view.convert(point, to: nil)  // 转换到 window
let pointInView = view.convert(point, from: anotherView)  // 从另一个视图转换
```

---

## 💫 视图动画

### 基础动画

```swift
UIView.animate(withDuration: 0.3) {
    view.alpha = 0.5
    view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
}
```

### 链式动画

```swift
UIView.animate(withDuration: 0.3, animations: {
    view.alpha = 0.5
}) { completed in
    UIView.animate(withDuration: 0.3) {
        view.alpha = 1.0
    }
}
```

### 弹簧动画

```swift
UIView.animate(withDuration: 0.5, 
               delay: 0,
               usingSpringWithDamping: 0.5,
               initialSpringVelocity: 0.5,
               options: [],
               animations: {
    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
})
```

### 动画选项

```swift
UIView.animate(withDuration: 0.3,
               delay: 0,
               options: [.curveEaseInOut, .repeat, .autoreverse],
               animations: {
    view.transform = CGAffineTransform(rotationAngle: .pi)
})
```

---

## 📐 Auto Layout 约束

### 使用 NSLayoutAnchor（推荐）

```swift
let subview = UIView()
subview.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(subview)

NSLayoutConstraint.activate([
    subview.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
    subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    subview.heightAnchor.constraint(equalToConstant: 50)
])
```

### 使用 NSLayoutConstraint

```swift
let constraint = NSLayoutConstraint(
    item: subview,
    attribute: .top,
    relatedBy: .equal,
    toItem: view,
    attribute: .top,
    multiplier: 1.0,
    constant: 20
)
view.addConstraint(constraint)
```

### 常用约束示例

```swift
// 居中
NSLayoutConstraint.activate([
    subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    subview.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])

// 填充整个父视图
NSLayoutConstraint.activate([
    subview.topAnchor.constraint(equalTo: view.topAnchor),
    subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    subview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
])

// 固定宽高比
NSLayoutConstraint.activate([
    subview.widthAnchor.constraint(equalTo: subview.heightAnchor, multiplier: 16.0/9.0)
])

// 相对于安全区域
NSLayoutConstraint.activate([
    subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
])
```

---

## 🎯 最佳实践

### ✅ 推荐做法

```swift
// 1. 总是设置 translatesAutoresizingMaskIntoConstraints = false 使用 Auto Layout
subview.translatesAutoresizingMaskIntoConstraints = false

// 2. 使用 lazy 属性创建复杂视图
private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()

// 3. 使用 NSLayoutConstraint.activate 批量激活约束
NSLayoutConstraint.activate([
    // 多个约束
])

// 4. 给约束添加标识符便于调试
constraint.identifier = "titleLabelTopConstraint"
```

### ❌ 避免做法

```swift
// 1. 不要混用 frame 和 Auto Layout
// ❌
view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
// 然后又添加约束

// 2. 不要忘记禁用 autoresizing mask
// ❌
view.addSubview(subview)  // 没有设置 translatesAutoresizingMaskIntoConstraints = false

// 3. 不要在 updateViewConstraints 外修改约束
// ❌
override func viewDidLoad() {
    constraint.constant = 20  // 应该在 updateViewConstraints 中
}
```

---

## 🐛 常见问题

### 约束冲突

```swift
// 检查约束冲突
view.hasAmbiguousLayout  // 检查是否有歧义布局

// 在控制台查看冲突详情
// 运行时会打印冲突的约束信息

// 解决：移除或修改冲突的约束
constraint.isActive = false
```

### 约束性能优化

```swift
// 1. 缓存约束引用
private var topConstraint: NSLayoutConstraint!

// 2. 批量更新约束
NSLayoutConstraint.activate([
    constraint1, constraint2, constraint3
])

// 3. 使用 constraint 优先级
constraint.priority = .defaultHigh  // 999
```

---

## 📊 性能提示

1. **减少视图层级** - 层级越浅，渲染越快
2. **使用 layer 而非 view** - 简单图形直接用 CALayer
3. **避免离屏渲染** - 谨慎使用 shadow、cornerRadius、masksToBounds
4. **复用视图** - 列表中使用 cell 重用机制

---

*最后更新：2026-03-04*
