# 布局系统

> 📐 Auto Layout 与 NSStackView 完全指南 (Swift 版)

---

## Auto Layout 自动布局

### 基础用法

```swift
let view = NSView()
view.translatesAutoresizingMaskIntoConstraints = false
parentView.addSubview(view)

NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 16),
    view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -16),
    view.heightAnchor.constraint(equalToConstant: 100)
])
```

### 常用锚点

```swift
view.topAnchor
view.bottomAnchor
view.leadingAnchor
view.trailingAnchor
view.centerXAnchor
view.centerYAnchor
view.widthAnchor
view.heightAnchor
```

### 约束优先级

```swift
let constraint = view.widthAnchor.constraint(equalToConstant: 200)
constraint.priority = .defaultHigh
constraint.isActive = true
```

---

## NSStackView 堆栈视图

### 基础用法

```swift
let stackView = NSStackView()
stackView.orientation = .vertical
stackView.distribution = .fill
stackView.alignment = .leading
stackView.spacing = 8
stackView.translatesAutoresizingMaskIntoConstraints = false

stackView.addArrangedSubview(view1)
stackView.addArrangedSubview(view2)
stackView.addArrangedSubview(view3)

view.addSubview(stackView)

NSLayoutConstraint.activate([
    stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
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
stackView.alignment = .leading
stackView.alignment = .trailing
stackView.alignment = .centerX
stackView.alignment = .centerY
stackView.alignment = .firstBaseline
```

### 嵌套使用

```swift
let verticalStack = NSStackView()
verticalStack.orientation = .vertical
verticalStack.spacing = 20

let horizontalStack = NSStackView()
horizontalStack.orientation = .horizontal
horizontalStack.spacing = 16
horizontalStack.distribution = .fillEqually

horizontalStack.addArrangedSubview(button1)
horizontalStack.addArrangedSubview(button2)

verticalStack.addArrangedSubview(titleLabel)
verticalStack.addArrangedSubview(horizontalStack)

view.addSubview(verticalStack)
```

---

## Safe Area

### 使用方法

```swift
if #available(macOS 11.0, *) {
    view.safeAreaInsets
}
```

---

## 常见布局问题

### 1. 约束冲突

确保每个视图有足够的约束来确定位置和大小

### 2. 视图不显示

检查：
1. 是否添加了子视图
2. 约束是否正确
3. translatesAutoresizingMaskIntoConstraints 是否设为 false

### 3. 性能问题

```swift
NSLayoutConstraint.activate([
    // 批量激活约束
])
```

---

## Masonry for macOS (Objective-C)

如果是 Objective-C 项目，可以使用 Masonry：

```objc
#import "Masonry.h"

[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(20);
    make.left.equalTo(self.view).offset(16);
    make.right.equalTo(self.view).offset(-16);
    make.height.equalTo(@100);
}];
```

---

## SnapKit for macOS

Swift 项目可以使用 SnapKit：

```swift
import SnapKit

view.snp.makeConstraints { make in
    make.top.equalTo(self.view).offset(20)
    make.left.equalTo(self.view).offset(16)
    make.right.equalTo(self.view).offset(-16)
    make.height.equalTo(100)
}
```

---

*最后更新：2026-03-05*
