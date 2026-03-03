# UIViewController 视图控制器

> 🎮 管理视图层级的核心控制器

---

## 📌 核心概念

UIViewController 负责管理一组视图及其交互逻辑。它是 MVC 架构中的 Controller 层核心。

**主要职责：**
- 管理视图生命周期
- 处理用户交互
- 协调数据与视图
- 管理子视图控制器

---

## 🔄 生命周期

### 完整生命周期流程

```
init → loadView → viewDidLoad → viewWillAppear → 
viewDidAppear → viewWillDisappear → viewDidDisappear → dealloc
```

### 各阶段详解

```objc
@interface MyViewController : UIViewController

@end

@implementation MyViewController

// 1. 初始化
- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // 初始化数据
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

// 2. 创建视图（通常不需要重写）
- (void)loadView {
    // 自定义创建视图，不使用 Storyboard/XIB
    self.view = [[CustomView alloc] init];
}

// 3. 视图加载完成（最常用）
- (void)viewDidLoad {
    [super viewDidLoad];
    // ✅ 初始化 UI、设置约束、配置数据
    [self setupUI];
    [self setupConstraints];
    [self setupData];
}

// 4. 视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // ✅ 刷新数据、更新 UI 状态
    [self refreshData];
}

// 5. 视图已经出现
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // ✅ 启动动画、开始计时器、埋点
    [self startAnalytics];
}

// 6. 视图即将消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // ✅ 保存数据、停止计时器
    [self saveData];
}

// 7. 视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // ✅ 清理资源、停止动画
    [self cleanup];
}

// 8. 视图将旋转
- (void)viewWillTransitionToSize:(CGSize)size 
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // ✅ 处理屏幕旋转
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // 旋转中的动画
    }];
}

@end
```

---

## 🎯 常用属性

### 视图相关

```objc
// 主视图
@property (nonatomic, strong) UIView *view;

// 是否自动调整大小
@property (nonatomic, assign) BOOL automaticallyAdjustsScrollViewInsets;

// 安全区域 insets
@property (nonatomic, assign) UIEdgeInsets additionalSafeAreaInsets;
```

### 导航相关

```objc
// 导航栏
@property (nonatomic, strong) UINavigationItem *navigationItem;

// 导航控制器
@property (nonatomic, strong, readonly) UINavigationController *navigationController;

// 标签栏
@property (nonatomic, strong) UITabBarItem *tabBarItem;

// 标签栏控制器
@property (nonatomic, strong, readonly) UITabBarController *tabBarController;
```

### 展示相关

```objc
// 标题
@property (nonatomic, copy) NSString *title;

// 导航栏标题
self.navigationItem.title = @"标题";

// 是否隐藏导航栏
[self.navigationController setNavigationBarHidden:YES animated:YES];
```

---

## 🚀 常用方法

### 呈现控制器

```objc
// 模态呈现
DetailViewController *vc = [[DetailViewController alloc] init];
vc.modalPresentationStyle = UIModalPresentationFullScreen; // 或 UIModalPresentationPageSheet, UIModalPresentationFormSheet, UIModalPresentationOverCurrentContext
[self presentViewController:vc animated:YES completion:nil];

// 带回调的呈现
[self presentViewController:vc animated:YES completion:^{
    NSLog(@"呈现完成");
}];
```

### 关闭控制器

```objc
// 关闭自己
[self dismissViewControllerAnimated:YES completion:nil];

// 关闭所有模态控制器
[self dismissViewControllerAnimated:YES completion:^{
    // 可以链式关闭多个
}];
```

### 导航跳转

```objc
// 推入导航栈
[self.navigationController pushViewController:vc animated:YES];

// 弹出
[self.navigationController popViewControllerAnimated:YES];

// 弹到根
[self.navigationController popToRootViewControllerAnimated:YES];

// 弹到指定
[self.navigationController popToViewController:targetVC animated:YES];
```

---

## 👶 子视图控制器

### 添加子控制器

```objc
- (void)addChildViewController:(UIViewController *)child toContainer:(UIView *)container {
    [self addChildViewController:child];
    [container addSubview:child.view];
    [child didMoveToParentViewController:self];
    
    // 设置约束
    child.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [child.view.topAnchor constraintEqualToAnchor:container.topAnchor],
        [child.view.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [child.view.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [child.view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
}
```

### 移除子控制器

```objc
- (void)removeChildViewController:(UIViewController *)child {
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}
```

---

## 📱 容器控制器模式

### 容器视图控制器示例

```objc
typedef NS_ENUM(NSInteger, UIViewPosition) {
    UIViewPositionLeft,
    UIViewPositionRight
};

@interface ContainerViewController ()

@property (nonatomic, strong) MenuViewController *menuVC;
@property (nonatomic, strong) ContentViewController *contentVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self addChild:self.menuVC toParent:self.view position:UIViewPositionLeft];
    [self addChild:self.contentVC toParent:self.view position:UIViewPositionRight];
}

- (void)addChild:(UIViewController *)child toParent:(UIView *)parent position:(UIViewPosition)position {
    [self addChildViewController:child];
    [parent addSubview:child.view];
    [child didMoveToParentViewController:self];
    
    child.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [child.view.topAnchor constraintEqualToAnchor:parent.topAnchor],
        [child.view.bottomAnchor constraintEqualToAnchor:parent.bottomAnchor],
        position == UIViewPositionLeft ?
            [child.view.leadingAnchor constraintEqualToAnchor:parent.leadingAnchor] :
            [child.view.trailingAnchor constraintEqualToAnchor:parent.trailingAnchor],
        [child.view.widthAnchor constraintEqualToAnchor:parent.widthAnchor multiplier:0.5]
    ]];
}

@end
```

---

## 💡 最佳实践

### ✅ 推荐做法

```objc
// 1. 使用单独的 setup 方法组织代码
@interface MyVC : UIViewController
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self setupData];
    [self setupObservers];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupConstraints {
    // 约束代码
}

@end

// 2. 使用懒加载视图
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

// 3. 使用 weak 避免循环引用
@property (nonatomic, weak) id<MyDelegate> delegate;

// 4. 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```

### ❌ 避免做法

```objc
// 1. 避免在 viewDidLoad 之外初始化 UI
// ❌
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UILabel *label = [[UILabel alloc] init]; // 每次都创建新的
}

// 2. 避免忘记调用 super
// ❌
- (void)viewDidLoad {
    // 忘记 [super viewDidLoad]
}
// ✅
- (void)viewDidLoad {
    [super viewDidLoad];
}

// 3. 避免强引用循环
// ❌
self.completion = ^{
    [self doSomething]; // self 强引用
};
// ✅
__weak typeof(self) weakSelf = self;
self.completion = ^{
    [weakSelf doSomething];
};
```

---

## 🔍 调试技巧

```objc
// 1. 打印视图控制器层级
NSLog(@"%@", self.childViewControllers);

// 2. 检查是否被正确移除
- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

// 3. 检测内存泄漏
// 使用 Xcode Memory Graph Debugger
```

---

## 📚 相关文档

- [UIView](./01-uiview.md) - 基础视图
- [UINavigationController](./21-uinavigationcontroller.md) - 导航控制器
- [UITabBarController](./22-uitabbarcontroller.md) - 标签栏控制器
- [动画](./50-animation.md) - 转场动画

---

*最后更新：2026-03-03*
