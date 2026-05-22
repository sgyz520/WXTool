#import "WCMediaStack.h"
#import <UIKit/UIKit.h>

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

// Hook 所有 UIViewController 来找到微信设置页面
%hook UIViewController

- (void)viewDidLoad {
    %orig;
    
    NSString *className = NSStringFromClass([self class]);
    NSString *title = self.title ? self.title : @"(no title)";
    
    NSLog(@"[WXTool] UIViewController loaded: %@, title: %@", className, title);
    
    // 检查是否是设置页面
    if ([title containsString:@"设置"] || [title containsString:@"Setting"] || 
        [className containsString:@"Setting"] || [className containsString:@"setting"]) {
        NSLog(@"[WXTool] ✓ Found possible settings page: %@", className);
        
        @try {
            NSLog(@"[WXTool] Trying to add WXTool entry to: %@", className);
            
            // 简单查找 tableView - 只找第一层
            UITableView *tableView = nil;
            for (UIView *subview in self.view.subviews) {
                if ([subview isKindOfClass:[UITableView class]]) {
                    tableView = (UITableView *)subview;
                    NSLog(@"[WXTool] Found tableView in view");
                    break;
                }
            }
            
            if (tableView) {
                NSLog(@"[WXTool] TableView class: %@, dataSource: %@, delegate: %@", 
                      NSStringFromClass([tableView class]), 
                      tableView.dataSource ? NSStringFromClass([tableView.dataSource class]) : @"(null)",
                      tableView.delegate ? NSStringFromClass([tableView.delegate class]) : @"(null)");
            }
            
        } @catch (NSException *exception) {
            NSLog(@"[WXTool] Error: %@", exception);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
    
    NSString *className = NSStringFromClass([self class]);
    NSString *title = self.title ? self.title : @"(no title)";
    
    NSLog(@"[WXTool] UIViewController appearing: %@, title: %@", className, title);
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
    NSLog(@"[WXTool]   - SettingsTableViewController (for settings entry)");
    
    Class prefsClass = NSClassFromString(@"WXRootListController");
    if (prefsClass) {
        NSLog(@"[WXTool] ✓ WXRootListController class found");
    } else {
        NSLog(@"[WXTool] ✗ WXRootListController class NOT found");
    }
}