# 交互与动画

> ✨ 手势识别、响应链与动画系统 (Swift 版)

---

## UIGestureRecognizer 手势识别

### 基础用法

```swift
let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
tapGesture.numberOfTapsRequired = 1
tapGesture.numberOfTouchesRequired = 1
view.addGestureRecognizer(tapGesture)

@objc func handleTap(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: view)
    print("点击位置：\(location)")
}
```

### 常用手势

#### 点击手势

```swift
let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
tap.numberOfTapsRequired = 2
tap.numberOfTouchesRequired = 2
view.addGestureRecognizer(tap)
```

#### 长按手势

```swift
let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
longPress.minimumPressDuration = 0.5
longPress.allowableMovement = 10
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

#### 滑动手势

```swift
let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
swipeLeft.direction = .left
view.addGestureRecognizer(swipeLeft)
```

#### 拖动手势

```swift
let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
view.addGestureRecognizer(pan)

@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let velocity = gesture.velocity(in: view)
    print("拖动中：\(translation)")
}
```

#### 捏合手势

```swift
let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
view.addGestureRecognizer(pinch)
```

#### 旋转手势

```swift
let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
view.addGestureRecognizer(rotation)
```

### 手势冲突处理

```swift
tapGesture.require(toFail: longPressGesture)

func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
}
```

---

## UIResponder 响应链

### 触摸事件处理

```swift
class CustomView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("触摸开始：\(location)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print("触摸移动：\(location)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("触摸结束")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("触摸取消")
    }
}
```

### 事件传递

```swift
let hitView = view.hitTest(point, with: event)

class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return super.point(inside: point, with: event)
    }
}
```

### 成为第一响应者

```swift
class CustomTextField: UITextField {
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result { print("成为第一响应者") }
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result { print("放弃第一响应者") }
        return result
    }
}

textField.becomeFirstResponder()
textField.resignFirstResponder()
```

---

## UIView 动画

### 基础动画

```swift
UIView.animate(withDuration: 0.3) {
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
    if finished { print("动画完成") }
}
```

### 链式动画

```swift
UIView.animate(withDuration: 0.3, animations: {
    view.alpha = 0.5
}) { _ in
    UIView.animate(withDuration: 0.3, animations: {
        view.alpha = 1.0
    })
}
```

### 弹簧动画

```swift
UIView.animate(withDuration: 0.5,
               delay: 0,
               usingSpringWithDamping: 0.6,
               initialSpringVelocity: 0.5,
               animations: {
    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
})
```

### 延迟动画

```swift
UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
    view.alpha = 0.5
})
```

### 动画选项

```swift
UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
    view.transform = CGAffineTransform(rotationAngle: .pi)
})
```

### 可动画属性

```swift
view.frame
view.bounds
view.center
view.transform
view.alpha
view.backgroundColor
view.layer.cornerRadius
view.layer.borderWidth
view.layer.borderColor
view.layer.shadowOpacity
```

### 动画组

```swift
UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
        self.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
})
```

### 过渡动画

```swift
UIView.transition(with: containerView,
                  duration: 0.5,
                  options: .transitionFlipFromLeft,
                  animations: {
}, completion: nil)
```

---

## UIViewController 转场动画

### 推入/弹出动画

```swift
let transition = CATransition()
transition.type = .push
transition.subtype = .fromRight
transition.duration = 0.3
navigationController?.view.layer.add(transition, forKey: kCATransition)

navigationController?.pushViewController(vc, animated: false)
```

### 模态转场

```swift
vc.modalPresentationStyle = .fullScreen
vc.modalTransitionStyle = .coverVertical
present(vc, animated: true, completion: nil)
```

---

## 实用动画示例

### 心跳动画

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

### 淡入淡出

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

### 抖动动画

```swift
func shakeAnimation(view: UIView) {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = 0.6
    animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
    view.layer.add(animation, forKey: "shake")
}
```

### 加载旋转

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

---

*最后更新：2026-03-05*
