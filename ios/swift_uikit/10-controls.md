# 常用控件文档

> 🎛️ UIKit 核心控件使用指南 (Swift 版)

---

## UIButton 按钮

### 基础用法

```swift
let button = UIButton(type: .system)
button.setTitle("点击我", for: .normal)
button.setTitleColor(.systemBlue, for: .normal)
button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

@objc func buttonTapped() {
    print("按钮被点击")
}
```

### 样式设置

```swift
// 背景色
button.backgroundColor = .systemBlue

// 圆角
button.layer.cornerRadius = 8
button.clipsToBounds = true

// 边框
button.layer.borderWidth = 1
button.layer.borderColor = UIColor.systemBlue.cgColor

// 内容EdgeInsets
button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

// 标题EdgeInsets
button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

// 图片
button.setImage(UIImage(systemName: "star"), for: .normal)
button.imageView?.contentMode = .scaleAspectFit
```

### 不同状态

```swift
// 正常状态
button.setTitle("提交", for: .normal)
button.backgroundColor = .systemBlue

// 高亮状态
button.setTitle("提交中...", for: .highlighted)

// 禁用状态
button.isEnabled = false
button.setTitle("不可用", for: .disabled)
button.backgroundColor = .gray

// 选中状态
button.isSelected = true
button.setTitle("已选中", for: .selected)
```

### 按钮类型

```swift
// 系统按钮（推荐）
let systemBtn = UIButton(type: .system)

// 自定义按钮
let customBtn = UIButton(type: .custom)

// 带详情的按钮
let detailBtn = UIButton(type: .detailDisclosure)

// 信息按钮
let infoBtn = UIButton(type: .infoLight)

// 联系添加按钮
let contactBtn = UIButton(type: .contactAdd)
```

---

## UILabel 标签

### 基础用法

```swift
let label = UILabel()
label.text = "Hello World"
label.font = UIFont.systemFont(ofSize: 16)
label.textColor = .label
label.textAlignment = .center
```

### 多行文本

```swift
// 允许换行
label.numberOfLines = 0

// 限制行数
label.numberOfLines = 3

// 截断模式
label.lineBreakMode = .byTruncatingTail  // 末尾省略
label.lineBreakMode = .byTruncatingHead  // 开头省略
label.lineBreakMode = .byTruncatingMiddle // 中间省略
label.lineBreakMode = .byWordWrapping     // 按词换行
```

### 富文本

```swift
let attributedText = NSMutableAttributedString(string: "Hello World")
attributedText.addAttribute(.font, 
                           value: UIFont.boldSystemFont(ofSize: 18),
                           range: NSRange(location: 0, length: 5))
attributedText.addAttribute(.foregroundColor,
                           value: UIColor.red,
                           range: NSRange(location: 6, length: 5))
label.attributedText = attributedText
```

### 高级属性

```swift
// 阴影
label.shadowColor = .gray
label.shadowOffset = CGSize(width: 1, height: 1)

// 行间距
let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.lineSpacing = 8
label.attributedText = NSAttributedString(
    string: "多行文本",
    attributes: [.paragraphStyle: paragraphStyle]
)

// 自适应字体
label.adjustsFontForContentSizeCategory = true
label.font = .preferredFont(forTextStyle: .body)
```

---

## UITextField 文本输入框

### 基础用法

```swift
let textField = UITextField()
textField.placeholder = "请输入..."
textField.text = "默认值"
textField.borderStyle = .roundedRect
textField.keyboardType = .emailAddress
textField.returnKeyType = .done
```

### 代理方法

```swift
extension MyVC: UITextFieldDelegate {
    
    // 即将开始编辑
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 已经开始编辑
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("开始编辑")
    }
    
    // 即将结束编辑
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 已经结束编辑
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("结束编辑")
    }
    
    // 字符变化
    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange, 
                   replacementString string: String) -> Bool {
        return true
    }
    
    // 点击清除按钮
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 点击返回键
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
```

### 样式设置

```swift
// 边框样式
textField.borderStyle = .none
textField.borderStyle = .line
textField.borderStyle = .bezel
textField.borderStyle = .roundedRect

// 左视图
let iconView = UIImageView(image: UIImage(systemName: "search"))
iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
textField.leftView = iconView
textField.leftViewMode = .always

// 右视图
let clearButton = UIButton(type: .custom)
clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
textField.rightView = clearButton
textField.rightViewMode = .whileEditing

// 占位符颜色
textField.attributedPlaceholder = NSAttributedString(
    string: "placeholder",
    attributes: [.foregroundColor: UIColor.gray]
)
```

---

## UITextView 富文本视图

### 基础用法

```swift
let textView = UITextView()
textView.text = "可编辑的富文本"
textView.font = UIFont.systemFont(ofSize: 16)
textView.textColor = .label
textView.isEditable = true
textView.isScrollEnabled = true
```

### 代理方法

```swift
extension MyVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("文本变化：\(textView.text)")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("选区变化")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("结束编辑")
    }
}
```

---

## UIImageView 图片视图

### 基础用法

```swift
let imageView = UIImageView()
imageView.image = UIImage(named: "example")
imageView.contentMode = .scaleAspectFit
imageView.clipsToBounds = true
```

### 内容模式

```swift
imageView.contentMode = .scaleToFill
imageView.contentMode = .scaleAspectFit
imageView.contentMode = .scaleAspectFill
imageView.contentMode = .center
imageView.contentMode = .top
imageView.contentMode = .bottom
imageView.contentMode = .left
imageView.contentMode = .right
```

### 圆角与边框

```swift
imageView.layer.cornerRadius = 8
imageView.clipsToBounds = true
imageView.layer.cornerRadius = imageView.bounds.width / 2
imageView.layer.borderWidth = 2
imageView.layer.borderColor = UIColor.systemBlue.cgColor
```

### 动画

```swift
UIView.animate(withDuration: 0.3) {
    imageView.alpha = 1.0
}

UIView.transition(with: imageView,
                  duration: 0.3,
                  options: .transitionCrossDissolve,
                  animations: {
    imageView.image = UIImage(named: "newImage")
})
```

---

## UIScrollView 滚动视图

### 基础用法

```swift
let scrollView = UIScrollView()
scrollView.frame = view.bounds
scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
view.addSubview(scrollView)

let contentView = UIView()
scrollView.addSubview(contentView)

contentView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
])
```

### 常用属性

```swift
scrollView.contentSize = CGSize(width: 320, height: 1000)
scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
scrollView.contentOffset = CGPoint(x: 0, y: 100)
scrollView.isPagingEnabled = true
scrollView.showsVerticalScrollIndicator = true
scrollView.showsHorizontalScrollIndicator = true
scrollView.alwaysBounceVertical = true
scrollView.minimumZoomScale = 1.0
scrollView.maximumZoomScale = 3.0
```

### 代理方法

```swift
extension MyVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("滚动中：\(scrollView.contentOffset.y)")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
```

---

*最后更新：2026-03-05*
