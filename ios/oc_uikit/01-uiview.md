# UIView 基础视图

> 🎯 所有 UI 组件的基类

---

## 📌 核心概念

UIView 是 iOS 中所有可见 UI 元素的基类。它负责：
- 渲染内容到屏幕
- 处理触摸和事件
- 管理子视图层级
- 支持动画和变换

---

## 🔧 常用属性

### 外观属性

```objc
// 背景颜色
view.backgroundColor = [UIColor systemBlueColor];

// 圆角
view.layer.cornerRadius = 8;
view.layer.masksToBounds = YES;

// 边框
view.layer.borderWidth = 1;
view.layer.borderColor = [UIColor grayColor].CGColor;

// 阴影
view.layer.shadowColor = [UIColor blackColor].CGColor;
view.layer.shadowOffset = CGSizeMake(0, 2);
view.layer.shadowOpacity = 0.3;
view.layer.shadowRadius = 4;
```

### 布局属性

```objc
// 框架（父坐标系）
view.frame = CGRectMake(0, 0, 100, 100);

// 边界（自身坐标系）
view.bounds = CGRectMake(0, 0, 100, 100);

// 中心点（父坐标系）
view.center = CGPointMake(50, 50);

// 自动调整掩码（旧式布局）
view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
```

### 层级管理

```objc
// 添加子视图
[parentView addSubview:childView];

// 移除子视图
[childView removeFromSuperview];

// 交换位置
[view bringSubviewToFront:subview];
[view sendSubviewToBack:subview];

// 获取所有子视图
NSArray *subviews = view.subviews;
```

---

## 🎨 常用方法

### 绘制与更新

```objc
// 标记需要重绘
[view setNeedsDisplay];

// 立即重绘
[view setNeedsDisplay];
[view layoutIfNeeded];

// 自定义绘制（子类重写）
- (void)drawRect:(CGRect)rect {
    // 使用 Core Graphics 绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, rect);
}
```

### 布局

```objc
// 标记需要布局
[view setNeedsLayout];

// 立即布局
[view layoutIfNeeded];

// 子视图布局完成回调（子类重写）
- (void)layoutSubviews {
    [super layoutSubviews];
    // 自定义布局逻辑
}
```

### 坐标转换

```objc
// 转换点到另一个视图
CGPoint point = [view convertPoint:CGPointMake(10, 10) toView:otherView];

// 转换矩形
CGRect rect = [view convertRect:bounds toView:superview];
```

---

## 🎬 动画支持

### 基础动画

```objc
[UIView animateWithDuration:0.3 animations:^{
    view.alpha = 0.5;
    view.transform = CGAffineTransformMakeScale(0.9, 0.9);
} completion:^(BOOL finished) {
    NSLog(@"动画完成");
}];
```

### 链式动画

```objc
[UIView animateWithDuration:0.3 animations:^{
    view.alpha = 0.5;
} completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1.0;
    }];
}];
```

### 弹簧动画

```objc
[UIView animateWithDuration:0.5 
                      delay:0 
            usingSpringWithDamping:0.6 
             initialSpringVelocity:0.5 
                          options:0 
                       animations:^{
    view.transform = CGAffineTransformIdentity;
} completion:nil];
```

---

## 💡 最佳实践

### ✅ 推荐做法

```objc
// 1. 使用 translatesAutoresizingMaskIntoConstraints = NO 进行 Auto Layout
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
button.translatesAutoresizingMaskIntoConstraints = NO;
[view addSubview:button];
[NSLayoutConstraint activateConstraints:@[
    [button.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
    [button.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
]];

// 2. 使用 weak 避免循环引用
__weak typeof(view) weakView = view;

// 3. 批量更新布局
[UIView performWithoutAnimation:^{
    // 不带动画的布局更新
}];
```

### ❌ 避免做法

```objc
// 1. 避免在 loop 中频繁调用 layoutIfNeeded
// ❌
for (UIView *subview in subviews) {
    [subview layoutIfNeeded];
}
// ✅
[view layoutIfNeeded];

// 2. 避免直接使用 frame 进行 Auto Layout 视图的布局
// ❌
view.frame = CGRectMake(...);
// ✅
view.translatesAutoresizingMaskIntoConstraints = NO;
```

---

## 🔍 调试技巧

```objc
// 打印视图层级
NSLog(@"%@", [view performSelector:@selector(debugDescription)]);

// 可视化边界
view.layer.borderColor = [UIColor redColor].CGColor;
view.layer.borderWidth = 1;

// 检查约束冲突
// Xcode 控制台会输出详细日志
```

---

## 📚 相关文档

- [UIViewController](./02-uiviewcontroller.md) - 视图控制器
- [Auto Layout](./30-autolayout.md) - 自动布局系统
- [动画](./50-animation.md) - UIView 动画

---

*最后更新：2026-03-03*
