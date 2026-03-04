# 列表与导航

> 📑 UITableView、UICollectionView 与导航控制器

---

## UITableView 表格视图

### 基础用法

```objc
@interface MyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *items;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@"Item 1", @"Item 2", @"Item 3"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中：%@", self.items[indexPath.row]);
}

@end
```

### 自定义单元格

```objc
// CustomCell.h
@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

+ (NSString *)identifier;
- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end

// CustomCell.m
@implementation CustomCell

+ (NSString *)identifier {
    return @"CustomCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconImageView.image = [UIImage systemImageNamed:@"star"];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.contentView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.iconImageView.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
        [self.iconImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.iconImageView.widthAnchor constraintEqualToConstant:40],
        [self.iconImageView.heightAnchor constraintEqualToConstant:40],
        
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:12],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
        
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:12],
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}

@end

// 使用
[self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:[CustomCell identifier]];

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomCell identifier] forIndexPath:indexPath];
    [cell configureWithTitle:@"标题" subtitle:@"副标题"];
    return cell;
}
```

### 分组与索引

```objc
// 多组数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionData[section].count;
}

// 组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"分组 %ld", (long)(section + 1)];
}

// 索引标题
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return @[@"A", @"B", @"C", @"D"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}
```

### 编辑模式

```objc
// 开启编辑
self.tableView.editing = YES;

// 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

// 移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *item = self.items[sourceIndexPath.row];
    [self.items removeObjectAtIndex:sourceIndexPath.row];
    [self.items insertObject:item atIndex:destinationIndexPath.row];
}
```

### 高度设置

```objc
// 自动高度（推荐）
self.tableView.rowHeight = UITableViewAutomaticDimension;
self.tableView.estimatedRowHeight = 60;

// 固定高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 动态高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.items[indexPath.row];
    return 44 + text.length * 2;
}
```

---

## UICollectionView 集合视图

### 基础用法

```objc
@interface MyViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSNumber *> *items;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor systemBlueColor];
    cell.contentView.layer.cornerRadius = 8;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中：%@", self.items[indexPath.item]);
}

@end
```

### 自定义单元格

```objc
// GridCell.h
@interface GridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

+ (NSString *)identifier;
- (void)configureWithImage:(UIImage *)image title:(NSString *)title;

@end

// GridCell.m
@implementation GridCell

+ (NSString *)identifier {
    return @"GridCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.label];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor],
        
        [self.label.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:4],
        [self.label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8],
        [self.label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8],
        [self.label.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8]
    ]];
}

- (void)configureWithImage:(UIImage *)image title:(NSString *)title {
    self.imageView.image = image;
    self.label.text = title;
}

@end

// 使用
[self.collectionView registerClass:[GridCell class] forCellWithReuseIdentifier:[GridCell identifier]];

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GridCell identifier] forIndexPath:indexPath];
    [cell configureWithImage:[UIImage systemImageNamed:@"star"] title:[NSString stringWithFormat:@"Item %ld", (long)indexPath.item]];
    return cell;
}
```

### 布局配置

```objc
// Flow Layout
UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 或 UICollectionViewScrollDirectionHorizontal
layout.itemSize = CGSizeMake(100, 100);
layout.minimumInteritemSpacing = 10;
layout.minimumLineSpacing = 10;
layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

// 动态调整大小
- (CGSize)collectionView:(UICollectionView *)collectionView 
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

// Compositional Layout (iOS 13+)
- (UICollectionViewLayout *)createCompositionalLayout {
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.5]
                                                                        heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                        heightDimension:[NSCollectionLayoutDimension absoluteDimension:100]];
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    section.contentInsets = NSDirectionalEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
    return layout;
}
```

---

## UINavigationController 导航控制器

### 基础用法

```objc
// 创建导航控制器
RootViewController *rootVC = [[RootViewController alloc] init];
UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];

// 设置到 window
self.window.rootViewController = navigationController;

// 推入新控制器
DetailViewController *detailVC = [[DetailViewController alloc] init];
[navigationController pushViewController:detailVC animated:YES];

// 弹出
[navigationController popViewControllerAnimated:YES];

// 弹到根
[navigationController popToRootViewControllerAnimated:YES];

// 弹到指定
[navigationController popToViewController:targetVC animated:YES];
```

### 导航栏配置

```objc
// 隐藏导航栏
[navigationController setNavigationBarHidden:YES animated:YES];

// 设置标题
self.navigationItem.title = @"标题";

// 返回按钮
self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];

// 隐藏返回按钮
self.navigationItem.hidesBackButton = YES;

// 左侧按钮
self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                       target:self
                                                                                       action:@selector(cancelTapped)];

// 右侧按钮
self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                        target:self
                                                                                        action:@selector(saveTapped)];

// 多个按钮
self.navigationItem.rightBarButtonItems = @[
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTapped)],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped)]
];
```

### 自定义导航栏

```objc
// 背景色
navigationController.navigationBar.barTintColor = [UIColor systemBlueColor];

// 标题颜色
navigationController.navigationBar.titleTextAttributes = @{
    NSForegroundColorAttributeName: [UIColor whiteColor]
};

// 大标题
navigationController.navigationBar.prefersLargeTitles = YES;
self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic; // 或 .always, .never

// 毛玻璃效果
navigationController.navigationBar.translucent = YES;

// 底部线条
navigationController.navigationBar.shadowImage = [UIImage image];
```

---

## UITabBarController 标签栏

### 基础用法

```objc
// 创建子控制器
FirstViewController *vc1 = [[FirstViewController alloc] init];
vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                image:[UIImage systemImageNamed:@"house"]
                                          selectedImage:[UIImage systemImageNamed:@"house.fill"]];

SecondViewController *vc2 = [[SecondViewController alloc] init];
vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索"
                                                image:[UIImage systemImageNamed:@"magnifyingglass"]
                                          selectedImage:[UIImage systemImageNamed:@"magnifyingglass.fill"]];

ThirdViewController *vc3 = [[ThirdViewController alloc] init];
vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                image:[UIImage systemImageNamed:@"person"]
                                          selectedImage:[UIImage systemImageNamed:@"person.fill"]];

// 创建标签栏控制器
UITabBarController *tabBarController = [[UITabBarController alloc] init];
tabBarController.viewControllers = @[vc1, vc2, vc3];

// 设置到 window
self.window.rootViewController = tabBarController;
```

### 自定义样式

```objc
// 背景色
tabBarController.tabBar.barTintColor = [UIColor whiteColor];

// 选中颜色
tabBarController.tabBar.tintColor = [UIColor systemBlueColor];

// 背景图片
tabBarController.tabBar.backgroundImage = [UIImage image];
tabBarController.tabBar.shadowImage = [UIImage image];

// 隐藏顶部线条
tabBarController.tabBar.shadowImage = [UIImage image];

// 添加高斯模糊
UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
blurView.frame = tabBarController.tabBar.bounds;
blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
[tabBarController.tabBar insertSubview:blurView atIndex:0];
```

### 代理方法

```objc
@interface AppDelegate () <UITabBarControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // 是否可以切换
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // 已经切换
    NSLog(@"切换到：%@", viewController);
}

@end
```

---

*最后更新：2026-03-03*
