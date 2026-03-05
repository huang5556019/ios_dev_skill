# 手势与交互

> 👆 Gesture, TapGesture, DragGesture, MagnificationGesture (Swift 版)

---

## 基础手势

### 点击手势

```swift
// 简单点击
Text("点击我")
    .onTapGesture {
        print("点击")
    }

// 双击
Text("双击")
    .onTapGesture(count: 2) {
        print("双击")
    }

// 多次点击
Text("三次点击")
    .onTapGesture(count: 3) {
        print("三次点击")
    }
```

---

## DragGesture 拖动手势

### 基础用法

```swift
@State private var offset = CGSize.zero

Circle()
    .fill(Color.blue)
    .frame(width: 50, height: 50)
    .offset(offset)
    .gesture(
        DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                offset = .zero
            }
    )
```

### 限制范围

```swift
@State private var position = CGPoint(x: 100, y: 100)

Circle()
    .fill(Color.red)
    .frame(width: 50, height: 50)
    .position(position)
    .gesture(
        DragGesture()
            .onChanged { value in
                position = CGPoint(
                    x: max(25, min(275, value.location.x)),
                    y: max(25, min(275, value.location.y))
                )
            }
    )
```

---

## LongPressGesture 长按手势

```swift
@State private var isLongPressing = false

Rectangle()
    .fill(isLongPressing ? Color.red : Color.blue)
    .frame(width: 100, height: 100)
    .gesture(
        LongPressGesture(minimumDuration: 1.0)
            .onChanged { _ in
                isLongPressing = true
            }
            .onEnded { _ in
                isLongPressing = false
            }
    )
```

---

## MagnificationGesture 缩放手势

```swift
@State private var scale: CGFloat = 1.0

Image(systemName: "star")
    .resizable()
    .frame(width: 100 * scale, height: 100 * scale)
    .gesture(
        MagnificationGesture()
            .onChanged { value in
                scale = value
            }
            .onEnded { _ in
                withAnimation {
                    scale = 1.0
                }
            }
    )
```

---

## RotationGesture 旋转手势

```swift
@State private var angle: Double = 0

Image(systemName: "star")
    .resizable()
    .frame(width: 100, height: 100)
    .rotationEffect(.degrees(angle))
    .gesture(
        RotationGesture()
            .onChanged { value in
                angle = value.degrees
            }
            .onEnded { _ in
                withAnimation {
                    angle = 0
                }
            }
    )
```

---

## 组合手势

### 同时识别

```swift
Text("组合手势")
    .gesture(
        TapGesture()
            .onEnded { print("点击") }
            .exclusively(before:: LongPressGesture(minimumDuration: 1.0)
                .onEnded { _ in print("长按") })
    )
```

### 顺序识别

```swift
// 点击优先，长按其次
.gesture(
    TapGesture()
        .onEnded { print("点击") }
        .sequenced(before: LongPressGesture(minimumDuration: 1.0))
            .onEnded { state in
                if case .second(_, true) = state {
                    print("长按")
                }
            }
)
```

### 并发识别

```swift
// 同时支持多个手势
.gesture(
    TapGesture().onEnded { print("点击") },
    DragGesture().onChanged { _ in print("拖动") }
)
```

---

## 手势优先级

### Simultaneous

```swift
.gesture(TapGesture.exclusive)

.gesture(TapGesture.simultaneous(with: DragGesture()))
```

### Priority

```swift
.gesture(
    TapGesture()
        .onEnded { print("点击") }
        .priority(.high)
)
```

---

## 常用模式

### 拖动排序

```swift
struct DraggableItem: View {
    let item: String
    @Binding var offset: CGSize
    
    var body: some View {
        Text(item)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation {
                            offset = .zero
                        }
                    }
            )
    }
}
```

### 滑动手势

```swift
struct SwipeAction: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        if value.translation.width < -50 {
                            action()
                        }
                    }
            )
    }
}

extension View {
    func swipeToDelete(action: @escaping () -> Void) -> some View {
        modifier(SwipeAction(action: action))
    }
}

// 使用
List {
    ForEach(items, id: \.self) { item in
        Text(item)
            .swipeToDelete {
                deleteItem(item)
            }
    }
}
```

---

*最后更新：2026-03-05*
