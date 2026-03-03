# iOS UIKit 开发助手 Skill

> 🛠️ 专业的 iOS UIKit 开发支持与代码生成（Objective-C 版）

---

## Skill 描述

本 Skill 提供完整的 iOS UIKit 开发支持，包括：
- 代码生成与示例（Objective-C）
- 最佳实践建议
- 问题排查与调试
- 架构设计指导

---

## 能力范围

### ✅ 可以协助的内容

1. **UI 组件使用**
   - UIView、UIViewController 生命周期
   - 常用控件（UIButton、UILabel、UITextField 等）
   - 列表组件（UITableView、UICollectionView）
   - 导航组件（UINavigationController、UITabBarController）

2. **布局系统**
   - Auto Layout 约束编写
   - UIStackView 堆栈布局
   - Safe Area 安全区域适配
   - 多屏幕适配方案

3. **交互与动画**
   - 手势识别（UIGestureRecognizer）
   - 触摸事件处理（UIResponder）
   - UIView 动画
   - 视图控制器转场

4. **架构模式**
   - MVC 架构实现
   - 自定义控件封装
   - 组件化设计
   - 代码组织与重构

5. **性能优化**
   - 列表性能优化
   - 内存管理
   - 渲染优化
   - 启动优化

### ❌ 不支持的内容

- SwiftUI 开发（专注 UIKit）
- Swift 语言支持（仅 Objective-C）
- 后端服务开发
- 第三方库的具体使用（可提供通用建议）
- App Store 上架流程

---

## 使用方式

### 1. 代码生成

**用户提问：**
```
帮我写一个自定义的圆角按钮，带阴影效果
```

**助手响应：**
```objc
@interface RoundedShadowButton : UIButton

@property (nonatomic, strong) UIColor *buttonColor;

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color;

@end

@implementation RoundedShadowButton

- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _buttonColor = color ?: [UIColor systemBlueColor];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = _buttonColor;
        
        // 圆角
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
        // 阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 4;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.heightAnchor constraintEqualToConstant:50]
        ]];
    }
    return self;
}

// 点击反馈
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = highlighted ? 0.7 : 1.0;
    }];
}

@end
```

---

### 2. 问题排查

**用户提问：**
```
我的 TableView 不显示数据，可能是什么原因？
```

**助手响应：**
```
请检查以下几点：

1. ✅ 数据源是否设置
   tableView.dataSource = self;

2. ✅ 是否注册了 Cell
   [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

3. ✅ 是否实现了数据源方法
   - (NSInteger)tableView:(UITableView *)tableView 
     numberOfRowsInSection:(NSInteger)section {
       return self.items.count;  // 确保返回正确的数量
   }

4. ✅ cellForRowAt 是否正确
   - (UITableViewCell *)tableView:(UITableView *)tableView 
            cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" 
                                                               forIndexPath:indexPath];
       cell.textLabel.text = self.items[indexPath.row];
       return cell;
   }

5. ✅ 数据是否为空
   NSLog(@"%lu", (unsigned long)self.items.count);  // 检查数据源数组

6. ✅ 约束是否正确
   // 确保 tableView 有正确的大小和位置
```

---

### 3. 最佳实践

**用户提问：**
```
如何优雅地处理 ViewController 的生命周期？
```

**助手响应：**
```objc
@interface MyViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray<NSString *> *data;

@end

@implementation MyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 刷新数据、更新 UI
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 启动动画、埋点
    [self startAnalytics];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 保存数据
    [self saveData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 清理资源
    [self cleanup];
}

#pragma mark - Setup

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 配置 UI 组件
}

- (void)setupConstraints {
    // Auto Layout 约束
}

- (void)setupData {
    // 初始化数据
    self.data = [NSMutableArray array];
}

#pragma mark - Memory Management

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    // 清理观察者、通知等
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
```

---

## 代码规范

### 命名规范

```objc
// 类名：大驼峰，带前缀
@interface MyViewController : UIViewController
@end

// 属性/变量：小驼峰
@property (nonatomic, strong) UILabel *titleLabel;

// 方法：小驼峰，动词开头
- (void)fetchData;

// 常量：大写字母 + 下划线
static const NSInteger kMaxItemCount = 100;

// 枚举：NS_ENUM 宏
typedef NS_ENUM(NSInteger, LoadingState) {
    LoadingStateIdle,
    LoadingStateLoading,
    LoadingStateSuccess,
    LoadingStateFailure
};
```

### 注释规范

```objc
#pragma mark - Lifecycle
#pragma mark - Properties
#pragma mark - Public Methods
#pragma mark - Private Methods

/**
 获取用户信息
 
 @param userID 用户 ID
 @return 用户信息对象
 */
- (nullable User *)fetchUserWithID:(NSString *)userID;
```

### 文件组织

```objc
// 1. Imports
#import "MyViewController.h"
#import <UIKit/UIKit.h>

// 2. Private Properties (Class Extension)
@interface MyViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

// 3. Implementation
@implementation MyViewController

#pragma mark - Lifecycle
// 生命周期方法

#pragma mark - Public Methods
// 公开方法

#pragma mark - Private Methods
// 私有方法

@end

// 4. Extensions (Protocol Conformances)
@implementation MyViewController (UITableViewDataSource)
// 代理方法
@end
```

---

## 常用代码片段

### 快速创建约束

```objc
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:parent.topAnchor constant:16],
    [view.leadingAnchor constraintEqualToAnchor:parent.leadingAnchor constant:16],
    [view.trailingAnchor constraintEqualToAnchor:parent.trailingAnchor constant:-16],
    [view.heightAnchor constraintEqualToConstant:50]
]];
```

### 快速创建 Cell

```objc
@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
+ (NSString *)identifier;
- (void)configureWithText:(NSString *)text;

@end

@implementation CustomCell

+ (NSString *)identifier {
    return @"CustomCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style 
              reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_label];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [_label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [_label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [_label.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
}

- (void)configureWithText:(NSString *)text {
    self.label.text = text;
}

@end
```

### 快速网络请求

```objc
- (void)fetchDataWithCompletion:(void(^)(NSData *_Nullable data, NSError *_Nullable error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.example.com/data"];
    if (!url) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"URLErrorDomain" 
                                                 code:-1 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
            completion(nil, error);
        }
        return;
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] 
        dataTaskWithURL:url 
      completionHandler:^(NSData * _Nullable data, 
                          NSURLResponse * _Nullable response, 
                          NSError * _Nullable error) {
        if (error) {
            if (completion) completion(data, error);
            return;
        }
        if (!data) {
            NSError *serverError = [NSError errorWithDomain:@"URLErrorDomain" 
                                                       code:-2 
                                                   userInfo:@{NSLocalizedDescriptionKey: @"No data received"}];
            if (completion) completion(nil, serverError);
            return;
        }
        if (completion) completion(data, nil);
    }];
    [task resume];
}
```

---

## 资源链接

- [官方文档](https://developer.apple.com/documentation/uikit)
- [UIKit 基础](./README.md)
- [UIView](./01-uiview.md)
- [UIViewController](./02-uiviewcontroller.md)
- [常用控件](./10-controls.md)
- [更多控件](./15-more-controls.md)
- [列表与导航](./20-lists-navigation.md)
- [布局系统](./30-layout.md)
- [交互与动画](./40-interaction-animation.md)
- [高级主题](./60-advanced.md)
- [Masonry](./70-masonry.md)
- [Masonry vs 原生](./71-masonry-comparison.md)

---

## 版本信息

- **Skill 版本：** 1.0.0 (Objective-C)
- **支持 iOS：** 13.0+
- **语言：** Objective-C
- **最后更新：** 2026-03-03

---

*本 Skill 基于 Apple 官方文档整理，结合实战经验编写*
