# 布局系统

> 📐 Auto Layout 与 UIStackView 完全指南

---

## Auto Layout 自动布局

### 核心概念

Auto Layout 通过约束（Constraints）来描述视图之间的关系，而不是直接使用 frame。

**约束方程：**
```
item1.attribute1 = multiplier × item2.attribute2 + constant
```

### 基础用法

```swift
let view = UIView()
view.translatesAutoresizingMaskIntoConstraints = false
parentView.addSubview(view)

// 创建约束
let constraint = NSLayoutConstraint(
    item: view,
    attribute: .centerX,
    relatedBy: .equal,
    toItem: parentView,
    attribute: .centerX,
    multiplier: 1.0,
    constant: 0
)
parentView.addConstraint(constraint)
```

### 锚点 API（推荐）

```swift
let subview = UIView()
subview.translatesAutoresizingMaskIntoConstraints = false
parentView.addSubview(subview)

NSLayoutConstraint.activate([
    // 位置
    subview.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
    subview.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16),
    subview.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16),
    subview.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -20),
    
    // 中心
    subview.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
    subview.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
    
    // 尺寸
    subview.widthAnchor.constraint(equalToConstant: 200),
    subview.heightAnchor.constraint(equalToConstant: 100),
    
    // 比例
    subview.widthAnchor.constraint(equalTo: subview.heightAnchor, multiplier: 2.0),
    
    // 相对于其他视图
    subview.topAnchor.constraint(equalTo: otherView.bottomAnchor, constant: 10),
    
    // 安全区域
    subview.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor)
])
```

### 常用锚点

```swift
// 边缘
view.topAnchor
view.bottomAnchor
view.leadingAnchor    // 支持从左到右和从右到左的语言
view.trailingAnchor
view.leftAnchor
view.rightAnchor

// 中心
view.centerXAnchor
view.centerYAnchor

// 尺寸
view.widthAnchor
view.heightAnchor

// 基线（用于文本对齐）
view.firstBaselineAnchor
view.lastBaselineAnchor

// 安全区域
view.safeAreaLayoutGuide.topAnchor
view.safeAreaLayoutGuide.bottomAnchor
view.safeAreaLayoutGuide.leadingAnchor
view.safeAreaLayoutGuide.trailingAnchor
```

### 约束优先级

```swift
// 优先级范围：1 (最低) ~ 1000 (最高，必需)
let constraint = view.widthAnchor.constraint(equalToConstant: 200)
constraint.priority = .defaultHigh    // 750
constraint.priority = .defaultLow     // 250
constraint.priority = .fittingSizeLevel // 50
constraint.priority = .required       // 1000

constraint.isActive = true
```

### 常见布局模式

#### 1. 居中视图

```swift
let centeredView = UIView()
centeredView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(centeredView)

NSLayoutConstraint.activate([
    centeredView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    centeredView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    centeredView.widthAnchor.constraint(equalToConstant: 200),
    centeredView.heightAnchor.constraint(equalToConstant: 100)
])
```

#### 2. 边距固定

```swift
let marginView = UIView()
marginView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(marginView)

NSLayoutConstraint.activate([
    marginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
    marginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    marginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    marginView.heightAnchor.constraint(equalToConstant: 50)
])
```

#### 3. 宽高比例

```swift
let aspectView = UIView()
aspectView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(aspectView)

NSLayoutConstraint.activate([
    aspectView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
    aspectView.heightAnchor.constraint(equalTo: aspectView.widthAnchor, multiplier: 1.0), // 1:1
    aspectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    aspectView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

#### 4. 等间距分布

```swift
let views = [view1, view2, view3]
views.forEach { 
    $0.translatesAutoresizingMaskIntoConstraints = false 
    view.addSubview($0) 
}

NSLayoutConstraint.activate([
    // 顶部对齐
    view1.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
    view2.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
    view3.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
    
    // 等宽
    view1.widthAnchor.constraint(equalTo: view2.widthAnchor),
    view2.widthAnchor.constraint(equalTo: view3.widthAnchor),
    
    // 左右边距
    view1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    view3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    
    // 等间距
    view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor, constant: 16),
    view3.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: 16)
])
```

### 约束更新

```swift
// 保存约束引用
var widthConstraint: NSLayoutConstraint!

override func viewDidLoad() {
    super.viewDidLoad()
    
    widthConstraint = subview.widthAnchor.constraint(equalToConstant: 200)
    widthConstraint.isActive = true
}

// 更新约束
@objc func updateWidth() {
    widthConstraint.constant = 300
    
    // 带动画更新
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    }
}

// 激活/停用
widthConstraint.isActive = false
let newConstraint = subview.widthAnchor.constraint(equalToConstant: 250)
newConstraint.isActive = true
```

### 调试技巧

```swift
// 打印所有约束
print(view.constraints)
print(view.constraintsAffectingLayout(for: .horizontal))

// 可视化
subview.layer.borderColor = UIColor.red.cgColor
subview.layer.borderWidth = 1

// 检查冲突
// Xcode 会在控制台输出详细的冲突信息
// 使用 "View Debugger" 可视化查看
```

---

## UIStackView 堆栈视图

### 基础用法

```swift
let stackView = UIStackView()
stackView.axis = .vertical      // 或 .horizontal
stackView.distribution = .fill
stackView.alignment = .fill
stackView.spacing = 16
stackView.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(stackView)

// 添加子视图
stackView.addArrangedSubview(view1)
stackView.addArrangedSubview(view2)
stackView.addArrangedSubview(view3)

// 约束 stackView
NSLayoutConstraint.activate([
    stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
])
```

### 分布模式

```swift
// .fill - 默认，子视图根据约束填充
stackView.distribution = .fill

// .fillEqually - 子视图等大小
stackView.distribution = .fillEqually

// .fillProportionally - 按原始比例填充
stackView.distribution = .fillProportionally

// .equalSpacing - 等间距
stackView.distribution = .equalSpacing

// .equalCentering - 等中心间距
stackView.distribution = .equalCentering
```

### 对齐模式

```swift
// .fill - 默认，子视图填充
stackView.alignment = .fill

// .leading - 左对齐（垂直）/ 上对齐（水平）
stackView.alignment = .leading

// .trailing - 右对齐（垂直）/ 下对齐（水平）
stackView.alignment = .trailing

// .center - 居中对齐
stackView.alignment = .center

// .firstBaseline - 第一行基线对齐（文本）
stackView.alignment = .firstBaseline

// .lastBaseline - 最后一行基线对齐（文本）
stackView.alignment = .lastBaseline
```

### 嵌套使用

```swift
// 垂直堆栈
let verticalStack = UIStackView()
verticalStack.axis = .vertical
verticalStack.spacing = 20

// 水平堆栈
let horizontalStack = UIStackView()
horizontalStack.axis = .horizontal
horizontalStack.spacing = 16
horizontalStack.distribution = .fillEqually

// 添加子视图到水平堆栈
horizontalStack.addArrangedSubview(button1)
horizontalStack.addArrangedSubview(button2)
horizontalStack.addArrangedSubview(button3)

// 将水平堆栈添加到垂直堆栈
verticalStack.addArrangedSubview(titleLabel)
verticalStack.addArrangedSubview(descriptionLabel)
verticalStack.addArrangedSubview(horizontalStack)

view.addSubview(verticalStack)
```

### 动态管理

```swift
// 插入子视图
stackView.insertArrangedSubview(newView, at: 0)

// 移除子视图
stackView.removeArrangedSubview(viewToRemove)
viewToRemove.removeFromSuperview()

// 隐藏子视图
subview.isHidden = true  // 自动从堆栈中移除空间

// 交换位置
stackView.removeArrangedSubview(view1)
stackView.insertArrangedSubview(view1, at: 2)

// 设置自定义间距
stackView.setCustomSpacing(30, after: specificView)
```

### 实用示例

#### 1. 表单布局

```swift
func createForm() -> UIStackView {
    let formStack = UIStackView()
    formStack.axis = .vertical
    formStack.spacing = 16
    
    let fields = [
        createField(placeholder: "姓名"),
        createField(placeholder: "邮箱"),
        createField(placeholder: "电话")
    ]
    
    fields.forEach { formStack.addArrangedSubview($0) }
    
    return formStack
}

func createField(placeholder: String) -> UIStackView {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 12
    
    let label = UILabel()
    label.text = placeholder
    label.widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    
    stack.addArrangedSubview(label)
    stack.addArrangedSubview(textField)
    
    return stack
}
```

#### 2. 按钮组

```swift
func createButtonGroup() -> UIStackView {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 12
    
    let buttons = [
        createButton(title: "取消", color: .gray),
        createButton(title: "确认", color: .systemBlue)
    ]
    
    buttons.forEach { stack.addArrangedSubview($0) }
    
    return stack
}

func createButton(title: String, color: UIColor) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.backgroundColor = color
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    return button
}
```

#### 3. 自适应卡片

```swift
func createCardView() -> UIStackView {
    let cardStack = UIStackView()
    cardStack.axis = .vertical
    cardStack.spacing = 12
    cardStack.backgroundColor = .white
    cardStack.layer.cornerRadius = 12
    cardStack.clipsToBounds = true
    cardStack.isLayoutMarginsRelativeArrangement = true
    cardStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "photo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    let titleLabel = UILabel()
    titleLabel.text = "标题"
    titleLabel.font = .boldSystemFont(ofSize: 18)
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = "副标题描述"
    subtitleLabel.textColor = .gray
    subtitleLabel.numberOfLines = 0
    
    cardStack.addArrangedSubview(imageView)
    cardStack.addArrangedSubview(titleLabel)
    cardStack.addArrangedSubview(subtitleLabel)
    
    return cardStack
}
```

---

## Safe Area 安全区域

### 基础概念

Safe Area 是屏幕上不会被导航栏、标签栏、刘海等遮挡的区域。

### 使用方法

```swift
// 相对于安全区域布局
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
])

// 获取安全区域 insets
let safeInsets = view.safeAreaInsets
print("顶部：\(safeInsets.top)")    // 刘海/导航栏高度
print("底部：\(safeInsets.bottom)") // 底部指示条高度
```

### 扩展安全区域

```swift
// 自定义扩展
additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

// 子视图控制器会自动考虑父视图的安全区域
```

### 适配不同设备

```swift
// 检查是否有刘海
if #available(iOS 11.0, *) {
    let hasNotch = view.safeAreaInsets.top > 20
    print("有刘海：\(hasNotch)")
}

// 底部指示条
let hasHomeIndicator = view.safeAreaInsets.bottom > 0
```

---

## 常见布局问题

### 1. 约束冲突

**问题：** 多个约束无法同时满足

**解决：**
```swift
// 降低优先级
constraint.priority = .defaultHigh  // 750 而不是 1000

// 检查必要的约束是否完整
// 每个视图需要足够的约束来确定位置和大小
```

### 2. 模糊约束

**问题：** 约束不足，视图位置或大小不确定

**解决：**
```swift
// 确保水平和垂直方向都有完整约束
// 水平：leading + trailing 或 centerX + width
// 垂直：top + bottom 或 centerY + height
```

### 3. 性能问题

**问题：** 大量约束导致布局缓慢

**解决：**
```swift
// 使用 UIStackView 简化布局
// 批量更新约束
UIView.performWithoutAnimation {
    // 更新多个约束
    layoutIfNeeded()
}
```

---

*最后更新：2026-03-03*
