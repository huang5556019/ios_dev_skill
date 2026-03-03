# UIWindow 窗口管理

> 🪟 应用程序的根容器

---

## 📌 核心概念

UIWindow 是应用程序的根容器，所有可见的 UI 元素都添加在窗口上。iOS 应用通常只有一个主窗口。

**主要职责：**
- 管理视图层级
- 接收和分发事件
- 控制根视图控制器
- 管理窗口层级和可见性

---

## 🚀 基础用法

### 获取窗口

```objc
// iOS 13+ 通过 SceneDelegate
- (void)scene:(UIScene *)scene 
    willConnectToSession:(UISceneSession *)session 
                 options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) return;
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.rootViewController = [[RootViewController alloc] init];
    [self.window makeKeyAndVisible];
}

// iOS 12 及之前（AppDelegate）
- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[RootViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

// 获取当前窗口
UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
if (window) {
    NSLog(@"窗口大小：%@", NSStringFromCGRect(window.bounds.size));
}

// 获取 key window
UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
if (keyWindow) {
    NSLog(@"当前 key window: %@", keyWindow);
}
```

---

## 🔧 常用属性

### 根视图控制器

```objc
// 设置根控制器
window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[VC1 alloc] init]];

// 获取根控制器
UIViewController *rootVC = window.rootViewController;
if (rootVC) {
    NSLog(@"根控制器：%@", NSStringFromClass([rootVC class]));
}

// 替换根控制器（带动画）
NewViewController *newRootVC = [[NewViewController alloc] init];
[UIView transitionWithView:window
                  duration:0.3
                   options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^{
    window.rootViewController = newRootVC;
} completion:nil];
```

### 窗口层级

```objc
// 正常窗口
window.windowLevel = UIWindowLevelNormal;

// 状态栏层级（高于正常窗口）
window.windowLevel = UIWindowLevelStatusBar;

// 警告层级（最高，用于系统警报）
window.windowLevel = UIWindowLevelAlert;

// 自定义层级
window.windowLevel = 100;
```

### 可见性

```objc
// 显示窗口
window.hidden = NO;
[window makeKeyAndVisible];

// 隐藏窗口
window.hidden = YES;

// 设为 key window
[window makeKey];

// 检查是否 key window
if (window.isKeyWindow) {
    NSLog(@"这是当前接收输入的窗口");
}
```

---

## 🎯 常用方法

### 坐标转换

```objc
// 将点转换到另一个视图/窗口
CGPoint pointInWindow = [view convertPoint:point toView:window];
CGPoint pointInView = [window convertPoint:point fromView:view];

// 获取触摸位置
UITouch *touch = event.allTouches.firstObject;
if (touch) {
    CGPoint locationInWindow = [touch locationInView:window];
    CGPoint locationInView = [touch locationInView:view];
}
```

### 视图层级管理

```objc
// 添加视图到窗口
[window addSubview:overlayView];

// 获取所有子视图
NSArray *subviews = window.subviews;
for (UIView *subview in subviews) {
    NSLog(@"子视图：%@", subview);
}

// 将视图带到最前
if (overlayView) {
    [window bringSubviewToFront:overlayView];
}
```

### 获取视图控制器

```objc
// UIView 分类获取所在视图控制器
@interface UIView (ViewController)
@property (nonatomic, readonly, nullable) UIViewController *viewController;
@end

@implementation UIView (ViewController)
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (responder.nextResponder) {
        responder = responder.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
@end

// 使用
UIViewController *vc = overlayView.viewController;
if (vc) {
    NSLog(@"视图所属控制器：%@", vc);
}
```

---

## 🎨 多窗口支持（iPad）

### 创建新窗口

```objc
@available(iOS 13.0, *)
- (void)createNewWindow {
    NSArray *scenes = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    if (!windowScene) return;
    
    UIWindow *newWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
    newWindow.rootViewController = [[ViewController alloc] init];
    newWindow.windowLevel = UIWindowLevelNormal;
    [newWindow makeKeyAndVisible];
    
    // 保存引用
    [self.windows addObject:newWindow];
}
```

### 管理多个窗口

```objc
@interface WindowManager : NSObject

@property (nonatomic, strong) NSMutableArray<UIWindow *> *windows;
+ (instancetype)shared;
- (UIWindow *)createAuxiliaryWindow;
- (void)closeAllAuxiliaryWindows;

@end

@implementation WindowManager

+ (instancetype)shared {
    static WindowManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _windows = [NSMutableArray array];
    }
    return self;
}

// 创建辅助窗口
- (UIWindow *)createAuxiliaryWindow {
    NSArray *scenes = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *scene = nil;
    for (UIScene *s in scenes) {
        if ([s isKindOfClass:[UIWindowScene class]]) {
            scene = (UIWindowScene *)s;
            break;
        }
    }
    if (!scene) return nil;
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:scene];
    window.windowLevel = UIWindowLevelNormal + 1;
    window.rootViewController = [[AuxiliaryViewController alloc] init];
    [window makeKeyAndVisible];
    
    [self.windows addObject:window];
    return window;
}

// 关闭所有辅助窗口
- (void)closeAllAuxiliaryWindows {
    for (UIWindow *window in self.windows) {
        window.hidden = YES;
    }
    [self.windows removeAllObjects];
}

@end
```

---

## 💡 实用场景

### 1. 全局浮层

```objc
@interface OverlayManager : NSObject

@property (nonatomic, strong) UIWindow *overlayWindow;
+ (instancetype)shared;
- (void)showOverlay;
- (void)hideOverlay;

@end

@implementation OverlayManager

+ (instancetype)shared {
    static OverlayManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showOverlay {
    NSArray *scenes = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    if (!windowScene) return;
    
    self.overlayWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.overlayWindow.windowLevel = UIWindowLevelNormal + 1;
    
    OverlayViewController *overlayVC = [[OverlayViewController alloc] init];
    overlayVC.overlayManager = self;
    self.overlayWindow.rootViewController = overlayVC;
    [self.overlayWindow makeKeyAndVisible];
}

- (void)hideOverlay {
    self.overlayWindow.hidden = YES;
    self.overlayWindow = nil;
}

@end
```

### 2. 启动页

```objc
@interface LaunchScreenManager : NSObject

@property (nonatomic, strong) UIWindow *launchWindow;
+ (instancetype)shared;
- (void)showLaunchScreen;
- (void)hideLaunchScreen;

@end

@implementation LaunchScreenManager

+ (instancetype)shared {
    static LaunchScreenManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)showLaunchScreen {
    NSArray *scenes = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *windowScene = nil;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    if (!windowScene) return;
    
    self.launchWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.launchWindow.windowLevel = UIWindowLevelNormal + 2;
    
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    launchVC.completion = ^{
        [weakSelf hideLaunchScreen];
    };
    
    self.launchWindow.rootViewController = launchVC;
    [self.launchWindow makeKeyAndVisible];
}

- (void)hideLaunchScreen {
    [UIView animateWithDuration:0.3 animations:^{
        self.launchWindow.alpha = 0;
    } completion:^(BOOL finished) {
        self.launchWindow.hidden = YES;
        self.launchWindow = nil;
    }];
}

@end
```

### 3. 全局提示

```swift
class ToastManager {
    static let shared = ToastManager()
    private var toastWindow: UIWindow?
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first else { return }
        
        toastWindow = UIWindow(windowScene: windowScene)
        toastWindow?.windowLevel = .alert - 1
        toastWindow?.backgroundColor = .clear
        
        let toastVC = ToastViewController(message: message)
        toastWindow?.rootViewController = toastVC
        toastWindow?.makeKeyAndVisible()
        
        // 自动消失
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.hideToast()
        }
    }
    
    private func hideToast() {
        UIView.animate(withDuration: 0.3, animations: {
            self.toastWindow?.alpha = 0
        }) { _ in
            self.toastWindow?.isHidden = true
            self.toastWindow = nil
        }
    }
}
```

### 4. 截屏检测

```swift
class ScreenshotDetector {
    static let shared = ScreenshotDetector()
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
    }
    
    @objc private func handleScreenshot() {
        print("用户截屏了！")
        // 可以显示提示或记录日志
    }
}
```

---

## 🔍 调试技巧

### 打印窗口层级

```swift
func printWindowHierarchy() {
    let windows = UIApplication.shared.windows
    print("=== 窗口层级 ===")
    for (index, window) in windows.enumerated() {
        print("窗口 \(index):")
        print("  - 层级：\(window.windowLevel)")
        print("  - 大小：\(window.bounds.size)")
        print("  - 是否 Key: \(window.isKeyWindow)")
        print("  - 根控制器：\(type(of: window.rootViewController))")
        print("  - 子视图数量：\(window.subviews.count)")
    }
}
```

### 可视化窗口边框

```swift
func debugWindowBorders() {
    UIApplication.shared.windows.forEach { window in
        window.subviews.forEach { subview in
            subview.layer.borderColor = UIColor.red.cgColor
            subview.layer.borderWidth = 1
        }
    }
}
```

---

## ⚠️ 注意事项

### 内存管理

```swift
// ❌ 避免循环引用
class BadViewController: UIViewController {
    var window: UIWindow?  // 强引用可能导致泄漏
}

// ✅ 使用 weak
class GoodViewController: UIViewController {
    weak var window: UIWindow?
}
```

### 多场景支持

```swift
// iOS 13+ 支持多场景，不要假设只有一个窗口
@available(iOS 13.0, *)
func getKeyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
        .flatMap { $0.keyWindow }
}
```

---

## 📚 相关文档

- [UIView](./01-uiview.md) - 基础视图
- [UIViewController](./02-uiviewcontroller.md) - 视图控制器
- [Skill 封装](./skill.md) - 开发助手 Skill

---

*最后更新：2026-03-03*
