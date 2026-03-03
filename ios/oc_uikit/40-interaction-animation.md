# 交互与动画

> ✨ 手势识别、响应链与动画系统

---

## UIGestureRecognizer 手势识别

### 基础用法

```swift
// 创建手势
let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
tapGesture.numberOfTapsRequired = 1
tapGesture.numberOfTouchesRequired = 1
view.addGestureRecognizer(tapGesture)

@objc func handleTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: view)
    print("点击位置：\(location)")
}
```

### 常用手势类型

#### 1. 点击手势

```swift
let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
tap.numberOfTapsRequired = 2  // 双击
tap.numberOfTouchesRequired = 2 // 双指
view.addGestureRecognizer(tap)

@objc func handleTap(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .ended {
        print("点击完成")
    }
}
```

#### 2. 长按手势

```swift
let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
longPress.minimumPressDuration = 0.5  // 长按时间
longPress.allowableMovement = 10      // 允许移动距离
view.addGestureRecognizer(longPress)

@objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
        print("长按开始")
    case .changed:
        print("长按移动")
    case .ended:
        print("长按结束")
    default:
        break
    }
}
```

#### 3. 滑动手势

```swift
let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
swipeLeft.direction = .left
view.addGestureRecognizer(swipeLeft)

let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
swipeRight.direction = .right
view.addGestureRecognizer(swipeRight)

@objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
    switch gesture.direction {
    case .left:
        print("左滑")
    case .right:
        print("右滑")
    case .up:
        print("上滑")
    case .down:
        print("下滑")
    default:
        break
    }
}
```

#### 4. 拖动手势

```swift
let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
view.addGestureRecognizer(pan)

@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let velocity = gesture.velocity(in: view)
    
    switch gesture.state {
    case .began:
        print("拖动开始")
    case .changed:
        print("拖动中：\(translation)")
    case .ended:
        print("拖动结束，速度：\(velocity)")
    default:
        break
    }
}
```

#### 5. 捏合手势（缩放）

```swift
let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
view.addGestureRecognizer(pinch)

@objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
    let scale = gesture.scale
    let velocity = gesture.velocity
    
    switch gesture.state {
    case .began:
        print("捏合开始")
    case .changed:
        print("缩放比例：\(scale)")
    case .ended:
        print("捏合结束")
    default:
        break
    }
}
```

#### 6. 旋转手势

```swift
let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
view.addGestureRecognizer(rotation)

@objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
    let rotation = gesture.rotation  // 弧度
    let velocity = gesture.velocity
    
    switch gesture.state {
    case .began:
        print("旋转开始")
    case .changed:
        print("旋转角度：\(rotation * 180 / .pi)°")
    case .ended:
        print("旋转结束")
    default:
        break
    }
}
```

### 手势冲突处理

```swift
// 要求某个手势必须失败后才执行
tapGesture.require(toFail: longPressGesture)

// 允许同时识别
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
}

// 阻止手势接收触摸
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                      shouldReceive touch: UITouch) -> Bool {
    // 可以过滤特定视图
    return touch.view != ignoreView
}
```

### 自定义手势

```swift
class DoubleTapGesture: UIGestureRecognizer {
    private var tapCount = 0
    private var timer: Timer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        tapCount += 1
        
        if tapCount == 1 {
            timer = Timer.scheduledTimer(timeInterval: 0.3, 
                                        target: self, 
                                        selector: #selector(handleTimer), 
                                        userInfo: nil, 
                                        repeats: false)
        } else if tapCount == 2 {
            timer?.invalidate()
            state = .recognized
        }
    }
    
    @objc private func handleTimer() {
        tapCount = 0
        state = .failed
    }
    
    override func reset() {
        tapCount = 0
        timer?.invalidate()
    }
}
```

---

## UIResponder 响应链

### 响应链结构

```
UIView → UIViewController → UIWindow → UIApplication → AppDelegate
```

### 触摸事件处理

```swift
class CustomView: UIView {
    
    // 触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("触摸开始：\(location)")
    }
    
    // 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("触摸移动：\(location)")
    }
    
    // 触摸结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("触摸结束：\(location)")
    }
    
    // 触摸取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("触摸取消")
    }
}
```

### 事件传递

```swift
// 找到触摸的视图
let hitView = view.hitTest(point, with: event)

// 阻止事件传递
class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 返回 false 则不接收触摸
        return super.point(inside: point, with: event)
    }
}

// 自定义事件传递
class CustomView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 自定义命中测试逻辑
        if point.x < 50 {
            return nil  // 左侧 50px 不响应
        }
        return super.hitTest(point, with: event)
    }
}
```

### 成为第一响应者

```swift
class CustomTextField: UITextField {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            print("成为第一响应者")
        }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            print("放弃第一响应者")
        }
        return result
    }
}

// 主动成为第一响应者
textField.becomeFirstResponder()

// 放弃第一响应者（隐藏键盘）
textField.resignFirstResponder()
```

### 远程事件

```swift
class MyViewController: UIViewController {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("设备摇动")
        }
    }
}
```

---

## UIView 动画

### 基础动画

```swift
UIView.animate(withDuration: 0.3) {
    // 动画属性
    view.alpha = 0.5
    view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    view.backgroundColor = .red
}
```

### 带动画完成回调

```swift
UIView.animate(withDuration: 0.3, animations: {
    view.alpha = 0.5
}) { finished in
    if finished {
        print("动画完成")
    }
}
```

### 链式动画

```swift
UIView.animate(withDuration: 0.3, animations: {
    view.alpha = 0.5
}) { _ in
    UIView.animate(withDuration: 0.3, animations: {
        view.alpha = 1.0
    }) { _ in
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.5
        }
    }
}
```

### 弹簧动画

```swift
UIView.animate(withDuration: 0.5, 
               delay: 0,
               usingSpringWithDamping: 0.6,      // 阻尼（0-1，越小弹性越大）
               initialSpringVelocity: 0.5,       // 初始速度
               animations: {
    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
})
```

### 延迟动画

```swift
UIView.animate(withDuration: 0.3, 
               delay: 1.0,  // 延迟 1 秒
               animations: {
    view.alpha = 0.5
})
```

### 动画选项

```swift
UIView.animate(withDuration: 0.3, 
               delay: 0,
               options: [.curveEaseInOut, .repeat, .autoreverse],
               animations: {
    view.transform = CGAffineTransform(rotationAngle: .pi)
})

// 常用选项
// 时间曲线
.curveEaseInOut      // 慢 - 快 - 慢（默认）
.curveEaseIn         // 慢 - 快
.curveEaseOut        // 快 - 慢
.curveLinear         // 匀速

// 重复
.repeat              // 重复
.autoreverse         // 自动反向

// 其他
.allowUserInteraction // 动画期间允许交互
.beginFromCurrentState // 从当前状态开始
```

### 可动画属性

```swift
// frame
view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

// bounds
view.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

// center
view.center = CGPoint(x: 100, y: 100)

// transform
view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
view.transform = CGAffineTransform(rotationAngle: .pi / 4)
view.transform = CGAffineTransform(translationX: 50, y: 50)

// alpha
view.alpha = 0.5

// backgroundColor
view.backgroundColor = .red

// layer 属性
view.layer.cornerRadius = 20
view.layer.borderWidth = 2
view.layer.borderColor = UIColor.blue.cgColor
view.layer.shadowOpacity = 0.5
```

### 组合变换

```swift
// 缩放 + 旋转
let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
let rotate = CGAffineTransform(rotationAngle: .pi / 4)
view.transform = scale.concatenating(rotate)

// 注意：变换顺序会影响结果
```

### 动画组

```swift
UIView.animateKeyframes(withDuration: 1.0, delay: 0, animations: {
    // 关键帧 1: 0-25%
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    // 关键帧 2: 25-50%
    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    // 关键帧 3: 50-75%
    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    // 关键帧 4: 75-100%
    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(rotationAngle: .pi)
    }
})
```

### 过渡动画

```swift
// 视图过渡
UIView.transition(with: containerView,
                  duration: 0.5,
                  options: .transitionFlipFromLeft,
                  animations: {
    // 添加/移除子视图
}, completion: nil)

// 常用过渡选项
.transitionFlipFromLeft
.transitionFlipFromRight
.transitionCurlUp
.transitionCurlDown
.transitionCrossDissolve
.transitionFlipFromTop
.transitionFlipFromBottom
```

### 基于物理的动画

```swift
// 使用 UIDynamicAnimator（iOS 7+）
// 或使用 UIKit Dynamics
```

---

## UIViewController 转场动画

### 推入/弹出动画

```swift
// 自定义推入动画
let transition = CATransition()
transition.type = .push
transition.subtype = .fromRight
transition.duration = 0.3
navigationController?.view.layer.add(transition, forKey: kCATransition)

navigationController?.pushViewController(vc, animated: false)
```

### 模态转场

```swift
// 设置转场样式
vc.modalPresentationStyle = .fullScreen
vc.modalTransitionStyle = .coverVertical  // 或 .flipHorizontal, .crossDissolve, .partialCurl

present(vc, animated: true, completion: nil)
```

### 自定义转场

```swift
// 1. 创建转场动画类
class CustomPushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        toVC.view.frame.origin.x = containerView.bounds.width
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                      animations: {
            toVC.view.frame.origin.x = 0
        }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

// 2. 实现转场代理
extension MyViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                            presenting: UIViewController,
                            source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushAnimation()
    }
}

// 3. 使用
vc.modalPresentationStyle = .custom
vc.transitioningDelegate = self
present(vc, animated: true, completion: nil)
```

### 交互式转场

```swift
class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var shouldFinish = false
}

// 在视图控制器中
var interactionController: InteractiveTransition?
var isDragging = false

@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let progress = translation.x / view.bounds.width
    
    switch gesture.state {
    case .began:
        isDragging = true
        performSegue(withIdentifier: "showDetail", sender: self)
    case .changed:
        interactionController?.update(progress)
    case .ended, .cancelled:
        isDragging = false
        if progress > 0.5 {
            interactionController?.finish()
        } else {
            interactionController?.cancel()
        }
    default:
        break
    }
}
```

---

## 实用动画示例

### 1. 心跳动画

```swift
func heartbeatAnimation(view: UIView) {
    UIView.animate(withDuration: 0.1, animations: {
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }) { _ in
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
```

### 2. 淡入淡出

```swift
func fadeIn(view: UIView, duration: TimeInterval = 0.3) {
    view.alpha = 0
    UIView.animate(withDuration: duration) {
        view.alpha = 1
    }
}

func fadeOut(view: UIView, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: duration, animations: {
        view.alpha = 0
    }) { _ in
        completion?()
    }
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
