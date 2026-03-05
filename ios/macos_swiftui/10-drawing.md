# 自定义绘图

> 🎨 Canvas, Shape, Path, 自定义图形 (Swift 版)

---

## Shape 协议

### 自定义形状

```swift
struct CircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

// 使用
CircleShape()
    .fill(Color.blue)
    .frame(width: 100, height: 100)
```

### 常用形状

```swift
Circle()
Ellipse()
Rectangle()
RoundedRectangle(cornerRadius: 10)
Capsule()
```

---

## Path 路径

### 基础用法

```swift
Path { path in
    path.move(to: CGPoint(x: 0, y: 50))
    path.addLine(to: CGPoint(x: 50, y: 0))
    path.addLine(to: CGPoint(x: 100, y: 50))
    path.closeSubpath()
}
.stroke(Color.blue, lineWidth: 2)
.fill(Color.blue.opacity(0.3))
```

### 曲线

```swift
Path { path in
    path.move(to: CGPoint(x: 0, y: 100))
    path.addQuadCurve(
        to: CGPoint(x: 100, y: 0),
        control: CGPoint(x: 0, y: 0)
    )
}
.stroke(Color.red, lineWidth: 3)
```

---

## Canvas

### 基础用法

```swift
Canvas { context, size in
    // 绘制背景
    let rect = CGRect(origin: .zero, size: size)
    context.fill(Path(rect), with: .color(.blue))
    
    // 绘制圆形
    let circle = Path(ellipseIn: CGRect(x: 50, y: 50, width: 100, height: 100))
    context.stroke(circle, with: .color(.white), lineWidth: 2)
    
    // 绘制文本
    let text = Text("Hello")
        .font(.title)
    context.draw(text, at: CGPoint(x: size.width / 2, y: size.height / 2))
}
.frame(width: 200, height: 200)
```

### 动画 Canvas

```swift
struct AnimatedCanvas: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            for i in 0..<10 {
                let radius = CGFloat(i) * 10 + phase
                let circle = Path(ellipseIn: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                ))
                context.stroke(circle, with: .color(.blue.opacity(0.5)), lineWidth: 1)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase = 100
            }
        }
    }
}
```

---

## 自定义图形

### 复杂形状

```swift
struct StarShape: Shape {
    var points: Int
    var innerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let angle = 2 * Double.pi / Double(points)
        
        var path = Path()
        
        for i in 0..<points {
            let outerPoint = CGPoint(
                x: center.x + outerRadius * cos(angle * Double(i) - Double.pi / 2),
                y: center.y + outerRadius * sin(angle * Double(i) - Double.pi / 2)
            )
            let innerPoint = CGPoint(
                x: center.x + innerRadius * cos(angle * Double(i) + angle / 2 - Double.pi / 2),
                y: center.y + innerRadius * sin(angle * Double(i) + angle / 2 - Double.pi / 2)
            )
            
            if i == 0 {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: outerPoint)
            }
            path.addLine(to: innerPoint)
        }
        path.closeSubpath()
        
        return path
    }
}

// 使用
StarShape(points: 5, innerRadius: 20)
    .fill(Color.yellow)
    .frame(width: 100, height: 100)
```

---

## 渐变填充

### 线性渐变

```swift
LinearGradient(
    gradient: Gradient(colors: [.red, .blue]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### 径向渐变

```swift
RadialGradient(
    gradient: Gradient(colors: [.yellow, .orange, .red]),
    center: .center,
    startRadius: 0,
    endRadius: 100
)
```

### 角度渐变

```swift
AngularGradient(
    gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]),
    center: .center,
    startAngle: .degrees(0),
    endAngle: .degrees(360)
)
```

---

## 遮罩与裁剪

### 使用形状裁剪

```swift
Image("photo")
    .resizable()
    .clipShape(Circle())

Image("photo")
    .resizable()
    .clipShape(RoundedRectangle(cornerRadius: 20))
```

### 使用 Mask

```swift
Image("photo")
    .resizable()
    .mask(
        Text("遮罩")
            .font(.system(size: 40, weight: .bold))
    )
```

---

*最后更新：2026-03-05*
