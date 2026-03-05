# 布局系统

> 📐 Auto Layout 与 UIStackView 完全指南 (Swift 版)

---

## Auto Layout 自动布局

### 基础用法

```swift
let view = UIView()
view.translatesAutoresizingMaskIntoConstraints = false
parentView.addSubview(view)

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
    subview.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
    subview.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16),
    subview.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16),
    subview.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -20),
    subview.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
    subview.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
    subview.widthAnchor.constraint(equalToConstant: 200),
    subview.heightAnchor.constraint(equalToConstant: 100),
    subview.widthAnchor.constraint(equalTo: subview.heightAnchor, multiplier: 2.0),
    subview.topAnchor.constraint(equalTo: otherView.bottomAnchor, constant: 10),
    subview.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor)
])
```

### 常用锚点

```swift
view.topAnchor
view.bottomAnchor
view.leadingAnchor
view.trailingAnchor
view.leftAnchor
view.rightAnchor
view.centerXAnchor
view.centerYAnchor
view.widthAnchor
view.heightAnchor
view.firstBaselineAnchor
view.lastBaselineAnchor
view.safeAreaLayoutGuide.topAnchor
view.safeAreaLayoutGuide.bottomAnchor
```

### 约束优先级

```swift
let constraint = view.widthAnchor.constraint(equalToConstant: 200)
constraint.priority = .defaultHigh    // 750
constraint.priority = .defaultLow     // 250
constraint.priority = .fittingSizeLevel // 50
constraint.priority = .required       // 1000
constraint.isActive = true
```

### 约束更新

```swift
var widthConstraint: NSLayoutConstraint!

override func viewDidLoad() {
    super.viewDidLoad()
    widthConstraint = subview.widthAnchor.constraint(equalToConstant: 200)
    widthConstraint.isActive = true
}

@objc func updateWidth() {
    widthConstraint.constant = 300
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    }
}

widthConstraint.isActive = false
let newConstraint = subview.widthAnchor.constraint(equalToConstant: 250)
newConstraint.isActive = true
```

---

## UIStackView 堆栈视图

### 基础用法

```swift
let stackView = UIStackView()
stackView.axis = .vertical
stackView.distribution = .fill
stackView.alignment = .fill
stackView.spacing = 16
stackView.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(stackView)

stackView.addArrangedSubview(view1)
stackView.addArrangedSubview(view2)
stackView.addArrangedSubview(view3)

NSLayoutConstraint.activate([
    stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
])
```

### 分布模式

```swift
stackView.distribution = .fill
stackView.distribution = .fillEqually
stackView.distribution = .fillProportionally
stackView.distribution = .equalSpacing
stackView.distribution = .equalCentering
```

### 对齐模式

```swift
stackView.alignment = .fill
stackView.alignment = .leading
stackView.alignment = .trailing
stackView.alignment = .center
stackView.alignment = .firstBaseline
stackView.alignment = .lastBaseline
```

### 嵌套使用

```swift
let verticalStack = UIStackView()
verticalStack.axis = .vertical
verticalStack.spacing = 20

let horizontalStack = UIStackView()
horizontalStack.axis = .horizontal
horizontalStack.spacing = 16
horizontalStack.distribution = .fillEqually

horizontalStack.addArrangedSubview(button1)
horizontalStack.addArrangedSubview(button2)
horizontalStack.addArrangedSubview(button3)

verticalStack.addArrangedSubview(titleLabel)
verticalStack.addArrangedSubview(descriptionLabel)
verticalStack.addArrangedSubview(horizontalStack)

view.addSubview(verticalStack)
```

### 动态管理

```swift
stackView.insertArrangedSubview(newView, at: 0)
stackView.removeArrangedSubview(viewToRemove)
viewToRemove.removeFromSuperview()
subview.isHidden = true
stackView.setCustomSpacing(30, after: specificView)
```

---

## Safe Area 安全区域

### 使用方法

```swift
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
    view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
])

let safeInsets = view.safeAreaInsets
print("顶部：\(safeInsets.top)")
print("底部：\(safeInsets.bottom)")
```

### 扩展安全区域

```swift
additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
```

### 适配不同设备

```swift
if #available(iOS 11.0, *) {
    let hasNotch = view.safeAreaInsets.top > 20
    print("有刘海：\(hasNotch)")
}
let hasHomeIndicator = view.safeAreaInsets.bottom > 0
```

---

## 常见布局问题

### 1. 约束冲突

```swift
constraint.priority = .defaultHigh
```

### 2. 模糊约束

确保水平和垂直方向都有完整约束

### 3. 性能问题

```swift
UIView.performWithoutAnimation {
    layoutIfNeeded()
}
```

---

*最后更新：2026-03-05*
