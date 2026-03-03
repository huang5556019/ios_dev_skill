# 常用控件文档

> 🎛️ UIKit 核心控件使用指南

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
paragraphStyle.lineHeightMultiple = 1.5
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
        // 可以在这里做输入验证
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
textField.borderStyle = .none          // 无边框
textField.borderStyle = .line          // 底线
textField.borderStyle = .bezel         // 凹陷
textField.borderStyle = .roundedRect   // 圆角矩形

// 左视图（通常放图标）
let iconView = UIImageView(image: UIImage(systemName: "search"))
iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
textField.leftView = iconView
textField.leftViewMode = .always

// 右视图（通常放清除按钮）
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

### 键盘类型

```swift
textField.keyboardType = .default           // 默认
textField.keyboardType = .asciiCapable      // ASCII
textField.keyboardType = .numbersAndPunctuation // 数字和标点
textField.keyboardType = .numberPad         // 数字键盘
textField.keyboardType = .decimalPad        // 小数键盘
textField.keyboardType = .phonePad          // 电话键盘
textField.keyboardType = .namePhonePad      // 姓名电话
textField.keyboardType = .emailAddress      // 邮箱
textField.keyboardType = .URL               // URL
textField.keyboardType = .twitter           // Twitter
textField.keyboardType = .webSearch         // Web 搜索
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
textView.isScrollable = true
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

### 富文本编辑

```swift
// 设置富文本
let attributedText = NSMutableAttributedString(string: "Hello World")
attributedText.addAttribute(.font,
                           value: UIFont.boldSystemFont(ofSize: 20),
                           range: NSRange(location: 0, length: 5))
textView.attributedText = attributedText

// 获取选区
let selectedRange = textView.selectedRange
let selectedText = (textView.text as NSString).substring(with: selectedRange)

// 设置选区
textView.selectedRange = NSRange(location: 0, length: 5)
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
imageView.contentMode = .scaleToFill      // 填充（可能变形）
imageView.contentMode = .scaleAspectFit   // 适应（保持比例，可能有留白）
imageView.contentMode = .scaleAspectFill  // 填充（保持比例，可能裁剪）
imageView.contentMode = .center           // 居中
imageView.contentMode = .top              // 顶部
imageView.contentMode = .bottom           // 底部
imageView.contentMode = .left             // 左侧
imageView.contentMode = .right            // 右侧
```

### 圆角与边框

```swift
// 圆角
imageView.layer.cornerRadius = 8
imageView.clipsToBounds = true

// 圆形
imageView.layer.cornerRadius = imageView.bounds.width / 2
imageView.clipsToBounds = true

// 边框
imageView.layer.borderWidth = 2
imageView.layer.borderColor = UIColor.systemBlue.cgColor
```

### 动画

```swift
// 淡入动画
UIView.animate(withDuration: 0.3) {
    imageView.alpha = 1.0
}

// 图片切换动画
UIView.transition(with: imageView,
                  duration: 0.3,
                  options: .transitionCrossDissolve,
                  animations: {
    imageView.image = UIImage(named: "newImage")
})
```

### 加载网络图片

```swift
extension UIImageView {
    func load(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, 
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

// 使用
imageView.load(url: URL(string: "https://example.com/image.jpg")!)
```

---

## UIScrollView 滚动视图

### 基础用法

```swift
let scrollView = UIScrollView()
scrollView.frame = view.bounds
scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
view.addSubview(scrollView)

// 添加内容视图
let contentView = UIView()
scrollView.addSubview(contentView)

// 设置约束
contentView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    // 高度由内容决定
])
```

### 常用属性

```swift
// 内容大小
scrollView.contentSize = CGSize(width: 320, height: 1000)

// 内容 insets
scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

// 滚动偏移
scrollView.contentOffset = CGPoint(x: 0, y: 100)

// 分页
scrollView.isPagingEnabled = true

// 显示指示器
scrollView.showsVerticalScrollIndicator = true
scrollView.showsHorizontalScrollIndicator = true

// 弹性
scrollView.alwaysBounceVertical = true
scrollView.alwaysBounceHorizontal = false

// 缩放
scrollView.minimumZoomScale = 1.0
scrollView.maximumZoomScale = 3.0
scrollView.zoomScale = 1.0
```

### 代理方法

```swift
extension MyVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("滚动中：\(scrollView.contentOffset.y)")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("开始拖动")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, 
                                  willDecelerate decelerate: Bool) {
        print("结束拖动，是否减速：\(decelerate)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("减速结束")
    }
    
    // 缩放
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView,
                                 with view: UIView?,
                                 atScale scale: CGFloat) {
        print("缩放结束：\(scale)")
    }
}
```

### 滚动到指定位置

```swift
// 滚动到顶部
scrollView.setContentOffset(.zero, animated: true)

// 滚动到底部
let bottomOffset = CGPoint(
    x: 0, 
    y: scrollView.contentSize.height - scrollView.bounds.height
)
scrollView.setContentOffset(bottomOffset, animated: true)

// 滚动到指定视图
let targetView = subviews[5]
let targetOffset = CGPoint(
    x: 0, 
    y: targetView.frame.origin.y
)
scrollView.setContentOffset(targetOffset, animated: true)
```

---

*最后更新：2026-03-03*
