# UIKit 开发技能文档

> 📱 iOS 界面开发核心框架完整指南

---

## 📚 目录索引

### 基础核心
- [UIView 基础视图](./01-uiview.md)
- [UIViewController 视图控制器](./02-uiviewcontroller.md)
- [UIWindow 窗口管理](./03-uiwindow.md)

### 常用控件
- [UIButton 按钮](./10-uibutton.md)
- [UILabel 标签](./11-uilabel.md)
- [UITextField 文本输入](./12-uitextfield.md)
- [UITextView 富文本](./13-uitextview.md)
- [UIImageView 图片视图](./14-uiimageview.md)
- [UIScrollView 滚动视图](./15-uiscrollview.md)

### 列表与导航
- [UITableView 表格视图](./20-uitableview.md)
- [UICollectionView 集合视图](./21-uicollectionview.md)
- [UINavigationController 导航控制器](./21-uinavigationcontroller.md)
- [UITabBarController 标签栏](./22-uitabbarcontroller.md)

### 布局系统
- [Auto Layout 自动布局](./30-autolayout.md)
- [UIStackView 堆栈视图](./31-uistackview.md)
- [Safe Area 安全区域](./32-safearea.md)

### 交互与事件
- [UIGestureRecognizer 手势识别](./40-gesture.md)
- [UIResponder 响应链](./41-responder.md)
- [Touch 事件处理](./42-touch.md)

### 动画与过渡
- [UIView 动画](./50-animation.md)
- [UIViewController 转场](./51-transition.md)
- [Lottie 动画支持](./52-lottie.md)

### 高级主题
- [自定义控件与性能优化](./60-advanced.md)
- [Masonry Auto Layout](./70-masonry.md)

---

## 🚀 快速开始

### 创建第一个 UIKit 项目

```objc
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hello, UIKit!";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

@end
```

### 项目结构建议

```
MyApp/
├── AppDelegate.h/m
├── SceneDelegate.h/m
├── Views/           # 自定义视图
├── ViewControllers/ # 视图控制器
├── Models/          # 数据模型
├── Utils/           # 工具类
└── Resources/       # 资源文件
```

---

## 📖 使用说明

本文档作为 iOS UIKit 开发技能参考，适用于：
- iOS 应用开发者（Objective-C）
- 需要维护旧项目的开发者
- 偏好 Objective-C 的开发者

> 💡 **提示**：配合 Xcode 使用效果更佳，所有代码示例均基于 iOS 15+，使用 Objective-C 语言

---

*文档生成时间：2026-03-03*
*基于 Apple Developer Documentation 整理*
