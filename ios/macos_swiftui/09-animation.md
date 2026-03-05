# 动画

> ✨ withAnimation, @State, transition, animation (Swift 版)

---

## 基础动画

### withAnimation

```swift
@State private var isShown = false

Button("切换") {
    withAnimation {
        isShown.toggle()
    }
}

if isShown {
    Text("显示的内容")
        .transition(.opacity)
}
```

### Animation 参数

```swift
// 时长
withAnimation(.easeInOut(duration: 0.5)) {
    // 动画内容
}

// 曲线
withAnimation(.linear) { }
withAnimation(.easeIn) { }
withAnimation(.easeOut) { }
withAnimation(.spring()) { }
withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { }
```

---

## View 动画

### animation 修饰器

```swift
@State private var scale: CGFloat = 1.0

Text("缩放")
    .scaleEffect(scale)
    .animation(.easeInOut(duration: 0.3), value: scale)

Button("放大") {
    scale = 1.5
}

Button("缩小") {
    scale = 1.0
}
```

### 隐式动画

```swift
@State private var isOn = false

Toggle("开关", isOn: $isOn)
    .toggleStyle(.switch)
    .animation(.easeInOut, value: isOn)
```

---

## 过渡效果

### 基础过渡

```swift
// 淡入淡出
.transition(.opacity)

// 缩放
.transition(.scale)

// 移动
.transition(.move(edge: .leading))
.transition(.move(edge: .trailing))
.transition(.move(edge: .top))
.transition(.move(edge: .bottom))

// 组合
.transition(.asymmetric(
    insertion: .scale,
    removal: .opacity
))
```

### 自定义过渡

```swift
extension AnyTransition {
    static var slideIn: AnyTransition {
        .move(edge: .trailing).combined(with: .opacity)
    }
    
    static var slideOut: AnyTransition {
        .move(edge: .leading).combined(with: .opacity)
    }
}

// 使用
Text("动画")
    .transition(.slideIn)
```

---

## 动画值

### @State 绑定

```swift
@State private var progress: Double = 0

VStack {
    ProgressView(value: progress)
    
    Slider(value: $progress)
        .animation(.easeInOut, value: progress)
    
    Button("随机") {
        withAnimation(.easeInOut(duration: 0.5)) {
            progress = Double.random(in: 0...1)
        }
    }
}
```

---

## spring 动画

### 弹簧参数

```swift
// 默认弹簧
.animation(.spring())

// 自定义弹簧
.animation(.spring(response: 0.5,           // 响应时间
                    dampingFraction: 0.7,   // 阻尼系数
                    blendDuration: 0))      // 混合时间

// 弹跳效果
.animation(.spring(response: 0.3, dampingFraction: 0.4))

// 平滑效果
.animation(.spring(response: 0.5, dampingFraction: 0.9))
```

---

## 动画回调

### onChange

```swift
@State private var value = 0

Text("值: \(value)")
    .onChange(of: value) { oldValue, newValue in
        print("从 \(oldValue) 变为 \(newValue)")
    }
```

---

## 交错动画

### 批量动画

```swift
struct StaggeredAnimation: View {
    @State private var show = false
    
    var body: some View {
        VStack {
            ForEach(0..<5) { index in
                Text("项目 \(index)")
                    .opacity(show ? 1 : 0)
                    .offset(x: show ? 0 : 20)
            }
        }
        .onAppear {
            for index in 0..<5 {
                withAnimation(
                    .easeOut(duration: 0.5)
                    .delay(Double(index) * 0.1)
                ) {
                    show = true
                }
            }
        }
    }
}
```

---

## 动画控制

### matchedGeometryEffect

```swift
struct MatchedGeometryEffect: View {
    @Namespace var namespace
    @State private var selected: Int?
    
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(selected == index ? Color.blue : Color.gray)
                    .frame(width: 50, height: 50)
                    .matchedGeometryEffect(id: index, in: namespace)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selected = index
                        }
                    }
            }
        }
    }
}
```

---

## 不可动画属性

### 替代方案

```swift
// ✅ 可以动画
Text("可动画")
    .opacity(value)
    .scaleEffect(value)
    .offset(x: value)

// ❌ 不能直接动画
// 但可以用 overlay 模拟
OverlayProgressView(progress: value)
```

---

*最后更新：2026-03-05*
