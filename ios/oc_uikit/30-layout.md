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

```objc
UIView *view = [[UIView alloc] init];
view.translatesAutoresizingMaskIntoConstraints = NO;
[parentView addSubview:view];

// 创建约束
NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:parentView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0];
[parentView addConstraint:constraint];
```

### 锚点 API（推荐）

```objc
UIView *subview = [[UIView alloc] init];
subview.translatesAutoresizingMaskIntoConstraints = NO;
[parentView addSubview:subview];

[NSLayoutConstraint activateConstraints:@[
    // 位置
    [subview.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:20],
    [subview.leadingAnchor constraintEqualToAnchor:parentView.leadingAnchor constant:16],
    [subview.trailingAnchor constraintEqualToAnchor:parentView.trailingAnchor constant:-16],
    [subview.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-20],
    
    // 中心
    [subview.centerXAnchor constraintEqualToAnchor:parentView.centerXAnchor],
    [subview.centerYAnchor constraintEqualToAnchor:parentView.centerYAnchor],
    
    // 尺寸
    [subview.widthAnchor constraintEqualToConstant:200],
    [subview.heightAnchor constraintEqualToConstant:100],
    
    // 比例
    [subview.widthAnchor constraintEqualToAnchor:subview.heightAnchor multiplier:2.0],
    
    // 相对于其他视图
    [subview.topAnchor constraintEqualToAnchor:otherView.bottomAnchor constant:10],
    
    // 安全区域
    [subview.topAnchor constraintEqualToAnchor:parentView.safeAreaLayoutGuide.topAnchor]
]];
```

### 常用锚点

```objc
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

```objc
// 优先级范围：1 (最低) ~ 1000 (最高，必需)
NSLayoutConstraint *constraint = [view.widthAnchor constraintEqualToConstant:200];
constraint.priority = UILayoutPriorityDefaultHigh;    // 750
constraint.priority = UILayoutPriorityDefaultLow;     // 250
constraint.priority = UILayoutPriorityFittingSizeLevel; // 50
constraint.priority = UILayoutPriorityRequired;       // 1000

constraint.active = YES;
```

### 常见布局模式

#### 1. 居中视图

```objc
UIView *centeredView = [[UIView alloc] init];
centeredView.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:centeredView];

[NSLayoutConstraint activateConstraints:@[
    [centeredView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
    [centeredView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
    [centeredView.widthAnchor constraintEqualToConstant:200],
    [centeredView.heightAnchor constraintEqualToConstant:100]
]];
```

#### 2. 边距固定

```objc
UIView *marginView = [[UIView alloc] init];
marginView.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:marginView];

[NSLayoutConstraint activateConstraints:@[
    [marginView.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:16],
    [marginView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
    [marginView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
    [marginView.heightAnchor constraintEqualToConstant:50]
]];
```

#### 3. 宽高比例

```objc
UIView *aspectView = [[UIView alloc] init];
aspectView.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:aspectView];

[NSLayoutConstraint activateConstraints:@[
    [aspectView.widthAnchor constraintEqualToAnchor:view.widthAnchor multiplier:0.5],
    [aspectView.heightAnchor constraintEqualToAnchor:aspectView.widthAnchor multiplier:1.0], // 1:1
    [aspectView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
    [aspectView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
]];
```

#### 4. 等间距分布

```objc
NSArray *views = @[view1, view2, view3];
for (UIView *v in views) {
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:v];
}

[NSLayoutConstraint activateConstraints:@[
    // 顶部对齐
    [view1.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
    [view2.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
    [view3.topAnchor constraintEqualToAnchor:view.topAnchor constant:20],
    
    // 等宽
    [view1.widthAnchor constraintEqualToAnchor:view2.widthAnchor],
    [view2.widthAnchor constraintEqualToAnchor:view3.widthAnchor],
    
    // 左右边距
    [view1.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
    [view3.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
    
    // 等间距
    [view2.leadingAnchor constraintEqualToAnchor:view1.trailingAnchor constant:16],
    [view3.leadingAnchor constraintEqualToAnchor:view2.trailingAnchor constant:16]
]];
```

### 约束更新

```objc
// 保存约束引用
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.widthConstraint = [self.subview.widthAnchor constraintEqualToConstant:200];
    self.widthConstraint.active = YES;
}

// 更新约束
- (void)updateWidth {
    self.widthConstraint.constant = 300;
    
    // 带动画更新
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 激活/停用
self.widthConstraint.active = NO;
NSLayoutConstraint *newConstraint = [self.subview.widthAnchor constraintEqualToConstant:250];
newConstraint.active = YES;
```

### 调试技巧

```objc
// 打印所有约束
NSLog(@"%@", view.constraints);
NSLog(@"%@", [view constraintsAffectingLayoutForAxis:NSLayoutConstraintAxisHorizontal]);

// 可视化
subview.layer.borderColor = [UIColor redColor].CGColor;
subview.layer.borderWidth = 1;

// 检查冲突
// Xcode 会在控制台输出详细的冲突信息
// 使用 "View Debugger" 可视化查看
```

---

## UIStackView 堆栈视图

### 基础用法

```objc
UIStackView *stackView = [[UIStackView alloc] init];
stackView.axis = UILayoutConstraintAxisVertical;      // 或 UILayoutConstraintAxisHorizontal
stackView.distribution = UIStackViewDistributionFill;
stackView.alignment = UIStackViewAlignmentFill;
stackView.spacing = 16;
stackView.translatesAutoresizingMaskIntoConstraints = NO;

[view addSubview:stackView];

// 添加子视图
[stackView addArrangedSubview:view1];
[stackView addArrangedSubview:view2];
[stackView addArrangedSubview:view3];

// 约束 stackView
[NSLayoutConstraint activateConstraints:@[
    [stackView.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:20],
    [stackView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
    [stackView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16]
]];
```

### 分布模式

```objc
// .fill - 默认，子视图根据约束填充
stackView.distribution = UIStackViewDistributionFill;

// .fillEqually - 子视图等大小
stackView.distribution = UIStackViewDistributionFillEqually;

// .fillProportionally - 按原始比例填充
stackView.distribution = UIStackViewDistributionFillProportionally;

// .equalSpacing - 等间距
stackView.distribution = UIStackViewDistributionEqualSpacing;

// .equalCentering - 等中心间距
stackView.distribution = UIStackViewDistributionEqualCentering;
```

### 对齐模式

```objc
// .fill - 默认，子视图填充
stackView.alignment = UIStackViewAlignmentFill;

// .leading - 左对齐（垂直）/ 上对齐（水平）
stackView.alignment = UIStackViewAlignmentLeading;

// .trailing - 右对齐（垂直）/ 下对齐（水平）
stackView.alignment = UIStackViewAlignmentTrailing;

// .center - 居中对齐
stackView.alignment = UIStackViewAlignmentCenter;

// .firstBaseline - 第一行基线对齐（文本）
stackView.alignment = UIStackViewAlignmentFirstBaseline;

// .lastBaseline - 最后一行基线对齐（文本）
stackView.alignment = UIStackViewAlignmentLastBaseline;
```

### 嵌套使用

```objc
// 垂直堆栈
UIStackView *verticalStack = [[UIStackView alloc] init];
verticalStack.axis = UILayoutConstraintAxisVertical;
verticalStack.spacing = 20;

// 水平堆栈
UIStackView *horizontalStack = [[UIStackView alloc] init];
horizontalStack.axis = UILayoutConstraintAxisHorizontal;
horizontalStack.spacing = 16;
horizontalStack.distribution = UIStackViewDistributionFillEqually;

// 添加子视图到水平堆栈
[horizontalStack addArrangedSubview:button1];
[horizontalStack addArrangedSubview:button2];
[horizontalStack addArrangedSubview:button3];

// 将水平堆栈添加到垂直堆栈
[verticalStack addArrangedSubview:titleLabel];
[verticalStack addArrangedSubview:descriptionLabel];
[verticalStack addArrangedSubview:horizontalStack];

[view addSubview:verticalStack];
```

### 动态管理

```objc
// 插入子视图
[stackView insertArrangedSubview:newView atIndex:0];

// 移除子视图
[stackView removeArrangedSubview:viewToRemove];
[viewToRemove removeFromSuperview];

// 隐藏子视图
subview.hidden = YES;  // 自动从堆栈中移除空间

// 交换位置
[stackView removeArrangedSubview:view1];
[stackView insertArrangedSubview:view1 atIndex:2];

// 设置自定义间距
[stackView setCustomSpacing:30 afterView:specificView];
```

### 实用示例

#### 1. 表单布局

```objc
- (UIStackView *)createForm {
    UIStackView *formStack = [[UIStackView alloc] init];
    formStack.axis = UILayoutConstraintAxisVertical;
    formStack.spacing = 16;
    
    NSArray *fields = @[
        [self createFieldWithPlaceholder:@"姓名"],
        [self createFieldWithPlaceholder:@"邮箱"],
        [self createFieldWithPlaceholder:@"电话"]
    ];
    
    for (UIStackView *field in fields) {
        [formStack addArrangedSubview:field];
    }
    
    return formStack;
}

- (UIStackView *)createFieldWithPlaceholder:(NSString *)placeholder {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 12;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = placeholder;
    [label.widthAnchor constraintEqualToConstant:60].active = YES;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [stack addArrangedSubview:label];
    [stack addArrangedSubview:textField];
    
    return stack;
}
```

#### 2. 按钮组

```objc
- (UIStackView *)createButtonGroup {
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 12;
    
    NSArray *buttons = @[
        [self createButtonWithTitle:@"取消" color:[UIColor grayColor]],
        [self createButtonWithTitle:@"确认" color:[UIColor systemBlueColor]]
    ];
    
    for (UIButton *button in buttons) {
        [stack addArrangedSubview:button];
    }
    
    return stack;
}

- (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = color;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    [button.heightAnchor constraintEqualToConstant:44].active = YES;
    return button;
}
```

#### 3. 自适应卡片

```objc
- (UIStackView *)createCardView {
    UIStackView *cardStack = [[UIStackView alloc] init];
    cardStack.axis = UILayoutConstraintAxisVertical;
    cardStack.spacing = 12;
    cardStack.backgroundColor = [UIColor whiteColor];
    cardStack.layer.cornerRadius = 12;
    cardStack.clipsToBounds = YES;
    cardStack.layoutMarginsRelativeArrangement = YES;
    cardStack.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(16, 16, 16, 16);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"photo"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 8;
    [imageView.heightAnchor constraintEqualToConstant:150].active = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"标题";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"副标题描述";
    subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.numberOfLines = 0;
    
    [cardStack addArrangedSubview:imageView];
    [cardStack addArrangedSubview:titleLabel];
    [cardStack addArrangedSubview:subtitleLabel];
    
    return cardStack;
}
```

---

## Safe Area 安全区域

### 基础概念

Safe Area 是屏幕上不会被导航栏、标签栏、刘海等遮挡的区域。

### 使用方法

```objc
// 相对于安全区域布局
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor],
    [view.leadingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.leadingAnchor],
    [view.trailingAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.trailingAnchor],
    [view.bottomAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.bottomAnchor]
]];

// 获取安全区域 insets
UIEdgeInsets safeInsets = view.safeAreaInsets;
NSLog(@"顶部：%f", safeInsets.top);    // 刘海/导航栏高度
NSLog(@"底部：%f", safeInsets.bottom); // 底部指示条高度
```

### 扩展安全区域

```objc
// 自定义扩展
self.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);

// 子视图控制器会自动考虑父视图的安全区域
```

### 适配不同设备

```objc
// 检查是否有刘海
BOOL hasNotch = self.view.safeAreaInsets.top > 20;
NSLog(@"有刘海：%d", hasNotch);

// 底部指示条
BOOL hasHomeIndicator = self.view.safeAreaInsets.bottom > 0;
```

---

## 常见布局问题

### 1. 约束冲突

**问题：** 多个约束无法同时满足

**解决：**
```objc
// 降低优先级
constraint.priority = UILayoutPriorityDefaultHigh;  // 750 而不是 1000

// 检查必要的约束是否完整
// 每个视图需要足够的约束来确定位置和大小
```

### 2. 模糊约束

**问题：** 约束不足，视图位置或大小不确定

**解决：**
```objc
// 确保水平和垂直方向都有完整约束
// 水平：leading + trailing 或 centerX + width
// 垂直：top + bottom 或 centerY + height
```

### 3. 性能问题

**问题：** 大量约束导致布局缓慢

**解决：**
```objc
// 使用 UIStackView 简化布局
// 批量更新约束
[UIView performWithoutAnimation:^{
    // 更新多个约束
    [self.view layoutIfNeeded];
}];
```

---

*最后更新：2026-03-03*
