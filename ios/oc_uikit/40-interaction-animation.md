# 交互与动画

> ✨ 手势识别、响应链与动画系统

---

## UIGestureRecognizer 手势识别

### 基础用法

```objc
// 创建手势
UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
tapGesture.numberOfTapsRequired = 1;
tapGesture.numberOfTouchesRequired = 1;
[view addGestureRecognizer:tapGesture];

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:view];
    NSLog(@"点击位置：%@", NSStringFromCGPoint(location));
}
```

### 常用手势类型

#### 1. 点击手势

```objc
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
tap.numberOfTapsRequired = 2;  // 双击
tap.numberOfTouchesRequired = 2; // 双指
[view addGestureRecognizer:tap];

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"点击完成");
    }
}
```

#### 2. 长按手势

```objc
UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
longPress.minimumPressDuration = 0.5;  // 长按时间
longPress.allowableMovement = 10;      // 允许移动距离
[view addGestureRecognizer:longPress];

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"长按开始");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"长按移动");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"长按结束");
            break;
        default:
            break;
    }
}
```

#### 3. 滑动手势

```objc
UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
[view addGestureRecognizer:swipeLeft];

UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
[view addGestureRecognizer:swipeRight];

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"左滑");
            break;
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"右滑");
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"上滑");
            break;
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"下滑");
            break;
        default:
            break;
    }
}
```

#### 4. 拖动手势

```objc
UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
[view addGestureRecognizer:pan];

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:view];
    CGPoint velocity = [gesture velocityInView:view];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"拖动开始");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"拖动中：%@", NSStringFromCGPoint(translation));
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"拖动结束，速度：%@", NSStringFromCGPoint(velocity));
            break;
        default:
            break;
    }
}
```

#### 5. 捏合手势（缩放）

```objc
UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
[view addGestureRecognizer:pinch];

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    CGFloat scale = gesture.scale;
    CGFloat velocity = gesture.velocity;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"捏合开始");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"缩放比例：%f", scale);
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"捏合结束");
            break;
        default:
            break;
    }
}
```

#### 6. 旋转手势

```objc
UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
[view addGestureRecognizer:rotation];

- (void)handleRotation:(UIRotationGestureRecognizer *)gesture {
    CGFloat rotationAngle = gesture.rotation;  // 弧度
    CGFloat velocity = gesture.velocity;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"旋转开始");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"旋转角度：%f°", rotationAngle * 180 / M_PI);
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"旋转结束");
            break;
        default:
            break;
    }
}
```

### 手势冲突处理

```objc
// 要求某个手势必须失败后才执行
[tapGesture requireGestureRecognizerToFail:longPressGesture];

// 允许同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 阻止手势接收触摸
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 可以过滤特定视图
    return touch.view != ignoreView;
}
```

### 自定义手势

```objc
@interface DoubleTapGesture : UIGestureRecognizer

@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DoubleTapGesture

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tapCount += 1;
    
    if (self.tapCount == 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(handleTimer)
                                                    userInfo:nil
                                                     repeats:NO];
    } else if (self.tapCount == 2) {
        [self.timer invalidate];
        self.state = UIGestureRecognizerStateRecognized;
    }
}

- (void)handleTimer {
    self.tapCount = 0;
    self.state = UIGestureRecognizerStateFailed;
}

- (void)reset {
    self.tapCount = 0;
    [self.timer invalidate];
}

@end
```

---

## UIResponder 响应链

### 响应链结构

```
UIView → UIViewController → UIWindow → UIApplication → AppDelegate
```

### 触摸事件处理

```objc
@interface CustomView : UIView
@end

@implementation CustomView

// 触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.firstObject;
    if (touch) {
        CGPoint location = [touch locationInView:self];
        NSLog(@"触摸开始：%@", NSStringFromCGPoint(location));
    }
}

// 触摸移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.firstObject;
    if (touch) {
        CGPoint location = [touch locationInView:self];
        NSLog(@"触摸移动：%@", NSStringFromCGPoint(location));
    }
}

// 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.firstObject;
    if (touch) {
        CGPoint location = [touch locationInView:self];
        NSLog(@"触摸结束：%@", NSStringFromCGPoint(location));
    }
}

// 触摸取消
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"触摸取消");
}

@end
```

### 事件传递

```objc
// 找到触摸的视图
UIView *hitView = [view hitTest:point withEvent:event];

// 阻止事件传递
@interface PassThroughView : UIView
@end

@implementation PassThroughView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 返回 NO 则不接收触摸
    return [super pointInside:point withEvent:event];
}

@end

// 自定义事件传递
@interface CustomView : UIView
@end

@implementation CustomView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 自定义命中测试逻辑
    if (point.x < 50) {
        return nil;  // 左侧 50px 不响应
    }
    return [super hitTest:point withEvent:event];
}

@end
```

### 成为第一响应者

```objc
@interface CustomTextField : UITextField
@end

@implementation CustomTextField

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    if (result) {
        NSLog(@"成为第一响应者");
    }
    return result;
}

- (BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    if (result) {
        NSLog(@"放弃第一响应者");
    }
    return result;
}

@end

// 主动成为第一响应者
[textField becomeFirstResponder];

// 放弃第一响应者（隐藏键盘）
[textField resignFirstResponder];
```

### 远程事件

```objc
@interface MyViewController : UIViewController
@end

@implementation MyViewController

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"设备摇动");
    }
}

@end
```

---

## UIView 动画

### 基础动画

```objc
[UIView animateWithDuration:0.3 animations:^{
    // 动画属性
    view.alpha = 0.5;
    view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    view.backgroundColor = [UIColor redColor];
}];
```

### 带动画完成回调

```objc
[UIView animateWithDuration:0.3 animations:^{
    view.alpha = 0.5;
} completion:^(BOOL finished) {
    if (finished) {
        NSLog(@"动画完成");
    }
}];
```

### 链式动画

```objc
[UIView animateWithDuration:0.3 animations:^{
    view.alpha = 0.5;
} completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0.5;
        } completion:nil];
    }];
}];
```

### 弹簧动画

```objc
[UIView animateWithDuration:0.5
                      delay:0
     usingSpringWithDamping:0.6      // 阻尼（0-1，越小弹性越大）
      initialSpringVelocity:0.5       // 初始速度
                    options:0
                 animations:^{
    view.transform = CGAffineTransformMakeScale(1.1, 1.1);
} completion:nil];
```

### 延迟动画

```objc
[UIView animateWithDuration:0.3
                      delay:1.0  // 延迟 1 秒
                    options:0
                 animations:^{
    view.alpha = 0.5;
} completion:nil];
```

### 动画选项

```objc
[UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                 animations:^{
    view.transform = CGAffineTransformMakeRotation(M_PI);
} completion:nil];

// 常用选项
// 时间曲线
UIViewAnimationOptionCurveEaseInOut      // 慢 - 快 - 慢（默认）
UIViewAnimationOptionCurveEaseIn         // 慢 - 快
UIViewAnimationOptionCurveEaseOut        // 快 - 慢
UIViewAnimationOptionCurveLinear         // 匀速

// 重复
UIViewAnimationOptionRepeat              // 重复
UIViewAnimationOptionAutoreverse         // 自动反向

// 其他
UIViewAnimationOptionAllowUserInteraction // 动画期间允许交互
UIViewAnimationOptionBeginFromCurrentState // 从当前状态开始
```

### 可动画属性

```objc
// frame
view.frame = CGRectMake(0, 0, 200, 200);

// bounds
view.bounds = CGRectMake(0, 0, 100, 100);

// center
view.center = CGPointMake(100, 100);

// transform
view.transform = CGAffineTransformMakeScale(1.5, 1.5);
view.transform = CGAffineTransformMakeRotation(M_PI / 4);
view.transform = CGAffineTransformMakeTranslation(50, 50);

// alpha
view.alpha = 0.5;

// backgroundColor
view.backgroundColor = [UIColor redColor];

// layer 属性
view.layer.cornerRadius = 20;
view.layer.borderWidth = 2;
view.layer.borderColor = [UIColor blueColor].CGColor;
view.layer.shadowOpacity = 0.5;
```

### 组合变换

```objc
// 缩放 + 旋转
CGAffineTransform scale = CGAffineTransformMakeScale(1.2, 1.2);
CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI / 4);
view.transform = CGAffineTransformConcat(scale, rotate);

// 注意：变换顺序会影响结果
```

### 动画组

```objc
[UIView animateKeyframesWithDuration:1.0 delay:0 options:0 animations:^{
    // 关键帧 1: 0-25%
    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
    
    // 关键帧 2: 25-50%
    [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }];
    
    // 关键帧 3: 50-75%
    [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    // 关键帧 4: 75-100%
    [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeRotation(M_PI);
    }];
} completion:nil];
```

### 过渡动画

```objc
// 视图过渡
[UIView transitionWithView:containerView
                  duration:0.5
                   options:UIViewTransitionOptionTransitionFlipFromLeft
                animations:^{
    // 添加/移除子视图
} completion:nil];

// 常用过渡选项
UIViewTransitionOptionTransitionFlipFromLeft
UIViewTransitionOptionTransitionFlipFromRight
UIViewTransitionOptionTransitionCurlUp
UIViewTransitionOptionTransitionCurlDown
UIViewTransitionOptionTransitionCrossDissolve
UIViewTransitionOptionTransitionFlipFromTop
UIViewTransitionOptionTransitionFlipFromBottom
```

### 基于物理的动画

```objc
// 使用 UIDynamicAnimator（iOS 7+）
// 或使用 UIKit Dynamics
```

---

## UIViewController 转场动画

### 推入/弹出动画

```objc
// 自定义推入动画
CATransition *transition = [CATransition animation];
transition.type = kCATransitionPush;
transition.subtype = kCATransitionFromRight;
transition.duration = 0.3;
[navigationController.view.layer addAnimation:transition forKey:kCATransition];

[navigationController pushViewController:vc animated:NO];
```

### 模态转场

```objc
// 设置转场样式
vc.modalPresentationStyle = UIModalPresentationFullScreen;
vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;  // 或 UIModalTransitionStyleFlipHorizontal, UIModalTransitionStyleCrossDissolve, UIModalTransitionStylePartialCurl

[self presentViewController:vc animated:YES completion:nil];
```

### 自定义转场

```objc
// 1. 创建转场动画类
@interface CustomPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@end

@implementation CustomPushAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toVC.view.frame = CGRectMake(containerView.bounds.size.width, 0, containerView.bounds.size.width, containerView.bounds.size.height);
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        toVC.view.frame = CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

// 2. 实现转场代理
@interface MyViewController () <UIViewControllerTransitioningDelegate>
@end

@implementation MyViewController

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[CustomPushAnimation alloc] init];
}

@end

// 3. 使用
vc.modalPresentationStyle = UIModalPresentationCustom;
vc.transitioningDelegate = self;
[self presentViewController:vc animated:YES completion:nil];
```

### 交互式转场

```objc
@interface InteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL shouldFinish;
@end

// 在视图控制器中
@property (nonatomic, strong) InteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL isDragging;

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat progress = translation.x / self.view.bounds.size.width;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.isDragging = YES;
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            break;
        case UIGestureRecognizerStateChanged:
            [self.interactionController update:progress];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.isDragging = NO;
            if (progress > 0.5) {
                [self.interactionController finish];
            } else {
                [self.interactionController cancel];
            }
            break;
        default:
            break;
    }
}
```

---

## 实用动画示例

### 1. 心跳动画

```objc
- (void)heartbeatAnimationWithView:(UIView *)view {
    [UIView animateWithDuration:0.1 animations:^{
        view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}
```

### 2. 淡入淡出

```objc
- (void)fadeInView:(UIView *)view {
    [self fadeInView:view duration:0.3];
}

- (void)fadeInView:(UIView *)view duration:(NSTimeInterval)duration {
    view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 1;
    } completion:nil];
}

- (void)fadeOutView:(UIView *)view {
    [self fadeOutView:view duration:0.3 completion:nil];
}

- (void)fadeOutView:(UIView *)view duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    [UIView animateWithDuration:duration animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
```

### 3. 抖动动画

```swift
func shakeAnimation(view: UIView) {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = 0.6
    animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
    view.layer.add(animation, forKey: "shake")
}
```

### 4. 加载旋转

```swift
func startLoadingAnimation(view: UIView) {
    let rotation = CABasicAnimation(keyPath: "transform.rotation")
    rotation.fromValue = 0
    rotation.toValue = 2 * .pi
    rotation.duration = 1.0
    rotation.repeatCount = .infinity
    view.layer.add(rotation, forKey: "rotation")
}

func stopLoadingAnimation(view: UIView) {
    view.layer.removeAnimation(forKey: "rotation")
}
```

### 5. 卡片翻转

```swift
func flipAnimation(view: UIView) {
    UIView.transition(with: view,
                     duration: 0.6,
                     options: .transitionFlipFromLeft,
                     animations: {
        // 切换内容
    })
}
```

---

*最后更新：2026-03-03*
