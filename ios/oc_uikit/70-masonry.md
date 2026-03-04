# Masonry Auto Layout 技能

> 🔧 iOS 最流行的 Auto Layout 第三方封装库

---

## 📚 技能描述

Masonry 是 iOS 开发中最流行的 Auto Layout 第三方封装库，通过简洁的链式语法让约束编写变得优雅高效。

**核心优势：**
- 链式语法，代码简洁
- 支持批量创建约束
- 完善的更新和移除机制
- 社区成熟，文档丰富

---

## 🚀 快速开始

### 安装方式

#### CocoaPods
```ruby
pod 'Masonry'
```

#### Carthage
```ruby
github "SnapKit/Masonry"
```

#### SPM
```objc
// Masonry 主要用于 Objective-C 项目
// Swift 项目推荐使用 SnapKit
```

### 导入
```objc
#import "Masonry.h"
```

---

## 📖 基础用法

### 1. 基础约束

```objc
UIView *redView = [[UIView alloc] init];
redView.backgroundColor = [UIColor redColor];
[self.view addSubview:redView];

[redView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(20);
    make.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.height.equalTo(@100);
}];
```

### 2. 简化写法

```objective-c
// 链式调用
[redView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.height.equalTo(@100);
}];

// 更简洁
[redView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 0, 20));
    make.height.equalTo(@100);
}];
```

### 3. 相对于其他视图

```objective-c
UIView *blueView = [[UIView alloc] init];
blueView.backgroundColor = [UIColor blueColor];
[self.view addSubview:blueView];

[blueView mas_makeConstraints:^(MASConstraintMaker *make) {
    // 在 redView 下方 10px
    make.top.equalTo(redView.mas_bottom).offset(10);
    make.left.equalTo(redView);
    make.right.equalTo(redView);
    make.height.equalTo(@80);
}];
```

### 4. 宽高比例

```objective-c
[redView mas_makeConstraints:^(MASConstraintMaker *make) {
    // 宽度是父视图的 50%
    make.width.equalTo(self.view).multipliedBy(0.5);
    
    // 高宽比 1:1
    make.height.equalTo(redView.mas_width);
    
    // 居中
    make.center.equalTo(self.view);
}];
```

---

## 🔧 常用 API

### 属性缩写

```objective-c
// 完整写法
make.leftMargin.equalTo(view.mas_leftMargin);
make.rightMargin.equalTo(view.mas_rightMargin);
make.topMargin.equalTo(view.mas_topMargin);
make.bottomMargin.equalTo(view.mas_bottomMargin);
make.leadingMargin.equalTo(view.mas_leadingMargin);
make.trailingMargin.equalTo(view.mas_trailingMargin);

// 常用缩写
make.left.top.right.bottom.equalTo(view);
make.edges.equalTo(view);  // 四边
make.size.equalTo(view);   // 宽高
make.center.equalTo(view); // 中心点
make.centerX.equalTo(view);
make.centerY.equalTo(view);
make.baseline.equalTo(view);
```

### 设置数值

```objective-c
// 固定值
make.width.equalTo(@100);
make.height.equalTo(@50);

// 相对于其他视图
make.width.equalTo(otherView);
make.height.equalTo(otherView.mas_height);

// 倍数关系
make.width.equalTo(otherView).multipliedBy(0.5);
make.height.equalTo(otherView).multipliedBy(2.0);

// 偏移量
make.left.equalTo(view).offset(20);
make.right.equalTo(view).offset(-20);
make.top.equalTo(view).offset(10);
make.bottom.equalTo(view).offset(-10);
```

### 优先级

```objective-c
// 设置优先级
make.left.equalTo(view).priority(750);
make.right.equalTo(view).priorityLow();   // 250
make.right.equalTo(view).priorityHigh();  // 750

// 优先级常量
MASPriorityDefaultLow      // 250
MASPriorityDefaultHigh     // 750
MASPriorityRequired        // 1000
```

### 约束更新

```objective-c
// 保存约束引用
@property (nonatomic, strong) MASConstraint *widthConstraint;

// 创建
[self.view mas_makeConstraints:^(MASConstraintMaker *make) {
    self.widthConstraint = make.width.equalTo(@200);
}];

// 更新
[self.widthConstraint mas_updateConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(@300);
}];

// 重新创建（先移除再创建）
[self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(@400);
    make.height.equalTo(@200);
}];
```

### 约束移除

```objective-c
// 移除特定约束
[self.widthConstraint mas_uninstall];

// 移除所有约束
[view mas_removeConstraints];

// 移除从父视图添加的约束
[view mas_removeFromSuperview];
```

---

## 💡 实用示例

### 1. 居中视图

```objective-c
UIView *centerView = [[UIView alloc] init];
centerView.backgroundColor = [UIColor orangeColor];
[self.view addSubview:centerView];

[centerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.size.equalTo(CGSizeMake(120, 120));
}];
```

### 2. 填充父视图

```objective-c
UIView *fullView = [[UIView alloc] init];
fullView.backgroundColor = [UIColor greenColor];
[self.view addSubview:fullView];

[fullView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
}];

// 带边距
[fullView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
}];
```

### 3. 等间距分布

```objective-c
UIView *view1 = [[UIView alloc] init];
UIView *view2 = [[UIView alloc] init];
UIView *view3 = [[UIView alloc] init];

view1.backgroundColor = [UIColor redColor];
view2.backgroundColor = [UIColor greenColor];
view3.backgroundColor = [UIColor blueColor];

[self.view addSubview:view1];
[self.view addSubview:view2];
[self.view addSubview:view3];

// 水平等间距
[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(20);
    make.top.equalTo(self.view).offset(100);
    make.width.height.equalTo(@60);
}];

[view2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(view1.mas_right).offset(20);
    make.top.equalTo(view1);
    make.width.height.equalTo(view1);
}];

[view3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(view2.mas_right).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.top.equalTo(view1);
    make.width.height.equalTo(view1);
}];
```

### 4. 自适应高度

```objective-c
UILabel *label = [[UILabel alloc] init];
label.numberOfLines = 0;
label.text = @"这是一段很长的文本内容，会根据内容自动调整高度...";
[self.view addSubview:label];

[label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    make.top.equalTo(self.view).offset(100);
    // 高度由内容决定，不需要设置
}];
```

### 5. 按钮布局

```objective-c
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
[button setTitle:@"点击" forState:UIControlStateNormal];
[self.view addSubview:button];

[button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-50);
    make.width.equalTo(@200);
    make.height.equalTo(@50);
}];
```

### 6. 图片保持宽高比

```objective-c
UIImageView *imageView = [[UIImageView alloc] init];
imageView.image = [UIImage imageNamed:@"example"];
imageView.contentMode = UIViewContentModeScaleAspectFit;
[self.view addSubview:imageView];

[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(50);
    make.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    // 保持宽高比
    make.height.equalTo(imageView.mas_width).multipliedBy(0.75); // 4:3
}];
```

### 7. 复杂表单布局

```objective-c
// 表单容器
UIView *formContainer = [[UIView alloc] init];
formContainer.backgroundColor = [UIColor whiteColor];
[self.view addSubview:formContainer];

[formContainer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 20, 0, 20));
    make.top.equalTo(self.view).offset(50);
}];

// 表单项
UILabel *titleLabel = [[UILabel alloc] init];
titleLabel.text = @"用户名";
[formContainer addSubview:titleLabel];

UITextField *textField = [[UITextField alloc] init];
textField.borderStyle = UITextBorderStyleRoundedRect;
[formContainer addSubview:textField];

[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.equalTo(formContainer).offset(16);
    make.width.equalTo(@80);
}];

[textField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(titleLabel.mas_right).offset(10);
    make.right.equalTo(formContainer).offset(-16);
    make.top.equalTo(titleLabel);
    make.height.equalTo(@40);
}];
```

---

## Objective-C 扩展

### 常用扩展

```objc
// UIView+CornerRadius.h
@interface UIView (CornerRadius)

- (void)setupCornerRadius:(CGFloat)radius;

@end

// UIView+CornerRadius.m
@implementation UIView (CornerRadius)

- (void)setupCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end

// UIView+Shadow.h
@interface UIView (Shadow)

- (void)setupShadow;
- (void)setupShadowWithColor:(UIColor *)color 
                       offset:(CGSize)offset 
                      opacity:(float)opacity 
                       radius:(CGFloat)radius;

@end

// UIView+Shadow.m
@implementation UIView (Shadow)

- (void)setupShadow {
    [self setupShadowWithColor:[UIColor blackColor] 
                        offset:CGSizeMake(0, 2) 
                       opacity:0.2 
                        radius:4];
}

- (void)setupShadowWithColor:(UIColor *)color 
                       offset:(CGSize)offset 
                      opacity:(float)opacity 
                       radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

@end

// 使用
UIView *view = [[UIView alloc] init];
view.backgroundColor = [UIColor whiteColor];
[view setupCornerRadius:8];
[view setupShadow];

[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
}];
```

### 链式布局扩展

```objc
// UIView+MasonryHelper.h
@interface UIView (MasonryHelper)

- (instancetype)setupConstraintsInParent:(UIView *)parent
                                     top:(NSNumber *)top
                                   left:(NSNumber *)left
                                  right:(NSNumber *)right
                                 bottom:(NSNumber *)bottom
                                  width:(NSNumber *)width
                                 height:(NSNumber *)height;

@end

// UIView+MasonryHelper.m
@implementation UIView (MasonryHelper)

- (instancetype)setupConstraintsInParent:(UIView *)parent
                                     top:(NSNumber *)top
                                   left:(NSNumber *)left
                                  right:(NSNumber *)right
                                 bottom:(NSNumber *)bottom
                                  width:(NSNumber *)width
                                 height:(NSNumber *)height {
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (top) {
            make.top.equalTo(parent).offset(top.floatValue);
        }
        if (left) {
            make.left.equalTo(parent).offset(left.floatValue);
        }
        if (right) {
            make.right.equalTo(parent).offset(-right.floatValue);
        }
        if (bottom) {
            make.bottom.equalTo(parent).offset(-bottom.floatValue);
        }
        if (width) {
            make.width.equalTo(width);
        }
        if (height) {
            make.height.equalTo(height);
        }
    }];
    
    return self;
}

@end

// 使用
UIView *redView = [[UIView alloc] init];
redView.backgroundColor = [UIColor redColor];
[self.view addSubview:redView];
[redView setupConstraintsInParent:self.view top:@50 left:@20 right:@20 height:@100];
```

---

## ⚠️ 常见问题

### 1. 约束冲突

**问题：** 多个约束无法同时满足

**解决：**
```objective-c
// 降低优先级
make.left.equalTo(view).offset(20).priorityLow();

// 检查必要约束是否完整
// 每个视图需要足够的约束来确定位置和大小
```

### 2. 约束不生效

**问题：** 视图没有显示或位置不对

**检查清单：**
```objective-c
// 1. 是否添加了子视图
[self.view addSubview:redView];

// 2. 是否设置了 translatesAutoresizingMaskIntoConstraints
redView.translatesAutoresizingMaskIntoConstraints = NO; // Masonry 会自动设置

// 3. 约束是否完整（水平和垂直方向）
[redView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.top.bottom.equalTo(self.view); // 完整约束
}];
```

### 3. 动态更新约束

```objective-c
// 保存约束
@property (nonatomic, strong) MASConstraint *heightConstraint;

// 创建
[self.view mas_makeConstraints:^(MASConstraintMaker *make) {
    self.heightConstraint = make.height.equalTo(@100);
}];

// 更新
[self.heightConstraint mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@200);
}];

// 或者使用 remake
[self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
    make.height.equalTo(@200);
}];
```

### 4. 在 TableView 中使用

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"Cell"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        cell.textLabel = titleLabel;
    }
    
    return cell;
}
```

---

## 📚 最佳实践

### ✅ 推荐做法

```objective-c
// 1. 使用分类统一管理约束
@interface MyView ()
@property (nonatomic, strong) MASConstraint *widthConstraint;
@end

// 2. 批量创建约束
[views mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.equalTo(@CGSizeMake(100, 100));
    make.edges.equalToSuperview().insets(UIEdgeInsetsMake(10, 10, 10, 10));
}];

// 3. 使用 insets 简化边距
make.edges.equalTo(view).insets(UIEdgeInsetsMake(20, 20, 20, 20));

// 4. 约束更新用 update，重新创建用 remake
[self.heightConstraint mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@200);
}];
```

### ❌ 避免做法

```objective-c
// 1. 避免在循环中创建约束
// ❌
for (int i = 0; i < 10; i++) {
    UIView *view = [[UIView alloc] init];
    [view mas_makeConstraints:...]; // 每次都会创建新约束
}

// ✅
NSMutableArray *views = [NSMutableArray array];
for (int i = 0; i < 10; i++) {
    UIView *view = [[UIView alloc] init];
    [views addObject:view];
}
[views mas_makeConstraints:...]; // 批量创建

// 2. 避免忘记添加到父视图
// ❌
UIView *view = [[UIView alloc] init];
[view mas_makeConstraints:...]; // 不会生效

// ✅
[self.view addSubview:view];
[view mas_makeConstraints:...];

// 3. 避免混用 frame 和约束
// ❌
view.frame = CGRectMake(0, 0, 100, 100);
[view mas_makeConstraints:...];

// ✅
[view mas_makeConstraints:...]; // 只用约束
```

---

## 🔍 调试技巧

### 打印约束

```objective-c
// 打印视图的所有约束
NSLog(@"%@", view.constraints);

// 打印影响布局的约束
NSLog(@"%@", [view constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal]);
```

### 可视化边框

```objective-c
// 调试时添加边框
view.layer.borderColor = [UIColor redColor].CGColor;
view.layer.borderWidth = 1;
```

### 检查约束冲突

```objective-c
// Xcode 控制台会输出详细日志
// 使用 View Debugger 可视化查看
```

---

## 📖 资源链接

- [GitHub 仓库](https://github.com/SnapKit/Masonry)
- [官方文档](https://github.com/SnapKit/Masonry/wiki)
- [Swift 版本 - SnapKit](https://github.com/SnapKit/SnapKit)

---

## 🎯 Skill 能力

### 可以协助的内容

1. **Masonry 约束编写**
   - 基础约束创建
   - 复杂布局实现
   - 约束更新和移除

2. **代码示例生成**
   - 常见布局模式
   - 自定义控件约束
   - TableView/CollectionView 布局

3. **问题排查**
   - 约束冲突解决
   - 布局不生效排查
   - 性能优化建议

4. **最佳实践**
   - 代码组织
   - 约束管理
   - 调试技巧

### 使用示例

**用户提问：**
```
用 Masonry 写一个居中的正方形视图
```

**助手响应：**
```objective-c
UIView *squareView = [[UIView alloc] init];
squareView.backgroundColor = [UIColor redColor];
[self.view addSubview:squareView];

[squareView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.width.equalTo(@150);
    make.height.equalTo(squareView.mas_width); // 保持正方形
}];
```

---

**Skill 版本：** 1.0.0  
**最后更新：** 2026-03-03  
**适用版本：** Masonry 2.0.0+
