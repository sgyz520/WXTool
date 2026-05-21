#import "WCMediaStack.h"

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
}