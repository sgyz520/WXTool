#import "WCMediaStack.h"
#import <UIKit/UIKit.h>

// Forward declaration for the settings view controller defined in the bundle
@interface WXRootListController : UIViewController
@end

static BOOL enableMediaStack = YES;
static BOOL enableAntiRecall = YES;

static void loadSettings() {
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    enableMediaStack = [settings[@"enableMediaStack"] boolValue];
    enableAntiRecall = [settings[@"enableAntiRecall"] boolValue];
    
    NSLog(@"[WXTool] Settings loaded: MediaStack=%@, AntiRecall=%@", 
          enableMediaStack ? @"ON" : @"OFF", 
          enableAntiRecall ? @"ON" : @"OFF");
}

%hook MsgMediaGroupMgr

- (long long)enableFlag {
    if (enableMediaStack) {
        NSLog(@"[WXTool][MediaStack] ✓ enableFlag called, returning 2");
        return 2;
    }
    NSLog(@"[WXTool][MediaStack] ✗ Feature disabled, returning original");
    return %orig;
}

%end

%hook CMessageMgr

- (void)onRevokeMsg:(id)arg {
    if (enableAntiRecall) {
        NSLog(@"[WXTool][AntiRecall] ✓ Blocked recall (onRevokeMsg)");
        return;
    }
    %orig;
}

- (void)onRevokeMessage:(id)arg {
    if (enableAntiRecall) {
        NSLog(@"[WXTool][AntiRecall] ✓ Blocked recall (onRevokeMessage)");
        return;
    }
    %orig;
}

- (void)RevokeMsg:(id)arg {
    if (enableAntiRecall) {
        NSLog(@"[WXTool][AntiRecall] ✓ Blocked recall (RevokeMsg)");
        return;
    }
    %orig;
}

%end

// ==================== 设置入口注入 ====================

// 代理类：拦截 tableView 的 dataSource 和 delegate 方法，注入 WXTool 入口
@interface WXToolSettingsProxy : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) id<UITableViewDataSource> originalDataSource;
@property (nonatomic, strong) id<UITableViewDelegate> originalDelegate;
@property (nonatomic, weak) UIViewController *hostVC;
@end

@implementation WXToolSettingsProxy

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.originalDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.originalDataSource numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger original = 0;
    if ([self.originalDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        original = [self.originalDataSource tableView:tableView numberOfRowsInSection:section];
    }
    // 在第一个 section 插入一行
    if (section == 0) {
        return original + 1;
    }
    return original;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 第一行是我们的入口
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellID = @"WXToolEntryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"WXTool";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = @"1.1.0";
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 加载图标
        NSString *iconPath = @"/Library/PreferenceBundles/WXToolPrefs.bundle/icon.png";
        UIImage *icon = [UIImage imageWithContentsOfFile:iconPath];
        if (icon) {
            cell.imageView.image = icon;
        }
        return cell;
    }
    
    // 其他行交给原始 dataSource
    NSIndexPath *originalIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    if (indexPath.section == 0) {
        return [self.originalDataSource tableView:tableView cellForRowAtIndexPath:originalIndexPath];
    }
    return [self.originalDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击我们的入口
    if (indexPath.section == 0 && indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        WXRootListController *settingsVC = [[WXRootListController alloc] init];
        [self.hostVC.navigationController pushViewController:settingsVC animated:YES];
        return;
    }
    
    // 其他行交给原始 delegate 处理
    NSIndexPath *originalIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    if (indexPath.section == 0) {
        if ([self.originalDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.originalDelegate tableView:tableView didSelectRowAtIndexPath:originalIndexPath];
        }
    } else {
        if ([self.originalDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.originalDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

// 转发其他 delegate 方法
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;
    if ([self.originalDelegate respondsToSelector:aSelector]) return YES;
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.originalDelegate respondsToSelector:aSelector]) {
        return self.originalDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

// Hook 所有 UIViewController 来找到微信设置页面并注入入口
static BOOL hasInjectedEntry = NO;

%hook UIViewController

- (void)viewDidLoad {
    %orig;
    
    if (hasInjectedEntry) return;
    
    NSString *className = NSStringFromClass([self class]);
    NSString *title = self.title ? self.title : @"(no title)";
    
    // 检查是否是设置页面
    if ([title containsString:@"设置"] || [title containsString:@"Setting"] || 
        [className containsString:@"Setting"] || [className containsString:@"setting"]) {
        
        NSLog(@"[WXTool] ✓ Found settings page: %@", className);
        
        @try {
            // 查找 tableView
            UITableView *tableView = nil;
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[UITableView class]]) {
                    tableView = (UITableView *)subview;
                    break;
                }
            }
            
            if (tableView && tableView.dataSource) {
                NSLog(@"[WXTool] Injecting entry cell into settings table");
                
                // 创建代理
                WXToolSettingsProxy *proxy = [[WXToolSettingsProxy alloc] init];
                proxy.originalDataSource = tableView.dataSource;
                proxy.originalDelegate = tableView.delegate;
                proxy.hostVC = self;
                
                // 替换 dataSource 和 delegate
                tableView.dataSource = proxy;
                tableView.delegate = proxy;
                
                hasInjectedEntry = YES;
                NSLog(@"[WXTool] ✓ Entry cell injected successfully");
            }
        } @catch (NSException *exception) {
            NSLog(@"[WXTool] Error injecting entry: %@", exception);
        }
    }
}

%end

%ctor {
    loadSettings();

    NSLog(@"+--------------------------------+");
    NSLog(@"| WXTool v%-21s |", VERSION_STRING);
    NSLog(@"| WeChat: %-19s |", [WC_SUPPORTED_WECHAT_VERSION UTF8String]);
    NSLog(@"| Author: 施主见谅               |");
    NSLog(@"+--------------------------------+");
    NSLog(@"[WXTool] ✓ Plugin loaded successfully");
    NSLog(@"[WXTool] ✓ Hook targets:");
    NSLog(@"[WXTool]   - MsgMediaGroupMgr::enableFlag");
    NSLog(@"[WXTool]   - CMessageMgr::onRevokeMsg/onRevokeMessage/RevokeMsg");
    NSLog(@"[WXTool]   - Settings entry injection via proxy");
    
    Class prefsClass = NSClassFromString(@"WXRootListController");
    if (prefsClass) {
        NSLog(@"[WXTool] ✓ WXRootListController class found");
    } else {
        NSLog(@"[WXTool] ✗ WXRootListController class NOT found");
    }
}