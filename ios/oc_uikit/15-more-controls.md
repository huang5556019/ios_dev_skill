# 更多常用控件

> 🎛️ 补充控件完整指南

---

## UISwitch 开关

### 基础用法

```objc
// 创建开关
UISwitch *switchControl = [[UISwitch alloc] init];
switchControl.on = YES;
switchControl.onTintColor = [UIColor systemGreenColor];
[switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

// 处理变化
- (void)switchChanged:(UISwitch *)sender {
    NSLog(@"开关状态：%@", sender.on ? @"开" : @"关");
}
```

### 自定义样式

```objc
// 关闭时背景色
switchControl.onTintColor = [UIColor systemGreenColor];    // 开启时
switchControl.tintColor = [UIColor grayColor];             // 关闭时
switchControl.thumbTintColor = [UIColor whiteColor];       // 滑块颜色

// iOS 13+ 使用背景色
if (@available(iOS 13.0, *)) {
    switchControl.backgroundColor = [UIColor clearColor];
}
```

---

## UISlider 滑块

### 基础用法

```objc
// 创建滑块
UISlider *slider = [[UISlider alloc] init];
slider.minimumValue = 0;
slider.maximumValue = 100;
slider.value = 50;
slider.continuous = YES;  // 拖动时持续触发
[slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

// 处理变化
- (void)sliderChanged:(UISlider *)sender {
    NSLog(@"当前值：%f", sender.value);
}
```

### 自定义外观

```objc
// 轨道颜色
slider.minimumTrackTintColor = [UIColor systemBlueColor];    // 左侧轨道
slider.maximumTrackTintColor = [UIColor grayColor];          // 右侧轨道

// 滑块图片
[slider setThumbImage:[UIImage systemImageNamed:@"circle.fill"] forState:UIControlStateNormal];
[slider setThumbImage:[UIImage systemImageNamed:@"circle.fill"] forState:UIControlStateHighlighted];

// 轨道图片
[slider setMinimumTrackImage:[UIImage image] forState:UIControlStateNormal];
[slider setMaximumTrackImage:[UIImage image] forState:UIControlStateNormal];
```

### 步进值

```objc
@property (nonatomic, assign) float stepValue;

- (void)viewDidLoad {
    self.stepValue = 5.0;
}

- (void)sliderChanged:(UISlider *)sender {
    float roundedValue = roundf(sender.value / self.stepValue) * self.stepValue;
    [sender setValue:roundedValue animated:YES];
    NSLog(@"步进值：%f", roundedValue);
}
```

---

## UIStepper 步进器

### 基础用法

```objc
// 创建步进器
UIStepper *stepper = [[UIStepper alloc] init];
stepper.minimumValue = 0;
stepper.maximumValue = 100;
stepper.stepValue = 1;
stepper.value = 50;
stepper.wraps = NO;  // 是否循环
[stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];

// 处理变化
- (void)stepperChanged:(UIStepper *)sender {
    NSLog(@"步进值：%f", sender.value);
}
```

### 自定义样式

```objc
// 背景色
stepper.backgroundColor = [UIColor systemBlueColor];

// 按钮图片
[stepper setDecrementImage:[UIImage systemImageNamed:@"minus"] forState:UIControlStateNormal];
[stepper setIncrementImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];

// 禁用状态
[stepper setDecrementImage:[UIImage systemImageNamed:@"minus"] forState:UIControlStateDisabled];
[stepper setIncrementImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateDisabled];
```

---

## UIProgressView 进度条

### 基础用法

```objc
// 默认样式
UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
progressView.progress = 0.5;
progressView.trackTintColor = [UIColor grayColor];
progressView.progressTintColor = [UIColor systemBlueColor];
```

### 条形样式

```objc
// 条形进度条
UIProgressView *barProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
barProgress.progress = 0.75;
barProgress.progressImage = [UIImage imageNamed:@"progress_fill"];
barProgress.trackImage = [UIImage imageNamed:@"progress_track"];
```

### 动画更新

```objc
- (void)updateProgress:(float)value {
    [UIView animateWithDuration:0.3 animations:^{
        [self.progressView setProgress:value animated:YES];
    }];
}

// 带回调
[self.progressView setProgress:0.8 animated:YES];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSLog(@"进度更新完成");
});
```

---

## UIActivityIndicatorView 活动指示器

### 基础用法

```objc
// 创建指示器
UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithStyle:UIActivityIndicatorViewStyleLarge];
[activityIndicator startAnimating];
activityIndicator.hidesWhenStopped = YES;
[self.view addSubview:activityIndicator];

// 停止
[activityIndicator stopAnimating];
```

### 样式类型

```objc
// 大尺寸
UIActivityIndicatorView *largeIndicator = [[UIActivityIndicatorView alloc] initWithStyle:UIActivityIndicatorViewStyleLarge];

// 中等尺寸
UIActivityIndicatorView *mediumIndicator = [[UIActivityIndicatorView alloc] initWithStyle:UIActivityIndicatorViewStyleMedium];

// 自定义颜色
activityIndicator.color = [UIColor systemBlueColor];
```

### 在网络请求中使用

```objc
@interface NetworkViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupActivityIndicator];
}

- (void)setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithStyle:UIActivityIndicatorViewStyleLarge];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
}

- (void)fetchData {
    [self.activityIndicator startAnimating];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            // 处理数据
        });
    }];
    [task resume];
}

@end
```

---

## UISegmentedControl 分段控制器

### 基础用法

```objc
// 创建分段控制器
UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"选项 1", @"选项 2", @"选项 3"]];
segmentControl.selectedSegmentIndex = 0;
[segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];

// 处理变化
- (void)segmentChanged:(UISegmentedControl *)sender {
    NSLog(@"选中索引：%ld", (long)sender.selectedSegmentIndex);
    NSLog(@"选中标题：%@", [sender titleForSegmentAtIndex:sender.selectedSegmentIndex] ?: @"");
}
```

### 添加/移除分段

```objc
// 插入分段
[segmentControl insertSegmentWithTitle:@"新选项" atIndex:1 animated:YES];

// 移除分段
[segmentControl removeSegmentAtIndex:1 animated:YES];

// 移除所有
[segmentControl removeAllSegments];
```

### 自定义样式

```objc
// 选中颜色
segmentControl.selectedSegmentTintColor = [UIColor systemBlueColor];

// 标题颜色
[segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
[segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} forState:UIControlStateNormal];

// 图片分段
[segmentControl insertSegmentWithImage:[UIImage systemImageNamed:@"house"] atIndex:0 animated:YES];

// 禁用分段
[segmentControl setEnabled:NO forSegmentAtIndex:2];
```

---

## UIDatePicker 日期选择器

### 基础用法

```objc
// 创建日期选择器
UIDatePicker *datePicker = [[UIDatePicker alloc] init];
datePicker.datePickerMode = UIDatePickerModeDateAndTime;
if (@available(iOS 14.0, *)) {
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;  // 或 .inline, .compact
}
[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

// 处理变化
- (void)dateChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSLog(@"选中日期：%@", [formatter stringFromDate:sender.date]);
}
```

### 日期模式

```objc
// 日期和时间
datePicker.datePickerMode = UIDatePickerModeDateAndTime;

// 仅日期
datePicker.datePickerMode = UIDatePickerModeDate;

// 仅时间
datePicker.datePickerMode = UIDatePickerModeTime;

// 倒计时
datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
```

### 设置范围

```objc
// 最小日期
NSDate *minDate = [[NSDate date] dateByAddingTimeInterval:-30 * 24 * 60 * 60];
datePicker.minimumDate = minDate;

// 最大日期
NSDate *maxDate = [[NSDate date] dateByAddingTimeInterval:30 * 24 * 60 * 60];
datePicker.maximumDate = maxDate;

// 选中日期
datePicker.date = [NSDate date];

// 倒计时间隔
datePicker.countDownDuration = 3600;  // 1 小时
```

### 在 Popover 中显示（iPad）

```objc
@available(iOS 14.0, *)
- (void)showDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.preferredDatePickerStyle = UIDatePickerStyleInline;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择日期" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    popover.sourceView = self.showDatePickerButton;
    popover.sourceRect = self.showDatePickerButton.bounds;
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
```

---

## UIPickerView 选择器

### 基础用法

```objc
@interface MyViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSString *> *fruits;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fruits = @[@"苹果", @"香蕉", @"橙子", @"葡萄", @"西瓜"];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
}

// 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.fruits.count;
}

// 代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.fruits[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"选中：%@", self.fruits[row]);
}

@end
```

### 多列选择器

```objc
@property (nonatomic, strong) NSArray<NSString *> *provinces;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *cities;

- (void)viewDidLoad {
    self.provinces = @[@"广东", @"浙江", @"江苏"];
    self.cities = @[
        @[@"广州", @"深圳", @"珠海"],
        @[@"杭州", @"宁波", @"温州"],
        @[@"南京", @"苏州", @"无锡"]
    ];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;  // 省和市两列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    } else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        return self.cities[provinceIndex].count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces[row];
    } else {
        NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
        return self.cities[provinceIndex][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 当省改变时，刷新市列
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
}
```

### 自定义视图

```objc
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.text = self.fruits[row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    label.textColor = [UIColor labelColor];
    return label;
}
```

---

## UIAlertController 警报控制器

### 基础用法

```objc
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" 
                                                               message:@"这是一个警报" 
                                                        preferredStyle:UIAlertControllerStyleAlert];

// 添加操作
[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    NSLog(@"点击了确定");
}]];

[self presentViewController:alert animated:YES completion:nil];
```

### 样式类型

```objc
// 警报样式（居中显示）
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"消息" preferredStyle:UIAlertControllerStyleAlert];

// 动作表样式（从底部弹出）
UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择" message:@"请选择操作" preferredStyle:UIAlertControllerStyleActionSheet];
```

### 添加文本输入框

```objc
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];

[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"请输入...";
    textField.keyboardType = UIKeyboardTypeEmailAddress;
}];

[alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    NSString *text = alert.textFields.firstObject.text;
    NSLog(@"输入内容：%@", text);
}]];

[self presentViewController:alert animated:YES completion:nil];
```

### 多个输入框

```objc
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录" message:nil preferredStyle:UIAlertControllerStyleAlert];

[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"用户名";
}];

[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"密码";
    textField.secureTextEntry = YES;
}];

[alert addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    NSString *username = alert.textFields[0].text;
    NSString *password = alert.textFields[1].text;
    // 处理登录
}]];
```

---

## UIRefreshControl 刷新控件

### 基础用法

```objc
UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
[refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
self.tableView.refreshControl = refreshControl;

- (void)refreshData:(UIRefreshControl *)sender {
    // 刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender endRefreshing];
    });
}
```

### 自定义样式

```objc
if (@available(iOS 13.0, *)) {
    refreshControl.tintColor = [UIColor systemBlueColor];
    refreshControl.backgroundColor = [UIColor systemBackgroundColor];
}

// 设置属性文本
refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
```

### 手动触发刷新

```objc
- (void)triggerRefresh {
    [self.refreshControl beginRefreshing];
    self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    [self refreshData:self.refreshControl];
}
```

---

## UISearchBar 搜索栏

### 基础用法

```objc
@interface SearchViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索...";
    self.searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchBar];
}

// 开始搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"搜索内容：%@", searchBar.text ?: @"");
    [searchBar resignFirstResponder];
}

// 文本变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"搜索文本变化：%@", searchText);
}

// 取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
```

### 自定义样式

```objc
// 背景色
searchBar.barTintColor = [UIColor systemBlueColor];

// 文字颜色
searchBar.searchTextField.textColor = [UIColor whiteColor];
searchBar.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索..." 
                                                                                  attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

// 按钮颜色
searchBar.tintColor = [UIColor whiteColor];
```

---

*最后更新：2026-03-03*
