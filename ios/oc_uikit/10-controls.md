# 常用控件文档

> 🎛️ UIKit 核心控件使用指南

---

## UIButton 按钮

### 基础用法

```objc
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
[button setTitle:@"点击我" forState:UIControlStateNormal];
[button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
[button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];

- (void)buttonTapped {
    NSLog(@"按钮被点击");
}
```

### 样式设置

```objc
// 背景色
button.backgroundColor = [UIColor systemBlueColor];

// 圆角
button.layer.cornerRadius = 8;
button.clipsToBounds = YES;

// 边框
button.layer.borderWidth = 1;
button.layer.borderColor = [UIColor systemBlueColor].CGColor;

// 内容EdgeInsets
button.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);

// 标题EdgeInsets
button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

// 图片
[button setImage:[UIImage systemImageNamed:@"star"] forState:UIControlStateNormal];
button.imageView.contentMode = UIViewContentModeScaleAspectFit;
```

### 不同状态

```objc
// 正常状态
[button setTitle:@"提交" forState:UIControlStateNormal];
button.backgroundColor = [UIColor systemBlueColor];

// 高亮状态
[button setTitle:@"提交中..." forState:UIControlStateHighlighted];

// 禁用状态
button.enabled = NO;
[button setTitle:@"不可用" forState:UIControlStateDisabled];
button.backgroundColor = [UIColor grayColor];

// 选中状态
button.selected = YES;
[button setTitle:@"已选中" forState:UIControlStateSelected];
```

### 按钮类型

```objc
// 系统按钮（推荐）
UIButton *systemBtn = [UIButton buttonWithType:UIButtonTypeSystem];

// 自定义按钮
UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];

// 带详情的按钮
UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

// 信息按钮
UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];

// 联系添加按钮
UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
```

---

## UILabel 标签

### 基础用法

```objc
UILabel *label = [[UILabel alloc] init];
label.text = @"Hello World";
label.font = [UIFont systemFontOfSize:16];
label.textColor = [UIColor labelColor];
label.textAlignment = NSTextAlignmentCenter;
```

### 多行文本

```objc
// 允许换行
label.numberOfLines = 0;

// 限制行数
label.numberOfLines = 3;

// 截断模式
label.lineBreakMode = NSLineBreakByTruncatingTail;  // 末尾省略
label.lineBreakMode = NSLineBreakByTruncatingHead;  // 开头省略
label.lineBreakMode = NSLineBreakByTruncatingMiddle; // 中间省略
label.lineBreakMode = NSLineBreakByWordWrapping;    // 按词换行
```

### 富文本

```objc
NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"Hello World"];
[attributedText addAttribute:NSFontAttributeName 
                       value:[UIFont boldSystemFontOfSize:18] 
                       range:NSMakeRange(0, 5)];
[attributedText addAttribute:NSForegroundColorAttributeName 
                       value:[UIColor redColor] 
                       range:NSMakeRange(6, 5)];
label.attributedText = attributedText;
```

### 高级属性

```objc
// 阴影
label.shadowColor = [UIColor grayColor];
label.shadowOffset = CGSizeMake(1, 1);

// 行间距
NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
paragraphStyle.lineHeightMultiple = 1.5;
label.attributedText = [[NSAttributedString alloc] initWithString:@"多行文本"
                                                          attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

// 自适应字体
label.adjustsFontForContentSizeCategory = YES;
label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
```

### 多行文本

```objc
// 允许换行
label.numberOfLines = 0;

// 限制行数
label.numberOfLines = 3;

// 截断模式
label.lineBreakMode = NSLineBreakByTruncatingTail;  // 末尾省略
label.lineBreakMode = NSLineBreakByTruncatingHead;  // 开头省略
label.lineBreakMode = NSLineBreakByTruncatingMiddle; // 中间省略
label.lineBreakMode = NSLineBreakByWordWrapping;     // 按词换行
```

### 富文本

```objc
NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"Hello World"];
[attributedText addAttribute:NSFontAttributeName 
                       value:[UIFont boldSystemFontOfSize:18] 
                       range:NSMakeRange(0, 5)];
[attributedText addAttribute:NSForegroundColorAttributeName 
                       value:[UIColor redColor] 
                       range:NSMakeRange(6, 5)];
label.attributedText = attributedText;
```

### 高级属性

```objc
// 阴影
label.shadowColor = [UIColor grayColor];
label.shadowOffset = CGSizeMake(1, 1);

// 行间距
NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
paragraphStyle.lineHeightMultiple = 1.5
label.attributedText = NSAttributedString(
    string: "多行文本",
    attributes: [.paragraphStyle: paragraphStyle]
)

// 自适应字体
label.adjustsFontForContentSizeCategory = true
label.font = .preferredFont(forTextStyle: .body)
```

---

## UITextField 文本输入框

### 基础用法

```objc
UITextField *textField = [[UITextField alloc] init];
textField.placeholder = @"请输入...";
textField.text = @"默认值";
textField.borderStyle = UITextBorderStyleRoundedRect;
textField.keyboardType = UIKeyboardTypeEmailAddress;
textField.returnKeyType = UIReturnKeyDone;
```

### 代理方法

```objc
@interface MyVC () <UITextFieldDelegate>
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textField.delegate = self;
}

#pragma mark - UITextFieldDelegate

// 即将开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// 已经开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始编辑");
}

// 即将结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

// 已经结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"结束编辑");
}

// 字符变化
- (BOOL)textField:(UITextField *)textField 
shouldChangeCharactersInRange:(NSRange)range 
replacementString:(NSString *)string {
    // 可以在这里做输入验证
    return YES;
}

// 点击清除按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

// 点击返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
```

### 样式设置

```objc
// 边框样式
textField.borderStyle = UITextBorderStyleNone;       // 无边框
textField.borderStyle = UITextBorderStyleLine;        // 底线
textField.borderStyle = UITextBorderStyleBezel;       // 凹陷
textField.borderStyle = UITextBorderStyleRoundedRect; // 圆角矩形

// 左视图（通常放图标）
UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"search"]];
iconView.frame = CGRectMake(0, 0, 30, 30);
textField.leftView = iconView;
textField.leftViewMode = UITextFieldViewModeAlways;

// 右视图（通常放清除按钮）
UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
[clearButton setImage:[UIImage systemImageNamed:@"xmark.circle"] forState:UIControlStateNormal];
textField.rightView = clearButton;
textField.rightViewMode = UITextFieldViewModeWhileEditing;

// 占位符颜色
textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"placeholder"
                                                                   attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
```

### 键盘类型

```objc
textField.keyboardType = UIKeyboardTypeDefault;           // 默认
textField.keyboardType = UIKeyboardTypeASCIICapable;       // ASCII
textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation; // 数字和标点
textField.keyboardType = UIKeyboardTypeNumberPad;          // 数字键盘
textField.keyboardType = UIKeyboardTypeDecimalPad;        // 小数键盘
textField.keyboardType = UIKeyboardTypePhonePad;          // 电话键盘
textField.keyboardType = UIKeyboardTypeNamePhonePad;      // 姓名电话
textField.keyboardType = UIKeyboardTypeEmailAddress;      // 邮箱
textField.keyboardType = UIKeyboardTypeURL;               // URL
textField.keyboardType = UIKeyboardTypeTwitter;           // Twitter
textField.keyboardType = UIKeyboardTypeWebSearch;         // Web 搜索
```

---

## UITextView 富文本视图

### 基础用法

```objc
UITextView *textView = [[UITextView alloc] init];
textView.text = @"可编辑的富文本";
textView.font = [UIFont systemFontOfSize:16];
textView.textColor = [UIColor labelColor];
textView.editable = YES;
textView.scrollEnabled = YES;
```

### 代理方法

```objc
@interface MyVC () <UITextViewDelegate>
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textView.delegate = self;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"文本变化：%@", textView.text);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"选区变化");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"结束编辑");
}

@end
```

### 富文本编辑

```objc
// 设置富文本
NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"Hello World"];
[attributedText addAttribute:NSFontAttributeName 
                       value:[UIFont boldSystemFontOfSize:20] 
                       range:NSMakeRange(0, 5)];
textView.attributedText = attributedText;

// 获取选区
NSRange selectedRange = textView.selectedRange;
NSString *selectedText = [textView.text substringWithRange:selectedRange];

// 设置选区
textView.selectedRange = NSMakeRange(0, 5);
```

---

## UIImageView 图片视图

### 基础用法

```objc
UIImageView *imageView = [[UIImageView alloc] init];
imageView.image = [UIImage imageNamed:@"example"];
imageView.contentMode = UIViewContentModeScaleAspectFit;
imageView.clipsToBounds = YES;
```

### 内容模式

```objc
imageView.contentMode = UIViewContentModeScaleToFill;      // 填充（可能变形）
imageView.contentMode = UIViewContentModeScaleAspectFit;   // 适应（保持比例，可能有留白）
imageView.contentMode = UIViewContentModeScaleAspectFill;   // 填充（保持比例，可能裁剪）
imageView.contentMode = UIViewContentModeCenter;             // 居中
imageView.contentMode = UIViewContentModeTop;                // 顶部
imageView.contentMode = UIViewContentModeBottom;             // 底部
imageView.contentMode = UIViewContentModeLeft;               // 左侧
imageView.contentMode = UIViewContentModeRight;             // 右侧
```

### 圆角与边框

```objc
// 圆角
imageView.layer.cornerRadius = 8;
imageView.clipsToBounds = YES;

// 圆形
imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
imageView.clipsToBounds = YES;

// 边框
imageView.layer.borderWidth = 2;
imageView.layer.borderColor = [UIColor systemBlueColor].CGColor;
```

### 动画

```objc
// 淡入动画
[UIView animateWithDuration:0.3 animations:^{
    imageView.alpha = 1.0;
}];

// 图片切换动画
[UIView transitionWithView:imageView
                  duration:0.3
                   options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^{
    imageView.image = [UIImage imageNamed:@"newImage"];
} completion:nil];
```

### 加载网络图片

```objc
// UIImageView+LoadImage.h
@interface UIImageView (LoadImage)
- (void)loadImageWithURL:(NSURL *)url;
@end

// UIImageView+LoadImage.m
@implementation UIImageView (LoadImage)

- (void)loadImageWithURL:(NSURL *)url {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
    }];
    [task resume];
}

@end

// 使用
[imageView loadImageWithURL:[NSURL URLWithString:@"https://example.com/image.jpg"]];
```

---

## UIScrollView 滚动视图

### 基础用法

```objc
UIScrollView *scrollView = [[UIScrollView alloc] init];
scrollView.frame = self.view.bounds;
scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
[self.view addSubview:scrollView];

// 添加内容视图
UIView *contentView = [[UIView alloc] init];
[scrollView addSubview:contentView];

// 设置约束
contentView.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
    [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
    [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
    [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
    [contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor]
    // 高度由内容决定
]];
```

### 常用属性

```objc
// 内容大小
scrollView.contentSize = CGSizeMake(320, 1000);

// 内容 insets
scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

// 滚动偏移
scrollView.contentOffset = CGPointMake(0, 100);

// 分页
scrollView.pagingEnabled = YES;

// 显示指示器
scrollView.showsVerticalScrollIndicator = YES;
scrollView.showsHorizontalScrollIndicator = YES;

// 弹性
scrollView.alwaysBounceVertical = YES;
scrollView.alwaysBounceHorizontal = NO;

// 缩放
scrollView.minimumZoomScale = 1.0;
scrollView.maximumZoomScale = 3.0;
scrollView.zoomScale = 1.0;
```

### 代理方法

```objc
@interface MyVC () <UIScrollViewDelegate>
@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.delegate = self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滚动中：%f", scrollView.contentOffset.y);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"开始拖动");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"结束拖动，是否减速：%d", decelerate);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"减速结束");
}

// 缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return contentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"缩放结束：%f", scale);
}

@end
```

### 滚动到指定位置

```objc
// 滚动到顶部
[scrollView setContentOffset:CGPointZero animated:YES];

// 滚动到底部
CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
[scrollView setContentOffset:bottomOffset animated:YES];

// 滚动到指定视图
UIView *targetView = subviews[5];
CGPoint targetOffset = CGPointMake(0, targetView.frame.origin.y);
[scrollView setContentOffset:targetOffset animated:YES];
```

---

*最后更新：2026-03-03*
