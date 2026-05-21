#import "WCMediaStack.h"

%ctor {
    NSLog(@"+--------------------------------+");
    NSLog(@"| WXTool v%-21s |", VERSION_STRING);
    NSLog(@"| WeChat: %-19s |", [WC_SUPPORTED_WECHAT_VERSION UTF8String]);
    NSLog(@"| Author: 施主见谅               |");
    NSLog(@"+--------------------------------+");

#ifdef ENABLE_MEDIA_STACK
    WCLog(WCFEATURE_MEDIA_STACK, @"Feature loaded");
#endif

#ifdef ENABLE_ANTI_RECALL
    WCLog(WCFEATURE_ANTI_RECALL, @"Feature loaded");
#endif

    NSLog(@"+----------------------------+");
}