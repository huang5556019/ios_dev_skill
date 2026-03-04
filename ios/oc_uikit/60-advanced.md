# 高级主题

> 🎓 自定义控件、性能优化与多屏幕适配

---

## 自定义控件

### 创建自定义控件

```objc
@interface CustomCardView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *cardColor;
@property (nonatomic, copy) void (^onTap)(void);

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

- (void)configureWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle;

@end

@implementation CustomCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

- (void)setupUI {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.layer.cornerRadius = 12;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowRadius = 4;
    [self addSubview:self.containerView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:self.iconImageView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.containerView addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
    self.subtitleLabel.numberOfLines = 2;
    [self.containerView addSubview:self.subtitleLabel];
    
    // 约束
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [self.iconImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:16],
        [self.iconImageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:16],
        [self.iconImageView.widthAnchor constraintEqualToConstant:40],
        [self.iconImageView.heightAnchor constraintEqualToConstant:40],
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.iconImageView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:12],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-16],
        
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:12],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-16],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-16]
    ]];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap {
    if (self.onTap) {
        self.onTap();
    }
}

- (void)configureWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    self.iconImageView.image = icon;
    self.title = title;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 更新阴影路径以提高性能
    self.containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds cornerRadius:12].CGPath;
}

@end

// 使用示例
CustomCardView *card = [[CustomCardView alloc] init];
[card configureWithIcon:[UIImage systemImageNamed:@"star"] title:@"标题" subtitle:@"这是副标题描述"];
card.onTap = ^{
    NSLog(@"卡片被点击");
};
[view addSubview:card];
```

### 使用 IBDesignables

```objc
IB_DESIGNABLE
@interface GradientButton : UIButton

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic) IBInspectable CGFloat cornerRadiusValue;

@end

@implementation GradientButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGradient];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupGradient];
    }
    return self;
}

- (void)setupGradient {
    self.startColor = [UIColor systemBlueColor];
    self.endColor = [UIColor systemPurpleColor];
    self.cornerRadiusValue = 8;
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.cornerRadius = self.cornerRadiusValue;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.cornerRadius = self.cornerRadiusValue;
}

@end
```

---

## 性能优化

### TableView 性能优化

```objc
@interface OptimizedTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary<NSNumber *, NSNumber *> *rowHeights;
@property (nonatomic, strong) NSArray *items;

@end

@implementation OptimizedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowHeights = @{};
}

// 1. 使用 deque 重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // 配置 cell
    return cell;
}

// 2. 预计算行高
- (CGFloat)calculateRowHeightForIndexPath:(NSIndexPath *)indexPath {
    NSNumber *rowKey = @(indexPath.row);
    NSNumber *height = self.rowHeights[rowKey];
    if (height) {
        return [height floatValue];
    }
    
    // 计算高度
    CGFloat calculatedHeight = [self calculateHeightForItem:self.items[indexPath.row]];
    self.rowHeights = [self.rowHeights dictionaryWithObject:@(calculatedHeight) forKey:rowKey];
    return calculatedHeight;
}

// 3. 异步图片加载
- (void)loadImageForImageView:(UIImageView *)imageView atIndexPath:(NSIndexPath *)indexPath {
    // 取消之前的请求
    imageView.image = nil;
    
    // 异步加载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        UIImage *image = [weakSelf loadImageFromDiskAtIndexPath:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 检查 cell 是否还在显示
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.imageView.image = image;
            }
        });
    });
}

// 4. 减少 subview 数量
@interface OptimizedCell : UITableViewCell

@property (nonatomic, strong) UIStackView *contentStackView;

@end

@implementation OptimizedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupOptimizedLayout];
    }
    return self;
}

- (void)setupOptimizedLayout {
    // 使用 stackview 减少约束数量
    [self.contentView addSubview:self.contentStackView];
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.contentStackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.contentStackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8]
    ]];
}

@end
```

### 内存优化

```objc
@protocol DataDelegate <NSObject>
@end

@interface MemoryOptimizedViewController : UIViewController

@property (nonatomic, weak) id<DataDelegate> delegate;
@property (nonatomic, strong) UIImage *largeImage;
@property (nonatomic, strong) NSCache<NSString *, UIImage *> *imageCache;

@end

@implementation MemoryOptimizedViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

// 2. 延迟加载大对象
- (UIImage *)largeImage {
    if (!_largeImage) {
        _largeImage = [UIImage imageNamed:@"large_image"];
    }
    return _largeImage;
}

// 3. 及时释放资源
- (void)dealloc {
    // 移除通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 取消网络请求
    [[NSURLSession sharedSession] getAllTasksWithCompletionHandler:^(NSArray *tasks) {
        for (NSURLSessionTask *task in tasks) {
            [task cancel];
        }
    }];
    
    // 释放缓存
    [self.imageCache removeAllObjects];
}

// 4. 使用缓存
- (UIImage *)loadImageWithKey:(NSString *)key {
    UIImage *cached = [self.imageCache objectForKey:key];
    if (cached) {
        return cached;
    }
    
    UIImage *image = [UIImage imageNamed:key];
    if (!image) {
        return nil;
    }
    [self.imageCache setObject:image forKey:key];
    return image;
}

// 5. 内存警告处理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.imageCache removeAllObjects];
    self.largeImage = nil;
}

@end
```

### 渲染优化

```objc
@interface RenderOptimizedView : UIView

@end

@implementation RenderOptimizedView

// 1. 使用 shouldRasterize 缓存复杂视图
- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window != nil) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    } else {
        self.layer.shouldRasterize = NO;
    }
}

// 2. 优化阴影性能
- (void)setupOptimizedShadow {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4;
    // 关键：设置 shadowPath
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

// 3. 避免离屏渲染
- (void)drawRect:(CGRect)rect {
    // 使用 Core Graphics 直接绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
}

// 4. 批量更新
- (void)updateMultipleProperties {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    // 批量更新属性
    self.layer.opacity = 0.5;
    self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
    
    [CATransaction commit];
}

@end
```

---

## 多屏幕适配

### Safe Area 适配

```objc
@interface SafeAreaAdaptiveView : UIView

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SafeAreaAdaptiveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithSafeArea];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

- (void)setupWithSafeArea {
    self.contentLabel = [[UILabel alloc] init];
    [self addSubview:self.contentLabel];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 使用 safeAreaLayoutGuide
    [NSLayoutConstraint activateConstraints:@[
        [self.contentLabel.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:16],
        [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:16],
        [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-16],
        [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-16]
    ]];
}

// 监听 Safe Area 变化
- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    NSLog(@"Safe Area 变化：%@", NSStringFromUIEdgeInsets(self.safeAreaInsets));
}

@end
```

### 尺寸类适配

```objc
@interface AdaptiveViewController : UIViewController

@property (nonatomic, assign) UIUserInterfaceSizeClass horizontalSizeClass;
@property (nonatomic, assign) UIUserInterfaceSizeClass verticalSizeClass;

@end

@implementation AdaptiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateForCurrentTraitCollection];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateForCurrentTraitCollection];
    } completion:nil];
}

- (void)updateForCurrentTraitCollection {
    self.horizontalSizeClass = self.traitCollection.horizontalSizeClass;
    self.verticalSizeClass = self.traitCollection.verticalSizeClass;
    
    if (self.horizontalSizeClass == UIUserInterfaceSizeClassRegular && 
        self.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        // iPad 或 iPhone Plus 横屏
        [self setupForRegularRegular];
    } else if (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact && 
               self.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        // iPhone 竖屏
        [self setupForCompactRegular];
    } else if (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact && 
               self.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        // iPhone 横屏
        [self setupForCompactCompact];
    }
}

- (void)setupForRegularRegular {
    // iPad 布局
    NSLog(@"iPad 布局");
}

- (void)setupForCompactRegular {
    // iPhone 竖屏布局
    NSLog(@"iPhone 竖屏布局");
}

- (void)setupForCompactCompact {
    // iPhone 横屏布局
    NSLog(@"iPhone 横屏布局");
}

@end
```

### 多窗口适配

```objc
@available(iOS 13.0, *)
@interface MultiWindowAdapter : UIResponder <UIWindowSceneDelegate>

@end

@implementation MultiWindowAdapter

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    if (!windowScene) {
        return;
    }
    
    // 根据窗口大小适配布局
    UITraitCollection *traitCollection = windowScene.traitCollection;
    
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        // 宽屏布局
        [self setupWideLayoutInScene:windowScene];
    } else {
        // 窄屏布局
        [self setupNarrowLayoutInScene:windowScene];
    }
}

- (void)setupWideLayoutInScene:(UIWindowScene *)scene {
    // 使用分栏布局
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    // ...
}

- (void)setupNarrowLayoutInScene:(UIWindowScene *)scene {
    // 使用导航布局
    UINavigationController *navVC = [[UINavigationController alloc] init];
    // ...
}

@end
```

---

## 深色模式适配

```objc
@interface DarkModeCompatibleView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation DarkModeCompatibleView

- (instancetype)init {
    self = [super init];
    if (self) {
        // 使用动态颜色
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor labelColor];  // 自动适配深色模式
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor systemBackgroundColor];  // 自动适配
    }
    return self;
}

// 自定义动态颜色
- (UIColor *)customDynamicColor {
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        } else {
            return [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        }
    }];
}

// 监听模式变化
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (previousTraitCollection.userInterfaceStyle != self.traitCollection.userInterfaceStyle) {
        // 深色模式切换
        [self updateForDarkMode];
    }
}

- (void)updateForDarkMode {
    // 更新需要特殊处理的 UI
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [self customDynamicColor];
    }];
}

@end
```

---

## 辅助功能（Accessibility）

```objc
@interface AccessibleButton : UIButton

@end

@implementation AccessibleButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAccessibility];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

- (void)setupAccessibility {
    // 设置辅助功能标签
    self.accessibilityLabel = @"提交按钮";
    
    // 设置辅助功能提示
    self.accessibilityHint = @"双击以提交表单";
    
    // 设置按钮类型
    self.accessibilityTraits = UIAccessibilityTraitButton;
    
    // 设置是否可访问
    self.isAccessibilityElement = YES;
    
    // 自定义值
    self.accessibilityValue = @"未选中";
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.accessibilityValue = selected ? @"已选中" : @"未选中";
    [self accessibilityPerformUpdate];
}

@end

// 支持动态字体
@interface DynamicTypeLabel : UILabel

@end

@implementation DynamicTypeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDynamicType];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [NSException exceptionWithName:@"NotImplemented" 
                                   reason:@"init(coder:) not supported" 
                                 userInfo:nil];
}

- (void)setupDynamicType {
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.adjustsFontForContentSizeCategory = YES;
    
    // 监听字体变化
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(fontDidChange) 
                                                 name:UIContentSizeCategoryDidChangeNotification 
                                               object:nil];
}

- (void)fontDidChange {
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self setNeedsLayout];
}

@end
```

---

*最后更新：2026-03-03*
