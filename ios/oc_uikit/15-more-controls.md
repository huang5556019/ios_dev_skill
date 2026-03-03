# 更多常用控件

> 🎛️ 补充控件完整指南

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

### 自定义样式

```swift
// 关闭时背景色
switchControl.onTintColor = .systemGreen      // 开启时
switchControl.tintColor = .gray               // 关闭时
switchControl.thumbTintColor = .white         // 滑块颜色

// iOS 13+ 使用背景色
if #available(iOS 13.0, *) {
    switchControl.backgroundColor = .clear
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
slider.isContinuous = true  // 拖动时持续触发
slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)

@objc func sliderChanged(_ sender: UISlider) {
    print("当前值：\(sender.value)")
}
```

### 自定义外观

```swift
// 轨道颜色
slider.minimumTrackTintColor = .systemBlue    // 左侧轨道
slider.maximumTrackTintColor = .gray          // 右侧轨道

// 滑块图片
slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .highlighted)

// 轨道图片
slider.setMinimumTrackImage(UIImage(), for: .normal)
slider.setMaximumTrackImage(UIImage(), for: .normal)
```

### 步进值

```swift
let stepValue: Float = 5.0

@objc func sliderChanged(_ sender: UISlider) {
    let roundedValue = round(sender.value / stepValue) * stepValue
    sender.setValue(roundedValue, animated: true)
    print("步进值：\(roundedValue)")
}
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
stepper.wraps = false  // 是否循环
stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)

@objc func stepperChanged(_ sender: UIStepper) {
    print("步进值：\(sender.value)")
}
```

### 自定义样式

```swift
// 背景色
stepper.backgroundColor = .systemBlue

// 按钮颜色
stepper.setDecrementImage(UIImage(systemName: "minus"), for: .normal)
stepper.setIncrementImage(UIImage(systemName: "plus"), for: .normal)

// 禁用状态
stepper.setDecrementImage(UIImage(systemName: "minus"), for: .disabled)
stepper.setIncrementImage(UIImage(systemName: "plus"), for: .disabled)
```

---

## UIProgressView 进度条

### 基础用法

```swift
// 默认样式
let progressView = UIProgressView(progressViewStyle: .default)
progressView.progress = 0.5
progressView.trackTintColor = .gray
progressView.progressTintColor = .systemBlue
```

### 条形样式

```swift
// 条形进度条
let barProgress = UIProgressView(progressViewStyle: .bar)
barProgress.progress = 0.75
barProgress.progressImage = UIImage(named: "progress_fill")
barProgress.trackImage = UIImage(named: "progress_track")
```

### 动画更新

```swift
func updateProgress(to value: Float) {
    UIView.animate(withDuration: 0.3) {
        progressView.setProgress(value, animated: true)
    }
}

// 带回调
progressView.setProgress(0.8, animated: true)
DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    print("进度更新完成")
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

// 停止
activityIndicator.stopAnimating()
```

### 样式类型

```swift
// 大尺寸
let largeIndicator = UIActivityIndicatorView(style: .large)

// 中等尺寸
let mediumIndicator = UIActivityIndicatorView(style: .medium)

// 自定义颜色
activityIndicator.color = .systemBlue
```

### 在网络请求中使用

```swift
class NetworkViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
    }
    
    func fetchData() {
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                // 处理数据
            }
        }.resume()
    }
}
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
    print("选中标题：\(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "")")
}
```

### 添加/移除分段

```swift
// 插入分段
segmentControl.insertSegment(withTitle: "新选项", at: 1, animated: true)

// 移除分段
segmentControl.removeSegment(at: 1, animated: true)

// 移除所有
segmentControl.removeAllSegments()
```

### 自定义样式

```swift
// 选中颜色
segmentControl.selectedSegmentTintColor = .systemBlue

// 标题颜色
segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], 
                                      for: .selected)
segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.gray], 
                                      for: .normal)

// 图片分段
segmentControl.insertSegment(with: UIImage(systemName: "house"), 
                            at: 0, 
                            animated: true)

// 禁用分段
segmentControl.setEnabled(false, forSegmentAt: 2)
```

---

## UIDatePicker 日期选择器

### 基础用法

```swift
let datePicker = UIDatePicker()
datePicker.datePickerMode = .dateAndTime
datePicker.preferredDatePickerStyle = .wheels  // 或 .inline, .compact
datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

@objc func dateChanged(_ sender: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    print("选中日期：\(formatter.string(from: sender.date))")
}
```

### 日期模式

```swift
// 日期和时间
datePicker.datePickerMode = .dateAndTime

// 仅日期
datePicker.datePickerMode = .date

// 仅时间
datePicker.datePickerMode = .time

// 倒计时
datePicker.datePickerMode = .countDownTimer
```

### 设置范围

```swift
// 最小日期
let minDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
datePicker.minimumDate = minDate

// 最大日期
let maxDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
datePicker.maximumDate = maxDate

// 选中日期
datePicker.date = Date()

// 倒计时间隔
datePicker.countDownDuration = 3600  // 1 小时
```

### 在 Popover 中显示（iPad）

```swift
@available(iOS 14.0, *)
func showDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .inline
    
    let popover = UIPopoverPresentationController(contentViewController: self)
    popover.sourceView = showDatePickerButton
    popover.sourceRect = showDatePickerButton.bounds
    
    let alert = UIAlertController(title: "选择日期", message: nil, preferredStyle: .alert)
    alert.popoverPresentationController = popover
    present(alert, animated: true)
}
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
    
    // 数据源方法
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, 
                   numberOfRowsInComponent component: Int) -> Int {
        return fruits.count
    }
    
    // 代理方法
    func pickerView(_ pickerView: UIPickerView, 
                   titleForRow row: Int, 
                   forComponent component: Int) -> String? {
        return fruits[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, 
                   didSelectRow row: Int, 
                   inComponent component: Int) {
        print("选中：\(fruits[row])")
    }
}
```

### 多列选择器

```swift
let provinces = ["广东", "浙江", "江苏"]
let cities = [["广州", "深圳", "珠海"], ["杭州", "宁波", "温州"], ["南京", "苏州", "无锡"]]

func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2  // 省和市两列
}

func pickerView(_ pickerView: UIPickerView, 
               numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
        return provinces.count
    } else {
        let provinceIndex = pickerView.selectedRow(inComponent: 0)
        return cities[provinceIndex].count
    }
}

func pickerView(_ pickerView: UIPickerView, 
               titleForRow row: Int, 
               forComponent component: Int) -> String? {
    if component == 0 {
        return provinces[row]
    } else {
        let provinceIndex = pickerView.selectedRow(inComponent: 0)
        return cities[provinceIndex][row]
    }
}

func pickerView(_ pickerView: UIPickerView, 
               didSelectRow row: Int, 
               inComponent component: Int) {
    // 当省改变时，刷新市列
    if component == 0 {
        pickerView.reloadComponent(1)
        pickerView.selectRow(0, inComponent: 1, animated: true)
    }
}
```

### 自定义视图

```swift
func pickerView(_ pickerView: UIPickerView, 
               viewForRow row: Int, 
               forComponent component: Int, 
               reusing view: UIView?) -> UIView {
    
    let label = (view as? UILabel) ?? UILabel()
    label.text = fruits[row]
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    label.textColor = .label
    
    return label
}
```

---

## UIAlertController 警报控制器

### 基础用法

```swift
let alert = UIAlertController(title: "提示", 
                             message: "这是一个警报", 
                             preferredStyle: .alert)

// 添加操作
alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
    print("点击了确定")
}))

present(alert, animated: true, completion: nil)
```

### 样式类型

```swift
// 警报样式（居中显示）
let alert = UIAlertController(title: "标题", message: "消息", preferredStyle: .alert)

// 动作表样式（从底部弹出）
let actionSheet = UIAlertController(title: "选择", 
                                   message: "请选择操作", 
                                   preferredStyle: .actionSheet)
```

### 添加文本输入框

```swift
let alert = UIAlertController(title: "输入", message: "请输入内容", preferredStyle: .alert)

alert.addTextField { textField in
    textField.placeholder = "请输入..."
    textField.keyboardType = .emailAddress
}

alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
    if let text = alert.textFields?.first?.text {
        print("输入内容：\(text)")
    }
}))

present(alert, animated: true, completion: nil)
```

### 多个输入框

```swift
let alert = UIAlertController(title: "登录", message: nil, preferredStyle: .alert)

alert.addTextField { textField in
    textField.placeholder = "用户名"
}

alert.addTextField { textField in
    textField.placeholder = "密码"
    textField.isSecureTextEntry = true
}

alert.addAction(UIAlertAction(title: "登录", style: .default, handler: { _ in
    let username = alert.textFields?[0].text
    let password = alert.textFields?[1].text
    // 处理登录
}))
```

---

## UIRefreshControl 刷新控件

### 基础用法

```swift
let refreshControl = UIRefreshControl()
refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
tableView.refreshControl = refreshControl

@objc func refreshData(_ sender: UIRefreshControl) {
    // 刷新数据
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        sender.endRefreshing()
    }
}
```

### 自定义样式

```swift
if #available(iOS 13.0, *) {
    refreshControl.tintColor = .systemBlue
    refreshControl.backgroundColor = .systemBackground
}

// 设置属性文本
refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
```

### 手动触发刷新

```swift
func triggerRefresh() {
    refreshControl.beginRefreshing()
    tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
    refreshData(refreshControl)
}
```

---

## UISearchBar 搜索栏

### 基础用法

```swift
class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "搜索..."
        searchBar.showsCancelButton = true
        view.addSubview(searchBar)
    }
    
    // 开始搜索
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("搜索内容：\(searchBar.text ?? "")")
        searchBar.resignFirstResponder()
    }
    
    // 文本变化
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("搜索文本变化：\(searchText)")
    }
    
    // 取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
```

### 自定义样式

```swift
// 背景色
searchBar.barTintColor = .systemBlue

// 文字颜色
searchBar.searchTextField.textColor = .white
searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
    string: "搜索...",
    attributes: [.foregroundColor: UIColor.lightGray]
)

// 按钮颜色
searchBar.tintColor = .white
```

---

*最后更新：2026-03-03*
