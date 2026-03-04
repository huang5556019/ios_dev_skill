# AGENTS.md - iOS Development Skill Documentation

## Overview

This repository contains iOS/macOS development skill documentation and reference materials. It is NOT an executable Xcode project - it contains markdown documentation for iOS UIKit development in both **Objective-C** (`ios/oc_uikit/`) and **Swift** (`ios/swift_uikit/`).

---

## Repository Structure

```
ios/
├── oc_uikit/           # Objective-C UIKit documentation
│   ├── skill.md        # Main skill reference
│   ├── 01-uiview.md    # UIView documentation
│   ├── 02-uiviewcontroller.md
│   ├── 10-controls.md
│   ├── 15-more-controls.md
│   ├── 20-lists-navigation.md
│   ├── 30-layout.md
│   ├── 40-interaction-animation.md
│   ├── 60-advanced.md
│   ├── 70-masonry.md
│   └── 71-masonry-comparison.md
│
└── swift_uikit/        # Swift UIKit documentation
    ├── skill.md
    ├── 01-uiview.md
    └── 02-uiviewcontroller.md
```

---

## Build / Lint / Test Commands

**This is a documentation-only repository.** There are no build, lint, or test commands because:

- No Xcode project (.xcodeproj/.xcworkspace) exists
- No source code files to compile
- No test files

If you need to create an actual iOS project from these skills, use Xcode to create a new project, then apply the code patterns documented here.

---

## Code Style Guidelines

These guidelines are derived from the skill documentation in this repository.

### Language Versions

- **Objective-C**: ARC (Automatic Reference Counting), iOS 12.0+
- **Swift**: Swift 5+, iOS 12.0+

### Imports

**Objective-C:**
```objc
#import "MyViewController.h"
#import <UIKit/UIKit.h>
```

**Swift:**
```swift
import UIKit
```

### File Organization

**Objective-C:**
```objc
// 1. Imports
// 2. Private Properties (Class Extension)
@interface MyViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

// 3. Implementation
@implementation MyViewController

#pragma mark - Lifecycle
// 生命周期方法

#pragma mark - Public Methods
// 公开方法

#pragma mark - Private Methods
// 私有方法

@end

// 4. Extensions (Protocol Conformances)
@implementation MyViewController (UITableViewDataSource)
// 代理方法
@end
```

**Swift:**
```swift
// 1. Imports
import UIKit

// 2. Class Definition
class MyViewController: UIViewController {
    
    // MARK: - Properties
    // MARK: - Initialization
    // MARK: - Lifecycle
    // MARK: - Public Methods
    // MARK: - Private Methods
}

// 3. Extensions
extension MyViewController: UITableViewDataSource {
    // 代理方法
}
```

### Naming Conventions

**Objective-C:**
- Class names: PascalCase with prefix (e.g., `MyViewController`)
- Properties/variables: camelCase (e.g., `titleLabel`)
- Methods: camelCase, verb开头 (e.g., `fetchData`)
- Constants: SCREAMING_SNAKE_CASE (e.g., `kMaxItemCount`)
- Enums: Use `NS_ENUM` macro

**Swift:**
- Class names: PascalCase (e.g., `MyViewController`)
- Properties/variables: camelCase (e.g., `titleLabel`)
- Methods: camelCase, verb开头 (e.g., `fetchData`)
- Constants: camelCase (e.g., `maxItemCount`)
- Enums: PascalCase with camelCase cases

### Comment Conventions

**Objective-C:**
```objc
#pragma mark - Lifecycle
#pragma mark - Properties
#pragma mark - Public Methods
#pragma mark - Private Methods

/**
 获取用户信息
 
 @param userID 用户 ID
 @return 用户信息对象
 */
- (nullable User *)fetchUserWithID:(NSString *)userID;
```

**Swift:**
```swift
// MARK: - Lifecycle
// MARK: - Properties
// MARK: - Public Methods
// MARK: - Private Methods

/// 获取用户信息
/// - Parameter userID: 用户 ID
/// - Returns: 用户信息对象
func fetchUser(with userID: String) -> User?
```

### Auto Layout Conventions

**Objective-C:**
```objc
self.translatesAutoresizingMaskIntoConstraints = NO;
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:parent.topAnchor constant:16],
    [view.leadingAnchor constraintEqualToAnchor:parent.leadingAnchor constant:16],
    [view.trailingAnchor constraintEqualToAnchor:parent.trailingAnchor constant:-16],
    [view.heightAnchor constraintEqualToConstant:50]
]];
```

**Swift:**
```swift
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 16),
    view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
    view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
    view.heightAnchor.constraint(equalToConstant: 50)
])
```

### Error Handling

**Objective-C:**
```objc
- (void)fetchDataWithCompletion:(void(^)(NSData *_Nullable data, NSError *_Nullable error))completion {
    // Check for invalid URL
    if (!url) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"URLErrorDomain" 
                                                 code:-1 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid URL"}];
            completion(nil, error);
        }
        return;
    }
    // Handle error in completion
}
```

**Swift:**
```swift
func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: "https://api.example.com/data") else {
        completion(.failure(URLError(.badURL)))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        completion(.success(data))
    }.resume()
}
```

### Memory Management

**Objective-C:**
```objc
- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```

**Swift:**
```swift
deinit {
    print("\(type(of: self)) dealloc")
    NotificationCenter.default.removeObserver(self)
}
```

### Cell Reuse Pattern

**Objective-C:**
```objc
@interface CustomCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
+ (NSString *)identifier;
- (void)configureWithText:(NSString *)text;
@end

@implementation CustomCell

+ (NSString *)identifier {
    return @"CustomCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style 
              reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_label];
        [self setupConstraints];
    }
    return self;
}

- (void)configureWithText:(NSString *)text {
    self.label.text = text;
}

@end
```

**Swift:**
```swift
class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(text: String) {
        label.text = text
    }
}

// 使用
tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
```

### Lifecycle Methods Order

**UIViewController Lifecycle (both languages):**
1. `loadView` - 加载视图
2. `viewDidLoad` - 视图加载完成
3. `viewWillAppear:` - 视图即将显示
4. `viewDidAppear:` - 视图已显示
5. `viewWillDisappear:` - 视图即将消失
6. `viewDidDisappear:` - 视图已消失

---

## What This Repository Contains

This repository provides:
- Code examples for UIKit development
- Best practices for iOS development
- Problem-solving guides for common issues
- Architecture guidance (MVC pattern)

This repository does NOT provide:
- SwiftUI support (UIKit only)
- Both languages in the same context (keep them separate)
- Backend service development guidance
- App Store submission help

---

## Key Documentation Files

- `ios/oc_uikit/skill.md` - Main Objective-C UIKit reference
- `ios/swift_uikit/skill.md` - Main Swift UIKit reference
- `ios/oc_uikit/uikit-develop-skill-documentation.md` - UIKit basics

---

*Last updated: 2026-03-04*