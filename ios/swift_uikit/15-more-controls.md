# 更多常用控件

> 🎛️ 补充控件完整指南 (Swift 版)

---

## UISwitch 开关

### 基础用法

```swift
let switchControl = UISwitch()
switchControl.isOn = true
switchControl.onTintColor = .systemGreen
switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)

@objc func switchChanged(_ sender: UISwitch) {
    print("开关状态：\(sender.isOn ? "开" : "关")")
}
```

---

## UISlider 滑块

### 基础用法

```swift
let slider = UISlider()
slider.minimumValue = 0
slider.maximumValue = 100
slider.value = 50
slider.isContinuous = true
slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)

@objc func sliderChanged(_ sender: UISlider) {
    print("当前值：\(sender.value)")
}
```

### 自定义外观

```swift
slider.minimumTrackTintColor = .systemBlue
slider.maximumTrackTintColor = .gray
slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
```

---

## UIStepper 步进器

### 基础用法

```swift
let stepper = UIStepper()
stepper.minimumValue = 0
stepper.maximumValue = 100
stepper.stepValue = 1
stepper.value = 50
stepper.wraps = false
stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)

@objc func stepperChanged(_ sender: UIStepper) {
    print("步进值：\(sender.value)")
}
```

---

## UIProgressView 进度条

### 基础用法

```swift
let progressView = UIProgressView(progressViewStyle: .default)
progressView.progress = 0.5
progressView.trackTintColor = .gray
progressView.progressTintColor = .systemBlue
```

### 动画更新

```swift
UIView.animate(withDuration: 0.3) {
    self.progressView.setProgress(0.8, animated: true)
}
```

---

## UIActivityIndicatorView 活动指示器

### 基础用法

```swift
let activityIndicator = UIActivityIndicatorView(style: .large)
activityIndicator.startAnimating()
activityIndicator.hidesWhenStopped = true
view.addSubview(activityIndicator)

activityIndicator.stopAnimating()
```

---

## UISegmentedControl 分段控制器

### 基础用法

```swift
let segmentControl = UISegmentedControl(items: ["选项 1", "选项 2", "选项 3"])
segmentControl.selectedSegmentIndex = 0
segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)

@objc func segmentChanged(_ sender: UISegmentedControl) {
    print("选中索引：\(sender.selectedSegmentIndex)")
}
```

### 自定义样式

```swift
segmentControl.selectedSegmentTintColor = .systemBlue
segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
segmentControl.insertSegment(withImage: UIImage(systemName: "house"), at: 0, animated: true)
segmentControl.setEnabled(false, forSegmentAtIndex: 2)
```

---

## UIDatePicker 日期选择器

### 基础用法

```swift
let datePicker = UIDatePicker()
datePicker.datePickerMode = .dateAndTime
if #available(iOS 13.4, *) {
    datePicker.preferredDatePickerStyle = .wheels
}
datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

@objc func dateChanged(_ sender: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    print("选中日期：\(formatter.string(from: sender.date))")
}
```

### 日期模式

```swift
datePicker.datePickerMode = .dateAndTime
datePicker.datePickerMode = .date
datePicker.datePickerMode = .time
datePicker.datePickerMode = .countDownTimer
```

### 设置范围

```swift
datePicker.minimumDate = Date().addingTimeInterval(-30 * 24 * 60 * 60)
datePicker.maximumDate = Date().addingTimeInterval(30 * 24 * 60 * 60)
datePicker.date = Date()
```

---

## UIPickerView 选择器

### 基础用法

```swift
class MyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerView = UIPickerView()
    let fruits = ["苹果", "香蕉", "橙子", "葡萄", "西瓜"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fruits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fruits[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("选中：\(fruits[row])")
    }
}
```

---

## UIAlertController 警报控制器

### 基础用法

```swift
let alert = UIAlertController(title: "提示", message: "这是一个警报", preferredStyle: .alert)

alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
    print("点击了确定")
})

present(alert, animated: true, completion: nil)
```

### 添加文本输入框

```swift
let alert = UIAlertController(title: "输入", message: "请输入内容", preferredStyle: .alert)

alert.addTextField { textField in
    textField.placeholder = "请输入..."
    textField.keyboardType = .emailAddress
}

alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
    let text = alert.textFields?.first?.text
    print("输入内容：\(text ?? "")")
})

present(alert, animated: true, completion: nil)
```

---

## UIRefreshControl 刷新控件

### 基础用法

```swift
let refreshControl = UIRefreshControl()
refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
tableView.refreshControl = refreshControl

@objc func refreshData(_ sender: UIRefreshControl) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        sender.endRefreshing()
    }
}
```

---

## UISearchBar 搜索栏

### 基础用法

```swift
let searchBar = UISearchBar()
searchBar.delegate = self
searchBar.placeholder = "搜索..."
searchBar.showsCancelButton = true
view.addSubview(searchBar)
```

### 代理方法

```swift
extension MyViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("搜索内容：\(searchBar.text ?? "")")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("搜索文本变化：\(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
```

---

*最后更新：2026-03-05*
