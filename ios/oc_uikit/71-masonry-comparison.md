# Masonry vs 原生 Auto Layout

> 📊 两种约束编写方式对比与选择指南

---

## 📌 核心区别

| 特性 | Masonry | 原生 NSLayoutAnchor |
|------|---------|---------------------|
| 语法风格 | 链式调用 | 锚点 API |
| 代码量 | 较少 | 较多 |
| 学习曲线 | 平缓 | 中等 |
| 约束更新 | 简单 | 需要保存引用 |
| 社区支持 | 成熟 | 官方支持 |
| 依赖 | 第三方库 | 系统原生 |

---

## 💻 代码对比

### 1. 基础约束

**Masonry：**
```objective-c
[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(20);
    make.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.height.equalTo(@100);
}];
```

**原生：**
```objective-c
view.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
    [view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20],
    [view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20],
    [view.heightAnchor constraintEqualToConstant:100]
]];
```

### 2. 居中视图

**Masonry：**
```objective-c
[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.size.equalTo(CGSizeMake(120, 120));
}];
```

**原生：**
```objective-c
view.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    [view.widthAnchor constraintEqualToConstant:120],
    [view.heightAnchor constraintEqualToConstant:120]
]];
```

### 3. 约束更新

**Masonry：**
```objective-c
// 保存约束
self.heightConstraint = make.height.equalTo(@100);

// 更新
[self.heightConstraint mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@200);
}];

// 重新创建
[view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
}];
```

**原生：**
```objective-c
// 保存约束
self.heightConstraint = [view.heightAnchor constraintEqualToConstant:100];
self.heightConstraint.active = YES;

// 更新
self.heightConstraint.constant = 200;
[UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
}];

// 重新创建需要先移除
[self.heightConstraint setActive:NO];
self.heightConstraint = [view.heightAnchor constraintEqualToConstant:200];
self.heightConstraint.active = YES;
```

### 4. 多视图批量约束

**Masonry：**
```objective-c
NSArray *views = @[view1, view2, view3];
[views mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(20);
    make.width.equalTo(@100);
    make.height.equalTo(@100);
}];

// 水平分布
[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(20);
}];
[view2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(view1.mas_right).offset(20);
}];
[view3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(view2.mas_right).offset(20);
    make.right.equalTo(self.view).offset(-20);
}];
```

**原生：**
```objective-c
// 批量设置
for (UIView *view in views) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

[NSLayoutConstraint activateConstraints:@[
    [view1.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
    [view2.topAnchor constraintEqualToAnchor:view1.topAnchor],
    [view3.topAnchor constraintEqualToAnchor:view1.topAnchor],
    
    [view1.widthAnchor constraintEqualToConstant:100],
    [view2.widthAnchor constraintEqualToConstant:100],
    [view3.widthAnchor constraintEqualToConstant:100],
    
    [view1.heightAnchor constraintEqualToConstant:100],
    [view2.heightAnchor constraintEqualToConstant:100],
    [view3.heightAnchor constraintEqualToConstant:100],
    
    [view1.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20],
    [view2.leftAnchor constraintEqualToAnchor:view1.rightAnchor constant:20],
    [view3.leftAnchor constraintEqualToAnchor:view2.rightAnchor constant:20],
    [view3.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20]
]];
```

---

## 🎯 使用建议

### 选择 Masonry 的场景

✅ **推荐使用 Masonry：**

1. **老项目维护**
   - 项目已在使用 Masonry
   - 团队熟悉 Masonry 语法

2. **快速开发**
   - 需要快速原型开发
   - 代码量要求简洁

3. **复杂约束更新**
   - 需要频繁更新约束
   - 使用 `mas_remakeConstraints` 很方便

4. **团队偏好**
   - 团队更习惯链式语法
   - 有 Masonry 使用规范

### 选择原生的场景

✅ **推荐使用原生：**

1. **新项目**
   - 无历史包袱
   - 建议使用系统原生 API

2. **Swift 项目**
   - Swift 的锚点 API 更优雅
   - 配合 `NSLayoutConstraint.activate` 很简洁

3. **减少依赖**
   - 希望减少第三方库依赖
   - 控制包大小

4. **长期维护**
   - 官方支持，更稳定
   - 不用担心库的维护问题

---

## Objective-C 项目对比

### Masonry

```objc
UIView *view = [[UIView alloc] init];
view.backgroundColor = [UIColor redColor];
[self.view addSubview:view];

[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(20);
    make.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.height.equalTo(@100);
}];
```

### 原生 Auto Layout

```objc
UIView *view = [[UIView alloc] init];
view.backgroundColor = [UIColor redColor];
view.translatesAutoresizingMaskIntoConstraints = NO;
[self.view addSubview:view];

[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
    [view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
    [view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
    [view.heightAnchor constraintEqualToConstant:100]
]];
```

---

## 💡 迁移指南

### 从 Masonry 迁移到原生

**步骤 1：找出所有 Masonry 约束**
```bash
grep -r "mas_" YourProject/
```

**步骤 2：逐个替换**
```objective-c
// Before (Masonry)
[view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
}];

// After (原生)
view.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20],
    [view.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20],
    [view.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20],
    [view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20]
]];
```

**步骤 3：移除 Masonry 依赖**
```ruby
# Podfile
# 删除或注释掉
# pod 'Masonry'
```

**步骤 4：测试验证**
- 运行项目检查所有界面
- 使用 View Debugger 验证约束

---

## 🔧 混合使用

可以在同一项目中混合使用，但不推荐：

```objective-c
// ❌ 不推荐：混用两种方式
[view1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(20);
}];

view2.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [view2.leftAnchor constraintEqualToAnchor:view1.rightAnchor constant:20]
]];

// ✅ 推荐：统一使用一种方式
```

---

## 📈 性能对比

| 指标 | Masonry | 原生 |
|------|---------|------|
| 运行时性能 | 相同 | 相同 |
| 编译时间 | 略慢 | 略快 |
| 包大小 | +50KB | 无影响 |
| 内存占用 | 相同 | 相同 |

**结论：** 运行时性能无差异，Masonry 只是在编译时生成原生约束代码。

---

## 🎓 学习建议

### 新手推荐

1. **先学原生 API**
   - 理解 Auto Layout 原理
   - 掌握锚点概念

2. **再学 Masonry**
   - 提高开发效率
   - 理解封装思想

3. **两者对比**
   - 加深理解
   - 灵活选择

### 进阶建议

1. **阅读源码**
   - 理解 Masonry 实现原理
   - 学习优秀的封装技巧

2. **自定义封装**
   - 根据项目需求定制
   - 创建团队内部规范

---

## 📚 总结

| 维度 | 推荐 |
|------|------|
| Objective-C 项目 | Masonry |
| Swift 项目 | 原生或 SnapKit |
| 新项目 | 原生 |
| 老项目 | 保持现状 |
| 团队协作 | 统一规范最重要 |
| 长期维护 | 原生更稳妥 |

**核心原则：** 无论选择哪种方式，**保持一致性**最重要！

---

*最后更新：2026-03-03*
